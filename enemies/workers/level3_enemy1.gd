extends EnemyStats

const CHECK_IN = preload("res://generic_resources/cards/curses/check_in.tres")

@export var frequency: int

var enemy: Enemy
var counter: int : set = set_counter


func on_spawn(_enemy: Enemy):
	enemy = _enemy
	counter = 0
	enemy.counter.visible = true

func turn(_enemy: Enemy):
	counter += 1
	if counter >= frequency:
		var player_handler: PlayerHandler = _enemy.get_tree().get_first_node_in_group("player_handler")
		player_handler.character.draw_pile.add_card(CHECK_IN.duplicate())
		player_handler.character.draw_pile.shuffle()
		counter = 0


func set_counter(value: int):
	counter = value
	enemy.counter.text = str(counter)
