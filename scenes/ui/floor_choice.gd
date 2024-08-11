class_name FloorChoice
extends Control

@onready var floor_options = $FloorOptions

var level:= 1


func _ready():
	Events.level_enetered.connect(level_entered)
	


func level_entered(level_ent: int):
	#visible = true
	level = level_ent
	var floor_number:= RNG.instance.randi_range(level*10+6, level*10+9)
	for option: FloorOption in floor_options.get_children():
		option.floor_label.text = "Floor %s:" % floor_number
		floor_number = RNG.instance.randi_range(floor_number - 3, floor_number-1)
