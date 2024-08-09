extends Relic


func on_aquire(player: Player):
	var draw_modifier: Modifier = player.modifier_handler.get_modifier(Modifier.Type.DRAW_PER_TURN)
	
	var draw_modifier_value := draw_modifier.get_value(id)
	
	if not draw_modifier_value:
		draw_modifier_value = ModifierValue.create_new_modifier(id, ModifierValue.Type.FLAT)
		draw_modifier_value.value = 1
		draw_modifier.add_new_value(draw_modifier_value)


