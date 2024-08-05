class_name StatusUI
extends Control

@export var status: Status : set = set_status

@onready var icon: TextureRect = $Icon
@onready var stacks: Label = $Stacks


func set_status(new_status: Status) -> void:
	if not is_node_ready():
		await ready
	
	status = new_status
	icon.texture = status.icon
	custom_minimum_size = icon.size
	
	if stacks.visible:
		custom_minimum_size = stacks.size + stacks.position
	if not status.status_changed.is_connected(_on_status_changed):
		status.status_changed.connect(_on_status_changed)
	
	_on_status_changed()


func _on_status_changed() -> void:
	if not status:
		return

	if status.stacks <= 0:
		queue_free()
	stacks.text = str(status.stacks)
	Events.stats_changed.emit()
