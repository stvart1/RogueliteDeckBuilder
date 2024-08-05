class_name ShopPopup
extends CanvasLayer

const SHOP_CARD = preload("res://scenes/card/shop_card.tscn")

@export var shop_cards: CardPile : set = set_shop_cards

@onready var modifier_handler = $ModifierHandler
@onready var shop_card_row = $ShopCardRow

var player: Player
var map: Map


func _ready():
	player = get_tree().get_first_node_in_group("player")
	map = get_tree().get_first_node_in_group("map")
	#	clear test cards
	for shopcard: ShopCard in shop_card_row.get_children():
		shopcard.queue_free()
	
	Events.stats_changed_delay.connect(update_cards)


func set_shop_cards(cardpile: CardPile):
	shop_cards = cardpile.duplicate()
	
	for card: Card in shop_cards.cards:
			#create new shopcard interface
		var new_shop_card := SHOP_CARD.instantiate() as ShopCard
			#add new interface to shop grid
		shop_card_row.add_child(new_shop_card)
			#new shopcard to card
		new_shop_card.card = card
	
	update_cards()

func _on_gray_out_gui_input(event):
	if event.is_action_pressed("right_mouse") or event.is_action_pressed("left_mouse"):
		for shopcard: ShopCard in shop_card_row.get_children():
			shopcard.queue_free()
		visible = false


func update_cards():
	for shop_card: ShopCard in shop_card_row.get_children():
		if not shop_card.is_queued_for_deletion():
			shop_card.update()
