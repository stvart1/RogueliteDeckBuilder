class_name EnemyStats
extends Resource

enum Type {WORKER, SECURITY, MANAGER, BOSS}

signal enemy_stat_change
signal enemy_dealing_damage(damage: int)

@export var name: String
@export var type: Type
@export var level: int
@export var health: int : set = set_health
@export var damage: int
@export var gold_reward: int
@export var art: Texture
@export_multiline var description: String


func on_spawn(_enemy: Enemy):
	pass


func on_death(_enemy: Enemy):
	pass


func turn(_enemy:Enemy):
	pass


func get_description() -> String:
	return description


func set_health(value: int):
	health = value
	enemy_stat_change.emit()
