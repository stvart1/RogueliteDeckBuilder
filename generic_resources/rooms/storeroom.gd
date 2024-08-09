class_name Storeroom
extends Room

const SHOP_CARDPILE = preload("res://generic_resources/cards/shoppable/shop_cardpile.tres")
const SHOP_RELICPILE = preload("res://relics/shop_relicpile.tres")

var this_shop_cardpile: CardPile : set = set_shop_cardpile
var this_shop_relics: RelicPile : set = set_shop_relicpile
var relic_container: RelicContainer
var relic_pool: Array[Relic]


func set_signals():
	Events.relic_gained.connect(remove_from_current_relics)


func remove_from_current_relics(relic_to_remove: Relic):
	var pre_size := this_shop_relics.relics.size()
	
	for relic: Relic in this_shop_relics.relics:
		if relic.id == relic_to_remove.id:
			this_shop_relics.relics.erase(relic)
	
	update_pool()
	
	if pre_size > this_shop_relics.relics.size() and not visited:
		this_shop_relics.relics.append(relic_pool.pop_back())


func update_pool():
	for owned_relic: Relic in relic_container.owned_relics.relics:
		for relic: Relic in relic_pool:
			if relic.id == owned_relic.id:
				relic_pool.erase(relic)
	
	RNG.array_shuffle(relic_pool)



func set_shop_cardpile(new_card_pool: CardPile):
	this_shop_cardpile = CardPile.new()
	for i : int in 3:
		this_shop_cardpile.cards.append(RNG.array_pick_random(new_card_pool.cards))



func set_shop_relicpile(new_relic_pool: RelicPile):
	this_shop_relics = RelicPile.new()
	relic_pool = new_relic_pool.duplicate_relics()
	
	update_pool()
	
	for i : int in 3:
		if relic_pool.size()>0:
			this_shop_relics.relics.append(relic_pool.pop_back())
