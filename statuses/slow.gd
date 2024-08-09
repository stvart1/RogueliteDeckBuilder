class_name SlowStatus
extends Status

var UID: String

func initialize_status(_target: Node):
	#assert(target.get("modifier_handler"), "No modifiers on %s" % target)
	var target = _target.get_tree().get_first_node_in_group("map")
	UID = _target.UID
	var move_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.MOVE_COST)
	#assert(draft_cost_modifier, "No draft cost modifier")
	
	var slow_modifier_value := move_modifier.get_value(UID)
	
	if not slow_modifier_value:
		slow_modifier_value = ModifierValue.create_new_modifier(UID, ModifierValue.Type.FLAT)
		slow_modifier_value.value = 1
		move_modifier.add_new_value(slow_modifier_value)


func deinitialize_status(_target: Node):
	var target = _target.get_tree().get_first_node_in_group("map")
	UID = _target.UID
	var move_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.MOVE_COST)
	#assert(draft_cost_modifier, "No draft cost modifier")
	
	var slow_modifier_value := move_modifier.get_value(UID)
	
	slow_modifier_value.queue_free()
