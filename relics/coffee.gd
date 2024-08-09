extends Relic


func on_aquire(player: Player):
	player.stats.has_coffee = true
