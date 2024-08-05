extends Card

const VOUCHER = preload("res://statuses/voucher.tres")

@export var vouchers := 1

func get_default_tooltip():
	return tooltip_text


func get_updated_tooltip(_player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler): # step 7.1
	return tooltip_text


func apply_effects(targets: Array[Node], _modifiers: ModifierHandler):
	
	var player = targets[0] 
	print("effecting %s with %s" % [player, title])
	
	var status_effect := StatusEffect.new()
	var voucher := VOUCHER.duplicate()
	voucher.stacks = vouchers
	status_effect.status = voucher
	status_effect.execute(targets)
