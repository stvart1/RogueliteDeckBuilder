class_name FightUI
extends HBoxContainer

#@export var char_stats: CharacterStats : set = _set_char_stats

@onready var fight_label: Label = %FightLabel


#func _set_char_stats(value: CharacterStats) -> void:
	#char_stats = value
	#
	#if not Events._on_stats_update.is_connected(_on_stats_update):
		#Events._on_stats_update.connect(_on_stats_update)
#
	#if not is_node_ready(): 
		#await ready
#
	#_on_stats_update()


func update_stats(stats: CharacterStats) -> void:
	fight_label.text = str(stats.fight)
