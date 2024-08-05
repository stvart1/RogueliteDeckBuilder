extends Card

@export var base_draw := 2


func get_default_tooltip():
	return tooltip_text % base_draw


func get_updated_tooltip(_player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler): # step 7.1
	return tooltip_text % base_draw


func apply_effects(_targets: Array[Node], _modifiers: ModifierHandler):
	#Events.player_draw_cards.emit(base_draw)
	var player_handler = _targets[0].get_tree().get_first_node_in_group("player_handler")
	player_handler.draw_cards(base_draw)
