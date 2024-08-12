extends FloorModifier

var multipliter: int
var real_weight_change: int

func set_difficulty(diff: Difficulty):
	difficulty = diff
	match difficulty:
		Difficulty.EASY:
			multipliter = 50
			real_weight_change = 14
		Difficulty.MEDIUM:
			multipliter = 100
			real_weight_change = 33
		Difficulty.HARD:
			multipliter = 150
			real_weight_change = 60


func get_description() -> String:
	return description % multipliter


func selected():
	Events.level_enetered.connect(floor_cleared, CONNECT_ONE_SHOT)
	var target = map.map_generator
	var security_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.SECURITY_CHANCE)
	#assert(draft_cost_modifier, "No draft cost modifier")
	
	var security_modifier_value := security_modifier.get_value(name)
	
	if not security_modifier_value:
		security_modifier_value = ModifierValue.create_new_modifier(name, ModifierValue.Type.FLAT)
		security_modifier_value.value = real_weight_change
		security_modifier.add_new_value(security_modifier_value)



func floor_cleared(_level: int):
	var target = enemy_handler
	var security_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.SECURITY_CHANCE)
	#assert(draft_cost_modifier, "No draft cost modifier")
	
	var security_modifier_value := security_modifier.get_value(name)
	
	security_modifier_value.queue_free()
