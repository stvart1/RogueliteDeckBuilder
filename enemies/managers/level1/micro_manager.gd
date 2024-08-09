extends EnemyStats

const CHECK_IN = preload("res://generic_resources/cards/curses/check_in.tres")

func turn(enemy: Enemy):
	var player_handler: PlayerHandler = enemy.get_tree().get_first_node_in_group("player_handler")
	player_handler.character.draw_pile.add_card(CHECK_IN.duplicate())
	player_handler.character.draw_pile.shuffle()
