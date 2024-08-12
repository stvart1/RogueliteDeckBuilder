# Player turn order:
# 1. START_OF_TURN Relics 
# 2. START_OF_TURN Statuses
# 3. Draw Hand
# 4. End Turn 
# 5. END_OF_TURN Relics 
# 6. END_OF_TURN Statuses
# 7. Discard Hand
class_name PlayerHandler
extends Node

const HAND_DRAW_INTERVAL := 0.25
const HAND_DISCARD_INTERVAL := 0.25

#@export var relics: RelicHandler
@export var player: Player
@export var hand: Hand

var character: CharacterStats


func _ready() -> void:
	Events.card_played.connect(_on_card_played)
	Events.card_drafted.connect(card_drafted)
	Events.enemy_turn_ended.connect(discard_cards)
	#Events.player_hand_discarded.connect(start_turn)
	Events.player_draw_cards.connect(draw_cards)
	Events.discard_card.connect(discard_card)






func start_battle(char_stats: CharacterStats) -> void:
	character = char_stats
	character.draw_pile = character.deck.custom_duplicate()
	character.draw_pile.shuffle()
	character.discard = CardPile.new()
	Events.relic_gained.emit(character.starting_relic)
	#relics.relics_activated.connect(_on_relics_activated)
	player.status_handler.statuses_applied.connect(_on_statuses_applied)


func start_turn() -> void:
	character.block = 0
	character.move = 0
	character.fight = 0
	character.buy = 0
	character.fatigued = false
	character.reset_mana()
	draw_cards(player.modifier_handler.get_modified_value(character.cards_per_turn, Modifier.Type.DRAW_PER_TURN))
	Events.activate_start_of_turn_relics.emit(player)
	#relics.activate_relics_by_type(Relic.Type.START_OF_TURN)


func end_turn() -> void:
	hand.disable_hand()
	#relics.activate_relics_by_type(Relic.Type.END_OF_TURN)


func draw_card() -> void:
	reshuffle_deck_from_discard()
	if character.draw_pile.cards.size() > 0:
		hand.add_card(character.draw_pile.draw_card())


func draw_cards(amount: int) -> void:
	var tween := create_tween()
	for i in range(amount):
		tween.tween_callback(draw_card)
		tween.tween_interval(HAND_DRAW_INTERVAL)
	
	tween.finished.connect(
		func(): Events.player_hand_drawn.emit(player)
	)


func discard_cards() -> void:
	if hand.get_child_count() == 0:
		Events.player_hand_discarded.emit()
		return

	var tween := create_tween()
	var loops := 4.0
	
	for card_ui: CardUI in hand.get_children():
		loops += 1.0
		
		tween.tween_callback(character.discard.add_card.bind(card_ui.card))
		tween.tween_callback(hand.discard_card.bind(card_ui))
		tween.tween_interval(HAND_DISCARD_INTERVAL/floor(loops/5.0))
	
	tween.finished.connect(
		func():
			Events.player_hand_discarded.emit()
	)


func discard_card():
	if hand.get_child_count() == 0:
		return
	var tween := create_tween()
	
	var card_ui: CardUI = hand.get_child(RNG.instance.randi_range(0, hand.get_child_count() - 1))

	tween.tween_callback(character.discard.add_card.bind(card_ui.card))
	tween.tween_callback(hand.discard_card.bind(card_ui))
	tween.tween_interval(HAND_DISCARD_INTERVAL)


func reshuffle_deck_from_discard() -> void:
	if not character.draw_pile.empty():
		return

	while not character.discard.empty():
		character.draw_pile.add_card(character.discard.draw_card())

	character.draw_pile.shuffle()


func _on_card_played(card: Card) -> void:
	if card.exhausts:
		return
	
	character.discard.add_card(card)


func card_drafted(card: Card):
	character.discard.add_card(card)


func _on_statuses_applied(type: Status.Timing) -> void:
	match type:
		Status.Timing.START_OF_TURN:
			draw_cards(character.cards_per_turn)
		Status.Timing.END_OF_TURN:
			discard_cards()


#func _on_relics_activated(type: Relic.Type) -> void:
	#match type:
		#Relic.Type.START_OF_TURN:
			#player.status_handler.apply_statuses_by_type(Status.Type.START_OF_TURN)
		#Relic.Type.END_OF_TURN:
			#player.status_handler.apply_statuses_by_type(Status.Type.END_OF_TURN)
