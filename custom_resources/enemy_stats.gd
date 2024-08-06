class_name EnemyStats
extends Resource

@export var health: int
@export var art: Texture
@export var tier: int
@export var damage: int
@export var name: String
@export var gold_reward: int
@export_multiline var description: String


func on_spawn(_enemy: Enemy):
	pass


func on_death(_enemy: Enemy):
	pass


func turn(_enemy:Enemy):
	pass
