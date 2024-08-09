class_name CharacterStats
extends Stats

@export_group("Visuals")
@export var character_name: String
@export_multiline var description: String
@export var portrait: Texture

@export_group("Gameplay Data")
@export var starting_deck: CardPile
@export var draftable_cards: CardPile
@export var cards_per_turn: int
@export var max_mana: int
@export var starting_move = 0
@export var starting_fight = 0
@export var starting_buy = 0

@export var starting_relic: Relic

var mana: int : set = set_mana
var deck: CardPile
var discard: CardPile
var draw_pile: CardPile
var move: int : set = set_move
var fight: int : set = set_fight
var buy: int : set = set_buy
var gold: int : set = set_gold
var has_key := false : set = set_has_key
var fatigued := false : set = set_fatigue

var has_coffee:= false


func set_move(value: int):
	move = clampi(value, 0, 999)
	Events.stats_changed.emit()


func set_fight(value: int):
	fight = clampi(value, 0, 999)
	Events.stats_changed.emit()


func set_buy(value: int):
	buy = clampi(value, 0, 999)
	Events.stats_changed.emit()


func set_gold(value: int):
	gold = clampi(value, 0 , 999)
	Events.stats_changed.emit()


func set_has_key(value: bool):
	has_key = value
	Events.stats_changed.emit()


func set_fatigue(value: bool):
	fatigued = value
	Events.stats_changed.emit()


func gain_move(value: int) -> void:
	move += value
	Events.stats_changed.emit()


func gain_fight(value: int) -> void:
	fight += value
	Events.stats_changed.emit()


func gain_buy(value: int) -> void:
	buy += value
	Events.stats_changed.emit()


func set_mana(value: int) -> void:
	mana = value
	Events.stats_changed.emit()


func reset_mana() -> void:
	mana = max_mana


func take_damage(damage: int) -> void:
	var initial_health := health
	super.take_damage(damage)
	if initial_health > health:
		Events.player_hit.emit()


func can_play_card(_card: Card) -> bool:
	return true


func create_instance() -> Resource:
	var instance: CharacterStats = self.duplicate()
	instance.health = max_health
	instance.block = 0
	instance.reset_mana()
	instance.deck = instance.starting_deck.duplicate()
	instance.draw_pile = CardPile.new()
	instance.discard = CardPile.new()
	return instance
