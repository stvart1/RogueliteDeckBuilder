class_name  GarnishStatus
extends Status

var UID: String


func initialize_status(_target: Node):
	#assert(target.get("modifier_handler"), "No modifiers on %s" % target)
	var target = _target.get_tree().get_first_node_in_group("draft_area")
	UID = _target.UID
	var draft_cost_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.DRAFT_COST)
	#assert(draft_cost_modifier, "No draft cost modifier")
	
	var garnish_modifier_value := draft_cost_modifier.get_value(UID)
	
	if not garnish_modifier_value:
		garnish_modifier_value = ModifierValue.create_new_modifier(UID, ModifierValue.Type.FLAT)
		garnish_modifier_value.value = 1
		draft_cost_modifier.add_new_value(garnish_modifier_value)


func deinitialize_status(_target: Node):
	var target = _target.get_tree().get_first_node_in_group("draft_area")
	UID = _target.UID
	var draft_cost_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.DRAFT_COST)
	#assert(draft_cost_modifier, "No draft cost modifier")
	
	var garnish_modifier_value := draft_cost_modifier.get_value(UID)
	
	garnish_modifier_value.queue_free()
