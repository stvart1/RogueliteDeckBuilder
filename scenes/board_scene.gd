class_name BoardScene
extends Node2D

const TOOLTIP_POPUP = preload("res://scenes/ui/tooltip_popup.tscn")
const TEST_MANAGER = preload("res://enemies/test_manager.tres")
const MAIN_MENU_PATH = "res://scenes/main_menu.tscn"

@export var character: CharacterStats : set = set_character
@export var run_startup: RunStartup

@onready var resource_bar = $ResourceBar/ResourceBar
@onready var player = $Player
@onready var player_handler = $PlayerHandler
@onready var play_area = $PlayArea
@onready var enemy_handler = $EnemyHandler
@onready var tooltip_popup = $Tooltip/TooltipPopup
@onready var map = $Map
@onready var pause_menu = %PauseMenu
@onready var draft_area = $DraftArea
@onready var shop_popup = $ShopPopup
@onready var card_pile_viewer = $CardPileView/CardPileViewer

@onready var draw_pile_button = %DrawPileButton
@onready var hand = %Hand
@onready var discard_pile_button = %DiscardPileButton

@onready var relic_container = %RelicContainer

var save_data: SaveGame

func _ready():
	Events.card_drafted.connect(card_drafted)
	Events.tooltip_requested.connect(show_tooltip)
	Events.player_hand_discarded.connect(save_run)
	Events.player_died.connect(game_over)
	Events.game_finished.connect(game_over)
	match run_startup.type:
		RunStartup.Type.NEW_RUN:
			character = run_startup.character
			_start_new_run()
		RunStartup.Type.CONTINUE_RUN:
			_load_run()
		_:
			print("RunStartup mismatch")

func _start_new_run(): 
	map.generate_new_map()
	save_data = SaveGame.new()
	character.deck = character.starting_deck.custom_duplicate()
	player_handler.start_battle(character)
	play_area.initialize_card_pile_ui()


func save_run():
	save_data.rng_seed = RNG.instance.seed
	save_data.rng_state = RNG.instance.state
	save_data.char_stats = player.stats
	save_data.current_hp = player.stats.health
	save_data.current_deck = draw_pile_button.card_pile
	save_data.current_discard = discard_pile_button.card_pile
	save_data.current_hand = []
	for cardui: CardUI in hand.get_children():
		save_data.current_hand.append(cardui.card)
	save_data.relics = relic_container.owned_relics
	save_data.map_data = map.map_data.duplicate(true)
	save_data.last_room = map.occupied_room
	save_data.level = map.level
	save_data.enemy_track = []
	for boardenemy: BoardEnemy in enemy_handler.enemy_grid_container.get_children():
		save_data.enemy_track.append(boardenemy.enemy)
	save_data.draft_row = []
	for draftcard: DraftCard in draft_area.cards.get_children():
		save_data.draft_row.append(draftcard.card)
	save_data.draft_deck = draft_area.available_cards
	save_data.available_enemies = enemy_handler.available_enemies
	save_data.available_managers = enemy_handler.available_managers
	
	save_data.save_data()
	
	player_handler.start_turn()


func _load_run():
	save_data = SaveGame.load_data()
	
	RNG.set_from_save_data(save_data.rng_seed, save_data.rng_state)
	character = save_data.char_stats
	player.stats.health = save_data.current_hp
	player_handler.character.draw_pile = save_data.current_deck
	player_handler.character.discard = save_data.current_discard
	for card: Card in save_data.current_hand:
		hand.add_card(card)
	for relic: Relic in save_data.relics.relics:
		Events.relic_gained.emit(relic)
	#map.map_data = map.map_generator.setup_connections(save_data.map_data.duplicate(true))
	map.map_data = save_data.map_data.duplicate(true)
	map.occupied_room = save_data.last_room
	map.level = save_data.level
	
	for enemystat: EnemyStats in save_data.enemy_track:
		enemy_handler.progress_enemies_by_enemy(enemystat)
	draft_area.load_draft_area(save_data.draft_row)
	draft_area.available_cards = save_data.draft_deck
	enemy_handler.available_enemies = save_data.available_enemies
	enemy_handler.available_managers = save_data.available_managers
	
	play_area.initialize_card_pile_ui()
	
	map.create_map()
	player.position = map.position + map.occupied_room.pos
	
	player_handler.start_turn()


func show_tooltip(icon: Texture, title: String, text: String, array: Array = []):
	tooltip_popup.icon = icon
	tooltip_popup.text = text
	tooltip_popup.title = title
	if array:
		for statusui:StatusUI in array:
			var new_v_box = VBoxContainer.new()
			tooltip_popup.status_container.add_child(new_v_box)
			var new_stat_tooltip = statusui.duplicate()
			new_v_box.add_child(new_stat_tooltip)
			var new_label = Label.new()
			new_v_box.add_child(new_label)
			new_label.text = new_stat_tooltip.status.tooltip
	tooltip_popup.visible = true


func game_over():
	SaveGame.delete_data()
	get_tree().change_scene_to_file(MAIN_MENU_PATH)


func card_drafted(card: Card):
	character.deck.add_card(card)


func _on_plus_move_button_pressed():
	Events.player_gain_move.emit(1)


func _on_plus_move_button_2_pressed():
	Events.player_gain_move.emit(999)


func _on_plus_buy_button_pressed():
	Events.player_gain_buy.emit(1)


func set_character(value: CharacterStats):
	if not is_node_ready():
		await ready
	
	character = value
	
	play_area.char_stats = character
	player.stats = character
	player_handler.character = character
	#


#func _on_end_turn_button_pressed():
	#Events.player_turn_ended.emit()


func _on_draw_button_pressed():
	Events.player_draw_cards.emit(1)


func _on_plus_buy_button_2_pressed():
	Events.player_gain_buy.emit(999)


func _on_enemies_button_pressed():
	enemy_handler.progress_enemies(EnemyStats.Type.WORKER)


func _on_manager_enemy_pressed():
	enemy_handler.progress_enemies_by_enemy(TEST_MANAGER)


func _on_clear_enemies_button_pressed():
	for boardenemy: BoardEnemy in enemy_handler.enemy_grid_container.get_children():
		boardenemy.queue_free()


func _on_plus_fight_button_pressed():
	player.stats.fight += 1


func _on_plus_gold_button_pressed():
	player.stats.gold += 1






func _input(event: InputEvent) -> void:
	if event.is_action_pressed("space") and not pause_menu.visible and not tooltip_popup.visible and not shop_popup.visible and not card_pile_viewer.visible:
		play_area._on_end_turn_button_pressed()
