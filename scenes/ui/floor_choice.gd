class_name FloorChoice
extends Control

const FLOOR_OPTION = preload("res://scenes/ui/floor_option.tscn")

@export var floor_mods: Array[FloorModifier]

@onready var floor_options = $FloorOptions

var level:= 1
var option_count:= 3

func _ready():
	Events.level_enetered.connect(level_entered)
	Events.generate_map.connect(close)
	for floor_option: FloorOption in floor_options.get_children():
		floor_option.queue_free()


func level_entered(level_ent: int):
	if not is_node_ready():
		await ready
	
	for floor_option: FloorOption in floor_options.get_children():
		floor_option.queue_free()
	
	visible = true
	level = level_ent
	var floor_number:= RNG.instance.randi_range(level*10+6, level*10+9)
	var difficulty := FloorModifier.Difficulty.HARD
	#for option: FloorOption in floor_options.get_children():
	for i: int in option_count:
		var option:= FLOOR_OPTION.instantiate()
		floor_options.add_child(option)
		option.floor = floor_number
		option.boon = RNG.array_pick_random(floor_mods.filter(func(floor_mod): return floor_mod.boon))
		option.boon.difficulty = difficulty
		option.bane = RNG.array_pick_random(floor_mods.filter(func(floor_mod): return !floor_mod.boon))
		option.bane.difficulty = difficulty
		option.update_labels()
		floor_number = RNG.instance.randi_range(floor_number - 3, floor_number-1)
		difficulty -= 1


func close():
	visible = false
