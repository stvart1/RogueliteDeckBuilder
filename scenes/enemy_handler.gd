class_name EnemyHandler
extends Node2D

const BOARD_ENEMY = preload("res://scenes/enemy/board_enemy.tscn")
const TEST_ENEMY = preload("res://enemies/test_enemy.tres")

@onready var modifier_handler = $ModifierHandler
@onready var enemy_grid_container = $EnemyGridContainer

var max_enemies:= 6

func  _ready():
	Events.player_turn_ended.connect(progress_enemies)
	Events.stats_changed_delay.connect(update_enemy_buttons)


func progress_enemies():
	var enemy_array = enemy_grid_container.get_children() 
	if enemy_array.size() >= max_enemies -1:
		var x := 0
		for enemy_on_board: BoardEnemy in enemy_grid_container.get_children():
			if x >= max_enemies -1:
				enemy_finished_track(enemy_on_board)
				enemy_on_board.queue_free()
			x += 1
	
	var new_enemy := BOARD_ENEMY.instantiate()
	enemy_grid_container.add_child(new_enemy)
	enemy_grid_container.move_child(new_enemy, 0)
	new_enemy.enemy = TEST_ENEMY
	new_enemy.enemy_visuals.stats = TEST_ENEMY


func enemy_finished_track(enemy: BoardEnemy):
	var player = get_tree().get_first_node_in_group("player")
	player.take_damage(enemy.enemy.damage, Modifier.Type.DMG_TAKEN)
	print("oof")


func update_enemy_buttons():
	for boardenemy: BoardEnemy in enemy_grid_container.get_children():
		boardenemy.update_button()
