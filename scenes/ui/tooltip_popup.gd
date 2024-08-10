class_name TooltipPopup
extends Node2D

@export var text: String : set = _set_text
@export var icon: Texture : set = _set_icon
@export var title: String : set = _set_title

@onready var tooltip_icon = %TooltipIcon
@onready var tooltip_text = %TooltipText
@onready var tooltip_title = %TooltipTitle
@onready var status_container = %StatusContainer

var map: Map

func _ready():
	map = get_tree().get_first_node_in_group("map")


func _set_text(value: String):
	text = value
	tooltip_text.text = "[center] %s [/center]" % text


func _set_title(value: String):
	title = value
	tooltip_title.text = title


func _set_icon(value: Texture):
	icon = value
	tooltip_icon.texture = icon


func _on_gray_out_gui_input(event):
	if event.is_action_pressed("right_mouse") or event.is_action_pressed("left_mouse"):
		visible = false
		for node in status_container.get_children():
			node.queue_free()


func _on_visibility_changed():
	if visible:
		map.process_mode = Node.PROCESS_MODE_DISABLED
	else:
		map.process_mode = Node.PROCESS_MODE_INHERIT


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("space"):
		visible = false
		for node in status_container.get_children():
			node.queue_free()
