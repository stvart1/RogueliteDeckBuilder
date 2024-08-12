extends FloorModifier

var frequency:= 1
var counter:= 0

func set_difficulty(diff: Difficulty):
	difficulty = diff
	match difficulty:
		Difficulty.EASY:
			frequency = 1
		Difficulty.MEDIUM:
			frequency = 2
		Difficulty.HARD:
			frequency = 3


func get_description() -> String:
	return description % frequency


func selected():
	Events.activate_start_of_turn_relics.connect(start_turn)


func start_turn(_player: Player):
	counter += 1
	print("boon: %s" % counter)
	if counter >= frequency:
		Events.player_draw_cards.emit(1)
		counter = 0


func floor_cleared(_level: int):
	Events.activate_start_of_turn_relics.disconnect(start_turn)
