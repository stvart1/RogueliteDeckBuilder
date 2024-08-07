extends Relic

@export var healing := 1
@export var frequncy := 2


func start_of_turn(player: Player):
	counter += 1
	if counter >= frequncy:
		player.stats.heal(healing)
		counter = 0


func get_tooltip() -> String:
	return description % [healing, frequncy]
