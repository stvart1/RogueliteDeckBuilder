extends EnemyStats

const BUREAUCRACY = preload("res://statuses/bureaucracy.tres")


func on_spawn(enemy: Enemy):
	enemy.status_handler.add_status(BUREAUCRACY)


func on_death(enemy:Enemy):
	enemy.status_handler.remove_status(BUREAUCRACY)
