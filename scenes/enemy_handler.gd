class_name EnemyHandler
extends Node2D

const BOARD_ENEMY = preload("res://scenes/enemy/board_enemy.tscn")
const TEST_ENEMY = preload("res://enemies/test_enemy.tres")

@onready var modifier_handler = $ModifierHandler
@onready var enemy_grid_container = $EnemyGridContainer

var max_enemies:= 6

func  _ready():
	Events.stats_changed_delay.connect(update_enemy_buttons)
	Events.enemy_died.connect(enemy_died)
	Events.player_turn_ended.connect(enemy_turn)

func enemy_died(enemy: Enemy):
	enemy.stats.on_death(enemy)


func enemy_turn():
	for boardenemy: BoardEnemy in enemy_grid_container.get_children():
		boardenemy.enemy.turn(boardenemy.enemy_visuals)
	
	progress_enemies()
	
	Events.enemy_turn_ended.emit()


func progress_enemies(_enemy: EnemyStats = TEST_ENEMY):
	var enemy_array = enemy_grid_container.get_children() 
	if enemy_array.size() >= max_enemies -1:
		var x := 0
		for enemy_on_board: BoardEnemy in enemy_grid_container.get_children():
			if x >= max_enemies -1:
				enemy_finished_track(enemy_on_board)
				enemy_on_board.queue_free()
			x += 1
	
	var new_enemy := BOARD_ENEMY.instantiate()
	
	new_enemy.enemy = _enemy
	
	enemy_grid_container.add_child(new_enemy)
	enemy_grid_container.move_child(new_enemy, 0)
	
	new_enemy.fight = new_enemy.enemy.health


func enemy_finished_track(enemy: BoardEnemy):
	var player = get_tree().get_first_node_in_group("player")
	player.take_damage(enemy.enemy.damage, Modifier.Type.DMG_TAKEN)
	print("oof")


func update_enemy_buttons():
	for boardenemy: BoardEnemy in enemy_grid_container.get_children():
		boardenemy.update_button()
