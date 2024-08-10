extends EnemyStats

@export var frequency : int

var counter : int : set = set_counter
var enemy: Enemy


func on_spawn(enemy_set: Enemy):
	enemy = enemy_set
	counter = 0
	enemy.counter.visible = true

func turn(_enemy: Enemy):
	counter += 1
	if counter >= frequency:
		health += 1
		counter = 0


func set_counter(value: int):
	counter = value
	enemy.counter.text = str(counter)


func get_description() -> String:
	return description % frequency
