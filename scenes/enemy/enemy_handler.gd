class_name EnemyHandler
extends Node2D

const BOARD_ENEMY = preload("res://scenes/enemy/board_enemy.tscn")
const TEST_ENEMY = preload("res://enemies/test_enemy.tres")

@onready var modifier_handler = $ModifierHandler
@onready var enemy_grid_container = $EnemyGridContainer

@export var all_enemies: Array[EnemyStats] = []
@export var all_managers: Array[EnemyStats] = []

var max_enemies:= 6
var level := 0
var available_managers: Array[EnemyStats]
var available_enemies: Array[EnemyStats]

func  _ready():
	Events.stats_changed_delay.connect(update_enemy_buttons)
	Events.enemy_died.connect(enemy_died)
	Events.player_turn_ended.connect(enemy_turn)
	Events.level_enetered.connect(_level_entered)

func enemy_died(enemy: Enemy):
	enemy.stats.on_death(enemy)


func enemy_turn():
	for boardenemy: BoardEnemy in enemy_grid_container.get_children():
		boardenemy.enemy.turn(boardenemy.enemy_visuals)
	
	progress_enemies(EnemyStats.Type.WORKER)
	
	Events.enemy_turn_ended.emit()


func progress_enemies(type: EnemyStats.Type):
	var enemy_array = enemy_grid_container.get_children() 
	if enemy_array.size() >= max_enemies -1:
		var x := 0
		for enemy_on_board: BoardEnemy in enemy_grid_container.get_children():
			if x >= max_enemies -1:
				enemy_finished_track(enemy_on_board)
				enemy_on_board.queue_free()
			x += 1
	
	var new_enemy := BOARD_ENEMY.instantiate()
	
	if type == EnemyStats.Type.MANAGER:
		new_enemy.enemy = available_managers.pop_back()
	else:
		new_enemy.enemy = RNG.array_pick_random(available_enemies.filter(func(enemy): return enemy.type == type))
	
	enemy_grid_container.add_child(new_enemy)
	enemy_grid_container.move_child(new_enemy, 0)
	
	new_enemy.fight = new_enemy.enemy.health


func progress_enemies_by_enemy(enemy: EnemyStats):
	var enemy_array = enemy_grid_container.get_children() 
	if enemy_array.size() >= max_enemies -1:
		var x := 0
		for enemy_on_board: BoardEnemy in enemy_grid_container.get_children():
			if x >= max_enemies -1:
				enemy_finished_track(enemy_on_board)
				enemy_on_board.queue_free()
			x += 1
	
	var new_enemy := BOARD_ENEMY.instantiate()
	
	new_enemy.enemy = enemy
	
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


func _level_entered(new_level: int):
	level = new_level
	available_enemies = all_enemies.filter(func(enemy): return enemy.level == level)
	available_managers = all_managers.filter(func(enemy): return enemy.level == level)
	RNG.array_shuffle(available_managers)
