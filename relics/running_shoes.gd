extends Relic

@export var move: int

func start_of_turn(player: Player):
	player.stats.gain_move(move)


func get_tooltip():
	return description % move
