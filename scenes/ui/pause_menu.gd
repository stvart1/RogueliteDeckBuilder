extends CanvasLayer

const MAIN_MENU_PATH = "res://scenes/main_menu.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if visible:
			unpause()
		else:
			pause()
			
		get_viewport().set_input_as_handled()


func unpause():
	hide()
	get_tree().paused = false


func pause():
	show()
	get_tree().paused = true


func _on_continue_button_pressed():
	unpause()


func _on_menu_button_pressed():
	unpause()
	get_tree().change_scene_to_file(MAIN_MENU_PATH)


func _on_quit_button_pressed():
	get_tree().quit()
