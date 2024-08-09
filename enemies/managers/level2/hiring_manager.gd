extends EnemyStats


func turn(enemy: Enemy):
	var enemy_handler: EnemyHandler = enemy.get_tree().get_first_node_in_group("enemy_handler")
	enemy_handler.progress_enemies(EnemyStats.Type.WORKER)
