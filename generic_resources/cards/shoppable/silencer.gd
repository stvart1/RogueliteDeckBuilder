extends Card

const ASSASSINATE = preload("res://statuses/assassinate.tres")

@export var stacks := 2

func get_default_tooltip():
	return tooltip_text


func get_updated_tooltip(_player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler): # step 7.1
	return tooltip_text


func apply_effects(targets: Array[Node], _modifiers: ModifierHandler):
	
	var player = targets[0] 
	print("effecting %s with %s" % [player, title])
	
	var status_effect := StatusEffect.new()
	var assassinate := ASSASSINATE.duplicate()
	assassinate.stacks = stacks
	status_effect.status = assassinate
	status_effect.execute(targets)
