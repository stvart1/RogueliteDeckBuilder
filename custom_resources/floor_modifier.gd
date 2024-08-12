class_name FloorModifier
extends Resource

enum Type {GENERATION, PLAY}
enum Difficulty {EASY, MEDIUM, HARD}

@export var type: Type
@export var boon: bool
@export var name: String
@export_multiline var description: String

var difficulty: Difficulty : set = set_difficulty
var map: Map
var enemy_handler: EnemyHandler


func set_difficulty(diff: Difficulty):
	difficulty = diff


func selected():
	pass


func floor_cleared(_level: int):
	pass


func get_description() -> String:
	return description
