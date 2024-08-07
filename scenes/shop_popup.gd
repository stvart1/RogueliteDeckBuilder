class_name ShopPopup
extends CanvasLayer

const SHOP_CARD = preload("res://scenes/card/shop_card.tscn")
const SHOP_RELIC = preload("res://scenes/shop_relic.tscn")

@export var shop_cards: CardPile : set = set_shop_cards
@export var shop_relics: RelicPile : set = set_shop_relics

@onready var modifier_handler = $ModifierHandler
@onready var shop_card_row = $ShopCardRow
@onready var shop_relic_row = $ShopRelicRow

var player: Player
var map: Map


func _ready():
	player = get_tree().get_first_node_in_group("player")
	map = get_tree().get_first_node_in_group("map")
	#	clear test cards
	for shopcard: ShopCard in shop_card_row.get_children():
		shopcard.queue_free()
	
	Events.stats_changed_delay.connect(update_cards)
	Events.stats_changed_delay.connect(update_relics)


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

func set_shop_relics(relics_to_set: RelicPile):
	shop_relics = relics_to_set.duplicate()
	
	for relic: Relic in shop_relics.relics:
		#	create new shoprelic interface
		var new_shop_relic := SHOP_RELIC.instantiate() as ShopRelic
		#	add new interface to shop grid
		shop_relic_row.add_child(new_shop_relic)
		#	add relic to new relic_ui
		new_shop_relic.relic = relic
	
	update_relics()


func _on_gray_out_gui_input(event):
	if event.is_action_pressed("right_mouse") or event.is_action_pressed("left_mouse"):
		for shopcard: ShopCard in shop_card_row.get_children():
			shopcard.queue_free()
		for shoprelic: ShopRelic in shop_relic_row.get_children():
			shoprelic.queue_free()
		visible = false


func update_cards():
	for shop_card: ShopCard in shop_card_row.get_children():
		if not shop_card.is_queued_for_deletion():
			shop_card.update()


func update_relics():
	for shop_relic: ShopRelic in shop_relic_row.get_children():
		if not shop_relic.is_queued_for_deletion():
			shop_relic.update()
