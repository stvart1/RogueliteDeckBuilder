class_name EnemyStats
extends Resource

enum Type {WORKER, SECURITY, MANAGER, BOSS}

@export var name: String
@export var type: Type
@export var level: int
@export var health: int
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
