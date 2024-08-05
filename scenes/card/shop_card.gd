class_name ShopCard
extends VBoxContainer

const CARD_MENU_UI = preload("res://scenes/ui/card_menu_ui.tscn")

@export var card: Card : set = set_card

@onready var card_container: CenterContainer = %CardContainer
@onready var buy_button: Button = %BuyButton

var player: Player
var shop: ShopPopup
var map: Map
var current_card_ui: CardMenuUI
var mouse_over_card := false


func _ready():
	if not is_node_ready():
		await ready
	player = get_tree().get_first_node_in_group("player")
	shop = get_tree().get_first_node_in_group("shop")
	map = get_tree().get_first_node_in_group("map")


func update() -> void:
	if not card_container or not buy_button:
		return
	
	var modified_price : int = shop.modifier_handler.get_modified_value(card.price, Modifier.Type.DRAFT_COST)
	buy_button.text = str(modified_price)
	
	if player.stats.gold >= modified_price:
		buy_button.disabled = false
	else:
		buy_button.disabled = true


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
	buy_button.text = str(shop.modifier_handler.get_modified_value(current_card_ui.card.price, Modifier.Type.DRAFT_COST))


func _on_buy_button_pressed():
	buy_button.disabled = true
	Events.card_drafted.emit(card)
	card_container.queue_free()
	buy_button.queue_free()
	map.occupied_room.this_shop_cardpile.cards.erase(card)
	player.stats.gold -= card.price


func _on_card_container_mouse_entered():
	mouse_over_card = true
	print(mouse_over_card)


func _on_card_container_mouse_exited():
	mouse_over_card = false
	print(mouse_over_card)


func _on_card_container_gui_input(event):
	if event.is_action_pressed("right_mouse") and mouse_over_card:
		Events.tooltip_requested.emit(card.art, card.title, card.get_default_tooltip())
