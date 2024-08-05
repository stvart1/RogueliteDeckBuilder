class_name MoveUI
extends HBoxContainer

#@export var char_stats: CharacterStats : set = _set_char_stats

@onready var move_label: Label = %MoveLabel


#func _set_char_stats(value: CharacterStats) -> void:
	#char_stats = value
	#
	#if not Events.stats_update.is_connected(_on_stats_update):
		#Events.stats_update.connect(_on_stats_update)
#
	#if not is_node_ready(): 
		#await ready
#
	#_on_stats_update()


func update_stats(stats: CharacterStats) -> void:
	move_label.text = str(stats.move)
