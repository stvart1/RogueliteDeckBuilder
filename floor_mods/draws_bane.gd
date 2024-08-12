extends FloorModifier

var frequency:= 1
var counter:= 0

func set_difficulty(diff: Difficulty):
	difficulty = diff
	match difficulty:
		Difficulty.EASY:
			frequency = 3
		Difficulty.MEDIUM:
			frequency = 2
		Difficulty.HARD:
			frequency = 1


func get_description() -> String:
	return description % frequency


func selected():
	Events.player_hand_drawn.connect(start_turn)


func start_turn(_player: Player):
	counter += 1
	print("bane: %s" % counter)
	if counter >= frequency:
		Events.discard_card.emit()
		counter = 0


func floor_cleared(_level: int):
	Events.player_hand_drawn.disconnect(start_turn)
