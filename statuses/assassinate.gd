class_name  AssassinateStatus
extends Status



func initialize_status(_target: Node):
	#assert(target.get("modifier_handler"), "No modifiers on %s" % target)
	var target = _target.get_tree().get_first_node_in_group("enemy_handler")
	var fight_cost_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.FIGHT_COST)
	#assert(draft_cost_modifier, "No draft cost modifier")
	
	var assasinate_modifier_value := fight_cost_modifier.get_value("assassinate")
	
	if not assasinate_modifier_value:
		assasinate_modifier_value = ModifierValue.create_new_modifier("assassinate", ModifierValue.Type.SET)
		assasinate_modifier_value.value = 0
		fight_cost_modifier.add_new_value(assasinate_modifier_value)
	
	if not status_changed.is_connected(_on_status_changed):
		status_changed.connect(_on_status_changed.bind(fight_cost_modifier))
	
	if not Events.enemy_died.is_connected(_on_card_drafted):
		Events.enemy_died.connect(_on_card_drafted)


func _on_status_changed(fight_cost_modifier: Modifier):
	if stacks <= 0 and fight_cost_modifier:
		fight_cost_modifier.remove_value("assassinate")


func _on_card_drafted(_enemy: Enemy):
	stacks -= 1
