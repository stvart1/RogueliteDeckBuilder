class_name CardVisuals
extends Control

@export var card: Card : set = _set_card

@onready var panel = $Panel
@onready var art = %Art
@onready var title = %Title
@onready var effect = %Effect

func _set_card(value: Card):
	if not is_node_ready():
		await ready
	
	card = value
	art.texture = card.art
	title.text = card.title
	effect.text = card.get_default_tooltip()
