extends EnemyStats

const GARNISH = preload("res://statuses/garnish.tres")


func on_spawn(enemy: Enemy):
	enemy.status_handler.add_status(GARNISH)


func on_death(enemy:Enemy):
	enemy.status_handler.remove_status(GARNISH)
