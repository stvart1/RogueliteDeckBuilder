class_name CardPileViewer
extends ColorRect

const CARD_MENU_UI = preload("res://scenes/ui/card_menu_ui.tscn")

@onready var card_pile_title = %CardPileTitle
@onready var card_pile_grid = %CardPileGrid

var map: Map


func _ready():
	Events.cardpile_view_requested.connect(show_cardpile_view)
	map = get_tree().get_first_node_in_group("map")


func show_cardpile_view(title: String, cardpile: CardPile):
	for cardmenuui: CardMenuUI in card_pile_grid.get_children():
		cardmenuui.queue_free()
	visible = true
	card_pile_title.text = title
	for card: Card in cardpile.cards:
		var new_card := CARD_MENU_UI.instantiate() as CardMenuUI
		card_pile_grid.add_child(new_card)
		new_card.card = card


func _on_gui_input(event):
	if event.is_action_pressed("right_mouse") or event.is_action_pressed("left_mouse"):
		visible = false


func _on_visibility_changed():
	if visible:
		map.process_mode = Node.PROCESS_MODE_DISABLED
	else:
		map.process_mode = Node.PROCESS_MODE_INHERIT


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("space"):
		visible = false
