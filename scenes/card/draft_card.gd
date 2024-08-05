class_name DraftCard
extends VBoxContainer

const CARD_MENU_UI = preload("res://scenes/ui/card_menu_ui.tscn")

@export var card: Card : set = set_card

@onready var card_container: CenterContainer = %CardContainer
@onready var draft_button: Button = %DraftButton

var draft_area: Node2D
var player: Node2D
var current_card_ui: CardMenuUI
var mouse_over_card := false

func _ready():
	if not is_node_ready():
		await ready
	draft_area = get_tree().get_first_node_in_group("draft_area")
	player = get_tree().get_first_node_in_group("player")

func update() -> void:
	if not card_container or not draft_button:
		return
	
	var modified_price : int = draft_area.modifier_handler.get_modified_value(card.price, Modifier.Type.DRAFT_COST)
	draft_button.text = str(modified_price)
	
	if player.stats.buy >= modified_price:
		draft_button.disabled = false
	else:
		draft_button.disabled = true


func set_card(new_card: Card) -> void:
	if not is_node_ready():
		await ready

	card = new_card
	
	for card_menu_ui: CardMenuUI in card_container.get_children():
		card_menu_ui.queue_free()
	
	var new_card_menu_ui := CARD_MENU_UI.instantiate() as CardMenuUI
	card_container.add_child(new_card_menu_ui)
	new_card_menu_ui.card = card
	current_card_ui = new_card_menu_ui
	draft_button.text = str(draft_area.modifier_handler.get_modified_value(current_card_ui.card.price, Modifier.Type.DRAFT_COST))


func _on_draft_button_pressed():
	draft_button.disabled = true
	Events.card_drafted.emit(card)
	Events.player_gain_buy.emit(-draft_area.modifier_handler.get_modified_value(card.price, Modifier.Type.DRAFT_COST))
	card_container.queue_free()
	draft_button.queue_free()


func _on_card_container_mouse_entered():
	mouse_over_card = true
	print(mouse_over_card)


func _on_card_container_mouse_exited():
	mouse_over_card = false
	print(mouse_over_card)


func _on_card_container_gui_input(event):
	if event.is_action_pressed("right_mouse") and mouse_over_card:
		Events.tooltip_requested.emit(card.art, card.title, card.get_default_tooltip())
