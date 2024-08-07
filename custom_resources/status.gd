class_name Status
extends Resource

signal status_applied(status: Status)
signal status_changed

enum Timing {START_OF_TURN, END_OF_TURN, EVENT}

@export_group("Status Data")
@export var id: String
@export var stacks : int : set = set_stacks
@export var expieres := true
@export var stackable := true
@export var timing: Timing

@export_group("Visuals")
@export var icon: Texture
@export_multiline var tooltip: String


func initialize_status(_target: Node) -> void:
	pass


func deinitialize_status(_target: Node):
	pass


func apply_status(_target: Node) -> void:
	status_applied.emit(self)


func get_tooltip() -> String:
	return tooltip



func set_stacks(new_stacks: int) -> void:
	stacks = new_stacks
	status_changed.emit()
