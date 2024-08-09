extends EnemyStats

const SLOW = preload("res://statuses/slow.tres")


func on_spawn(enemy: Enemy):
	enemy.status_handler.add_status(SLOW)


func on_death(enemy:Enemy):
	enemy.status_handler.remove_status(SLOW)
