class_name Storeroom
extends Room

const SHOP_CARDPILE = preload("res://generic_resources/cards/shoppable/shop_cardpile.tres")
const SHOP_RELICPILE = preload("res://relics/shop_relicpile.tres")

var this_shop_cardpile: CardPile : set = set_shop_cardpile
var this_shop_relics: RelicPile : set = set_shop_relicpile


func set_shop_cardpile(new_card_pool: CardPile):
	this_shop_cardpile = CardPile.new()
	for i : int in 3:
		this_shop_cardpile.cards.append(new_card_pool.cards.pick_random())



func set_shop_relicpile(new_relic_pool: RelicPile):
	this_shop_relics = RelicPile.new()
	var temp_pool = new_relic_pool.duplicate_relics()
	temp_pool.shuffle()
	for i : int in 3:
		this_shop_relics.relics.append(temp_pool.pop_back())
