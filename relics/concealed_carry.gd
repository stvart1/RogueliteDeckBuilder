extends Relic

@export var fight: int

func start_of_turn(player: Player):
	player.stats.gain_fight(fight)


func get_tooltip():
	return description % fight
