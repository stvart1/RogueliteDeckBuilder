class_name Modifier
extends Node

enum Type {
	DMG_DEALT,
	DMG_TAKEN,
	FIGHT_COST,
	SHOP_COST,
	NO_MODIFIER,
	DRAFT_COST,
	DRAFT_REFRESH,
	MOVE_COST,
	REGEN,
	DRAW_PER_TURN,
	SECURITY_CHANCE,
	GOLD_EARNING
}

@export var type: Type


func get_value(source: String) -> ModifierValue:
	for value: ModifierValue in get_children():
		if value.source == source:
			return value
		
	return null


func add_new_value(value: ModifierValue) -> void:
	var modifier_value := get_value(value.source)
	if not modifier_value:
		add_child(value)
	else:
		modifier_value.flat_value = value.flat_value
		modifier_value.percent_value = value.percent_value


func remove_value(source: String) -> void:
	for value: ModifierValue in get_children():
		if value.source == source:
			value.queue_free()


func clear_values() -> void:
	for value: ModifierValue in get_children():
		value.queue_free()


func get_modified_value(base: int) -> int:
	var flat_result: int = base
	var percent_result: float = 1.0
	var final_result: int
	# Apply flat modifiers first
	for value: ModifierValue in get_children():
		if value.type == ModifierValue.Type.FLAT:
			flat_result += value.value
	
	# Apply % modifiers next
	for value: ModifierValue in get_children():
		if value.type == ModifierValue.Type.PERCENT_BASED:
			percent_result += (value.value/100.0)
			
	
	final_result = floori(flat_result * percent_result)
	# Apply set modifiers last
	for value: ModifierValue in get_children():
		if value.type == ModifierValue.Type.SET:
			final_result = value.value
	return final_result
