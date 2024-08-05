class_name Hand
extends HBoxContainer

const CARD_UI_SCENE := preload("res://scenes/card/card_ui.tscn")

@export var player: Player
@export var char_stats: CharacterStats


func add_card(card: Card) -> void:
	var new_card_ui := CARD_UI_SCENE.instantiate() as CardUI
	add_child(new_card_ui)
	new_card_ui.reparent_requested.connect(_on_card_ui_reparent_requested)
	new_card_ui.card = card
	new_card_ui.parent = self
	new_card_ui.char_stats = char_stats
	new_card_ui.player_modifiers = player.modifier_handler
	resize_hand()


func resize_hand():
	var cardcount = get_child_count()
	var new_card_ui := CARD_UI_SCENE.instantiate() as CardUI
	if floori((custom_minimum_size.x + 4 - 4*cardcount) / cardcount) < new_card_ui.size.x:
		for card_in_hand : CardUI in get_children():
			card_in_hand.custom_minimum_size.x = floori(((custom_minimum_size.x-100)/(cardcount-1))-4)


func discard_card(card: CardUI) -> void:
	card.queue_free()
	resize_hand()


func disable_hand() -> void:
	for card: CardUI in get_children():
		card.disabled = true


func _on_card_ui_reparent_requested(child: CardUI) -> void:
	child.disabled = true
	child.reparent(self)
	var new_index := clampi(child.original_index, 0, get_child_count())
	move_child.call_deferred(child, new_index)
	child.set_deferred("disabled", false)
