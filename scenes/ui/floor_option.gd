class_name FloorOption
extends HBoxContainer

@export var boon: FloorModifier : set = set_boon
@export var bane: FloorModifier : set = set_bane
#@export var difficulty : FloorModifier.difficulty : set = set_difficulty
@export var floor: int : set = set_floor

@onready var floor_label = %FloorLabel
@onready var boon_description = %BoonDescription
@onready var bane_description = %BaneDescription
@onready var select_button = %SelectButton


func set_boon(value: FloorModifier):
	boon = value.duplicate()
	boon.map = get_tree().get_first_node_in_group("map")
	boon.enemy_handler = get_tree().get_first_node_in_group("enemy_handler")
	boon_description.text = "%s: %s" % [boon.name, boon.get_description()]


func set_bane(value: FloorModifier):
	bane = value.duplicate()
	bane.map = get_tree().get_first_node_in_group("map")
	bane.enemy_handler = get_tree().get_first_node_in_group("enemy_handler")
	bane_description.text = "%s: %s" % [bane.name, bane.get_description()]


func set_floor(value: int):
	floor = value
	#floor_label.text = "Floor %s: " % floor

func update_labels():
	boon_description.text = "%s: %s" % [boon.name, boon.get_description()]
	bane_description.text = "%s: %s" % [bane.name, bane.get_description()]
	floor_label.text = "Floor %s: " % floor



func _on_select_button_pressed():
	boon.selected()
	bane.selected()
	Events.generate_map.emit()
	var mods: Array[FloorModifier] = [boon, bane]
	Events.floor_mods_selected.emit(mods)
