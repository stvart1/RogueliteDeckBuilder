class_name  VoucherStatus
extends Status



func initialize_status(_target: Node):
	#assert(target.get("modifier_handler"), "No modifiers on %s" % target)
	var target = _target.get_tree().get_first_node_in_group("draft_area")
	var draft_cost_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.DRAFT_COST)
	#assert(draft_cost_modifier, "No draft cost modifier")
	
	var voucher_modifier_value := draft_cost_modifier.get_value("voucher")
	
	if not voucher_modifier_value:
		voucher_modifier_value = ModifierValue.create_new_modifier("voucher", ModifierValue.Type.SET)
		voucher_modifier_value.value = 0
		draft_cost_modifier.add_new_value(voucher_modifier_value)
	
	if not status_changed.is_connected(_on_status_changed):
		status_changed.connect(_on_status_changed.bind(draft_cost_modifier))
	
	if not Events.card_drafted.is_connected(_on_card_drafted):
		Events.card_drafted.connect(_on_card_drafted)


func _on_status_changed(draft_cost_modifier: Modifier):
	if stacks <= 0 and draft_cost_modifier:
		draft_cost_modifier.remove_value("voucher")


func _on_card_drafted(_card: Card):
	print("voucher.onDraft")
	stacks -= 1
