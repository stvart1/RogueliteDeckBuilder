extends Relic

const OPEN_MINDED = preload("res://statuses/open_minded.tres")

func start_of_turn(player: Player):
	var targets: Array[Node] = []
	targets.append(player)
	var status_effect := StatusEffect.new()
	var open_minded := OPEN_MINDED.duplicate()
	open_minded.stacks = 1
	status_effect.status = open_minded
	status_effect.execute(targets)
