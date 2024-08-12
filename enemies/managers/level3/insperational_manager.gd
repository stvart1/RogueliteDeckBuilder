extends EnemyStats

@export var frequency : int

var counter : int : set = set_counter
var enemy: Enemy
var enemy_handler: EnemyHandler


func on_spawn(enemy_set: Enemy):
	enemy = enemy_set
	enemy_handler = enemy.get_tree().get_first_node_in_group("enemy_handler")
	counter = 0
	enemy.counter.visible = true

func turn(_enemy: Enemy):
	counter += 1
	if counter >= frequency:
		for enemy_buffing: BoardEnemy in enemy_handler.enemy_grid_container.get_children():
			if enemy_buffing.enemy != self:
				enemy_buffing.enemy.health += 1
		counter = 0


func set_counter(value: int):
	counter = value
	enemy.counter.text = str(counter)


func get_description() -> String:
	return description % frequency
