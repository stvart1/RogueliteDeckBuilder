extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if visible:
			hide()
		else:
			show()
			
		get_viewport().set_input_as_handled()
