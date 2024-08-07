class_name ShopRelic
extends VBoxContainer

@export var relic: Relic : set = set_relic

@onready var relic_container = %RelicContainer
@onready var buy_button: Button = %BuyButton
@onready var icon = $RelicContainer/Icon

var player: Player
var shop: ShopPopup
var map: Map
var mouse_over_card := false


func _ready():
	if not is_node_ready():
		await ready
	player = get_tree().get_first_node_in_group("player")
	shop = get_tree().get_first_node_in_group("shop")
	map = get_tree().get_first_node_in_group("map")


func update() -> void:
	if not relic_container or not buy_button:
		return
	
	var modified_price : int = shop.modifier_handler.get_modified_value(relic.price, Modifier.Type.DRAFT_COST)
	buy_button.text = str(modified_price)
	
	if player.stats.gold >= modified_price:
		buy_button.disabled = false
	else:
		buy_button.disabled = true


func set_relic(new_relic: Relic) -> void:
	if not is_node_ready():
		await ready
	
	relic = new_relic
	
	icon.texture = relic.icon
	buy_button.text = str(shop.modifier_handler.get_modified_value(relic.price, Modifier.Type.DRAFT_COST))


func _on_buy_button_pressed():
	buy_button.disabled = true
	Events.relic_gained.emit(relic)
	relic_container.queue_free()
	buy_button.queue_free()
	map.occupied_room.this_shop_relics.relics.erase(relic)
	player.stats.gold -= relic.price


func _on_card_container_mouse_entered():
	mouse_over_card = true
	print(mouse_over_card)


func _on_card_container_mouse_exited():
	mouse_over_card = false
	print(mouse_over_card)


func _on_card_container_gui_input(event):
	if event.is_action_pressed("right_mouse") and mouse_over_card:
		pass
		#Events.tooltip_requested.emit(card.art, card.title, card.get_default_tooltip())
