extends Relic

@export var healing:= 1


func start_of_turn(player: Player):
	counter += 1
	if counter > 1:
		player.stats.heal(healing)
		counter = 0
