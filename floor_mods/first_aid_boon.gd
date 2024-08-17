extends FloorModifier

var healing: int

func set_difficulty(diff: Difficulty):
	difficulty = diff
	match difficulty:
		Difficulty.EASY:
			healing = 1
		Difficulty.MEDIUM:
			healing = 2
		Difficulty.HARD:
			healing = 3


func get_description() -> String:
	return description % healing


func selected():
	Events.level_enetered.connect(floor_cleared, CONNECT_ONE_SHOT)
	var target = map
	var heal_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.FIRST_AID_HEALING)
	#assert(draft_cost_modifier, "No draft cost modifier")
	
	var heal_modifier_value := heal_modifier.get_value(name)
	
	if not heal_modifier_value:
		heal_modifier_value = ModifierValue.create_new_modifier(name, ModifierValue.Type.FLAT)
		heal_modifier_value.value = healing
		heal_modifier.add_new_value(heal_modifier_value)



func floor_cleared(_level: int):
	var target = map
	var heal_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.FIRST_AID_HEALING)
	#assert(draft_cost_modifier, "No draft cost modifier")
	
	var heal_modifier_value := heal_modifier.get_value(name)
	
	heal_modifier_value.queue_free()
