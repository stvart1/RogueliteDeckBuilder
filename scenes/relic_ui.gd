class_name RelicUI
extends TextureRect

@export var relic: Relic : set = _set_relic

@onready var counter = $Counter

var mouse_over := false


func _set_relic(new_relic: Relic):
	relic = new_relic
	texture = relic.icon
	counter.visible = relic.visible_counter
	relic.counter_update.connect(update_counter)
	update_counter()
	if not Events.activate_start_of_turn_relics.is_connected(relic.start_of_turn):
		Events.activate_start_of_turn_relics.connect(relic.start_of_turn)
	relic.on_aquire(get_tree().get_first_node_in_group("player"))

func update_counter():
	counter.text = str(relic.counter)



func _on_mouse_entered():
	mouse_over = true


func _on_mouse_exited():
	mouse_over = false


func _on_gui_input(event):
	if mouse_over and event.is_action_pressed("right_mouse"):
		Events.tooltip_requested.emit(relic.icon, relic.name, relic.get_tooltip())

