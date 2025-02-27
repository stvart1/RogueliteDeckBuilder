class_name RelicContainer
extends HBoxContainer

const RELIC_UI = preload("res://scenes/relic_ui.tscn")

@onready var owned_relics:= RelicPile.new()

func _ready():
	Events.relic_gained.connect(gain_relic)


func gain_relic(relic: Relic):
	var new_relic_ui = RELIC_UI.instantiate()
	add_child(new_relic_ui)
	new_relic_ui.relic = relic
	owned_relics.relics.append(relic)
