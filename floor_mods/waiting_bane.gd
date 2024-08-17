extends FloorModifier

var multipliter: int
var real_weight_change: int

func set_difficulty(diff: Difficulty):
	difficulty = diff
	match difficulty:
		Difficulty.EASY:
			multipliter = 50
			real_weight_change = 6
		Difficulty.MEDIUM:
			multipliter = 100
			real_weight_change = 13
		Difficulty.HARD:
			multipliter = 150
			real_weight_change = 20


func get_description() -> String:
	return description % multipliter


func selected():
	Events.level_enetered.connect(floor_cleared, CONNECT_ONE_SHOT)
	var target = map.map_generator
	var waiting_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.WAITING_ROOM_CHANCE)
	#assert(draft_cost_modifier, "No draft cost modifier")
	
	var waiting_modifier_value := waiting_modifier.get_value(name)
	
	if not waiting_modifier_value:
		waiting_modifier_value = ModifierValue.create_new_modifier(name, ModifierValue.Type.FLAT)
		waiting_modifier_value.value = real_weight_change
		waiting_modifier.add_new_value(waiting_modifier_value)



func floor_cleared(_level: int):
	var target = map.map_generator
	var waiting_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.WAITING_ROOM_CHANCE)
	#assert(draft_cost_modifier, "No draft cost modifier")
	
	var waiting_modifier_value := waiting_modifier.get_value(name)
	
	waiting_modifier_value.queue_free()
