class_name BuyUI
extends HBoxContainer

@export var char_stats: CharacterStats : set = _set_char_stats

@onready var buy_label: Label = %BuyLabel


func _set_char_stats(value: CharacterStats) -> void:
	char_stats = value
	
	if not is_node_ready(): 
		await ready
	


func update_stats(stats: CharacterStats) -> void:
	buy_label.text = str(stats.buy)
