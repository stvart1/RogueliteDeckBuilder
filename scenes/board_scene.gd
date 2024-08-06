class_name BoardScene
extends Node2D

const TOOLTIP_POPUP = preload("res://scenes/ui/tooltip_popup.tscn")
const TEST_MANAGER = preload("res://enemies/test_manager.tres")

@export var character: CharacterStats 

@onready var resource_bar = $ResourceBar/ResourceBar
@onready var player = $Player
@onready var player_handler = $PlayerHandler
@onready var play_area = $PlayArea
@onready var enemy_handler = $EnemyHandler
@onready var tooltip_popup = $Tooltip/TooltipPopup
@onready var map = $Map


func _ready():
	Events.card_drafted.connect(card_drafted)
	character.deck = character.starting_deck
	player_handler.start_battle(character)
	play_area.char_stats = character
	play_area.initialize_card_pile_ui()
	Events.tooltip_requested.connect(show_tooltip)
	map.generate_new_map()


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
	player_handler.start_battle(character)


#func _on_end_turn_button_pressed():
	#Events.player_turn_ended.emit()


func _on_draw_button_pressed():
	Events.player_draw_cards.emit(1)


func _on_plus_buy_button_2_pressed():
	Events.player_gain_buy.emit(999)


func _on_enemies_button_pressed():
	enemy_handler.progress_enemies()


func _on_manager_enemy_pressed():
	enemy_handler.progress_enemies(TEST_MANAGER)


func _on_clear_enemies_button_pressed():
	for boardenemy: BoardEnemy in enemy_handler.enemy_grid_container.get_children():
		boardenemy.queue_free()


func _on_plus_fight_button_pressed():
	player.stats.fight += 1


func _on_plus_gold_button_pressed():
	player.stats.gold += 1

