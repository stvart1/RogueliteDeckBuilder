class_name Storeroom
extends Room

const SHOP_CARDPILE = preload("res://generic_resources/cards/shoppable/shop_cardpile.tres")

var this_shop_cardpile: CardPile

func _ready():
	type = Room.Type.STOREROOM
	this_shop_cardpile = CardPile.new()
	var new_pool := CardPile.new()
	new_pool = SHOP_CARDPILE.custom_duplicate()
	new_pool.shuffle()
	for i : int in 3:
		this_shop_cardpile.cards.append(new_pool.cards.pop_back())
