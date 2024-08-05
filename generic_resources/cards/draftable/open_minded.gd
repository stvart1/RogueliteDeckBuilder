extends Card

const OPEN_MINDED = preload("res://statuses/open_minded.tres")

@export var stacks := 1

func get_default_tooltip():
	return (tooltip_text % stacks)


func get_updated_tooltip(_player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler): # step 7.1
	return tooltip_text


func apply_effects(targets: Array[Node], _modifiers: ModifierHandler):
	
	var player = targets[0] 
	print("effecting %s with %s" % [player, title])
	
	var status_effect := StatusEffect.new()
	var open_minded := OPEN_MINDED.duplicate()
	open_minded.stacks = stacks
	status_effect.status = open_minded
	status_effect.execute(targets)
