extends Card

@export var reduction := 1


func get_default_tooltip():
	return tooltip_text % reduction


func get_updated_tooltip(_player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler): # step 7.1
	return tooltip_text % reduction


func apply_effects(_targets: Array[Node], _modifiers: ModifierHandler):
	var enemy_handler = _targets[0].get_tree().get_first_node_in_group("enemy_handler")
	for boardenemy: BoardEnemy in enemy_handler.enemy_grid_container.get_children():
		if boardenemy.fight > 0:
			boardenemy.fight -= reduction
			boardenemy.update_button()
	
