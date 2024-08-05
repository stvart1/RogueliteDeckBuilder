class_name OpenMindedStatus
extends Status


func initialize_status(_target: Node):
	#assert(target.get("modifier_handler"), "No modifiers on %s" % target)
	var target = _target.get_tree().get_first_node_in_group("draft_area")
	var draft_refresh_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.DRAFT_REFRESH)
	#assert(draft_cost_modifier, "No draft cost modifier")
	
	var openminded_modifier_value := draft_refresh_modifier.get_value(id)
	
	if not openminded_modifier_value:
		openminded_modifier_value = ModifierValue.create_new_modifier(id, ModifierValue.Type.SET)
		openminded_modifier_value.value = 0
		draft_refresh_modifier.add_new_value(openminded_modifier_value)
	
	if not status_changed.is_connected(_on_status_changed):
		status_changed.connect(_on_status_changed.bind(draft_refresh_modifier))
	
	if not Events.draft_refresh_button_pressed.is_connected(_on_refresh_button_pressed):
		Events.draft_refresh_button_pressed.connect(_on_refresh_button_pressed)


func _on_status_changed(draft_refresh_modifier: Modifier):
	if stacks <= 0 and draft_refresh_modifier:
		draft_refresh_modifier.remove_value(id)


func _on_refresh_button_pressed():
	stacks -= 1
