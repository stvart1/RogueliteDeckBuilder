extends FloorModifier

var gold: int

func set_difficulty(diff: Difficulty):
	difficulty = diff
	match difficulty:
		Difficulty.EASY:
			gold = 1
		Difficulty.MEDIUM:
			gold = 2
		Difficulty.HARD:
			gold = 3


func get_description() -> String:
	return description % gold


func selected():
	Events.level_enetered.connect(floor_cleared, CONNECT_ONE_SHOT)
	var target = enemy_handler
	var gold_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.GOLD_EARNING)
	#assert(draft_cost_modifier, "No draft cost modifier")
	
	var gold_modifier_value := gold_modifier.get_value(name)
	
	if not gold_modifier_value:
		gold_modifier_value = ModifierValue.create_new_modifier(name, ModifierValue.Type.FLAT)
		gold_modifier_value.value = gold
		gold_modifier.add_new_value(gold_modifier_value)



func floor_cleared(_level: int):
	var target = enemy_handler
	var gold_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.GOLD_EARNING)
	#assert(draft_cost_modifier, "No draft cost modifier")
	
	var gold_modifier_value := gold_modifier.get_value(name)
	
	gold_modifier_value.queue_free()
