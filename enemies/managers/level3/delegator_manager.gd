extends EnemyStats

const DELEGATED_WORKER = preload("res://enemies/managers/level3/delegated_worker.tres")


func on_death(enemy: Enemy):
	for i: int in 4:
		Events.spawn_specific_enemy.emit(DELEGATED_WORKER)
