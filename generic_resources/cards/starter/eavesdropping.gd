extends Card

@export var base_buy := 1


func get_default_tooltip():
	return tooltip_text % base_buy

func get_updated_tooltip(_player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler): # step 7.1
	return tooltip_text % base_buy


func apply_effects(targets: Array[Node], _modifiers: ModifierHandler):
	var player = targets[0] 
	player.stats.buy += base_buy
