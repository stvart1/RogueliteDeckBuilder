extends Node

const CHARACTER_SELECT = preload("res://scenes/character_select.tscn")
const BOARD_SCENE = preload("res://scenes/board_scene.tscn")

@export var run_startup: RunStartup


func _ready():
	pass # Replace with function body.


func _on_start_button_pressed():
	get_tree().change_scene_to_packed(CHARACTER_SELECT)


func _on_quit_button_pressed():
	get_tree().quit()


func _on_load_button_pressed():
	run_startup.type = RunStartup.Type.CONTINUE_RUN
	get_tree().change_scene_to_packed(BOARD_SCENE)
