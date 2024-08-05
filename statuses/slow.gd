class_name Slow
extends Status

func initialize_status(_target: Node):
	#assert(target.get("modifier_handler"), "No modifiers on %s" % target)
	var target = _target.get_tree().get_first_node_in_group("map")
	var move_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.MOVE_COST)
	#assert(draft_cost_modifier, "No draft cost modifier")
	
	var slow_modifier_value := move_modifier.get_value(id)
	
	if not slow_modifier_value:
		slow_modifier_value = ModifierValue.create_new_modifier(id, ModifierValue.Type.FLAT)
		slow_modifier_value.value = 1
		move_modifier.add_new_value(slow_modifier_value)
	
