extends EnemyStats

@export var tick_damage: int

func turn(_enemy: Enemy):
	enemy_dealing_damage.emit(tick_damage)


func get_description():
	return description % tick_damage
