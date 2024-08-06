class_name StatusHandler
extends GridContainer

signal statuses_applied(timing: Status.Timing)

const STATUS_APPLY_INTERVAL := 0.25
const STATUS_UI = preload("res://scenes/status_handler/status_ui.tscn")

@export var status_owner: Node2D


func apply_statuses_by_timing(timing: Status.Timing) -> void:
	if timing == Status.Timing.EVENT:
		return
		
	var status_queue: Array[Status] = _get_all_statuses().filter(
		func(status: Status):
			return status.timing == timing
	)
	if status_queue.is_empty():
		statuses_applied.emit(timing)
		return
	
	var tween := create_tween()
	for status: Status in status_queue:
		tween.tween_callback(status.apply_status.bind(status_owner))
		tween.tween_interval(STATUS_APPLY_INTERVAL)
	
	tween.finished.connect(func(): statuses_applied.emit(timing))


func add_status(status: Status) -> void:
	var stackable := status.stackable
	
	# Add it if it's new
	if not _has_status(status.id):
		var new_status_ui := STATUS_UI.instantiate() as StatusUI
		add_child(new_status_ui)
		new_status_ui.status = status
		new_status_ui.status.status_applied.connect(_on_status_applied)
		new_status_ui.status.initialize_status(status_owner)
		
		Events.stats_changed.emit()
		return

	# If it's unique and we already have it, we can return
	if not status.expieres and not stackable:
		return
	
	# If it's duration-stackable, expand it
	if status.stackable:
		_get_status(status.id).stacks += status.stacks
		return


func remove_status(status: Status):
	status.deinitialize_status(status_owner)
	Events.stats_changed.emit()


func _has_status(id: String) -> bool:
	for status_ui: StatusUI in get_children():
		if status_ui.status.id == id:
			return true
			
	return false


func _get_status(id: String) -> Status:
	for status_ui: StatusUI in get_children():
		if status_ui.status.id == id:
			return status_ui.status
	
	return null


func _get_all_statuses() -> Array[Status]:
	var statuses: Array[Status] = []
	for status_ui: StatusUI in get_children():
		statuses.append(status_ui.status)
		
	return statuses


func _on_status_applied(status: Status) -> void:
	if status.expieres:
		status.duration -= 1


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		Events.status_tooltip_requested.emit(_get_all_statuses())
