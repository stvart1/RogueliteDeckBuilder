class_name BureaucracyStatus
extends Status

var UID: String

func initialize_status(_target: Node):
	#assert(target.get("modifier_handler"), "No modifiers on %s" % target)
	var target = _target.get_tree().get_first_node_in_group("player")
	UID = _target.UID
	var draw_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.DRAW_PER_TURN)
	#assert(draft_cost_modifier, "No draft cost modifier")
	
	var draw_modifier_value := draw_modifier.get_value(UID)
	
	if not draw_modifier_value:
		draw_modifier_value = ModifierValue.create_new_modifier(UID, ModifierValue.Type.FLAT)
		draw_modifier_value.value = -1
		draw_modifier.add_new_value(draw_modifier_value)


func deinitialize_status(_target: Node):
	var target = _target.get_tree().get_first_node_in_group("player")
	UID = _target.UID
	var draw_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.DRAW_PER_TURN)
	#assert(draft_cost_modifier, "No draft cost modifier")
	
	var draw_modifier_value := draw_modifier.get_value(UID)
	
	draw_modifier_value.queue_free()
