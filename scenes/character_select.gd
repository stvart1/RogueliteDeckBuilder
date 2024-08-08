extends Control

const BOARD_SCENE = preload("res://scenes/board_scene.tscn")
const TEST_CHARACTER = preload("res://characters/test_character.tres")
const CORPRATE_SPY = preload("res://characters/corprate_spy.tres")
const INSPECTOR = preload("res://characters/inspector.tres")
const JOURNALIST = preload("res://characters/journalist.tres")

@export var run_startup: RunStartup

@onready var character_portrait = %CharacterPortrait
@onready var character_name = %CharacterName
@onready var character_description = %CharacterDescription

var character: CharacterStats : set = set_current_character


func _ready():
	set_current_character(TEST_CHARACTER)


func set_current_character(new_char: CharacterStats):
	character = new_char
	character_portrait.texture = character.portrait
	character_name.text = character.character_name
	character_description.text = character.description


func _on_select_button_pressed():
	run_startup.type = RunStartup.Type.NEW_RUN
	run_startup.character = character.create_instance()
	get_tree().change_scene_to_packed(BOARD_SCENE)


func _on_corprate_spy_button_pressed():
	set_current_character(CORPRATE_SPY)


func _on_inspector_button_pressed():
	set_current_character(INSPECTOR)


func _on_journalist_button_pressed():
	set_current_character(JOURNALIST)
