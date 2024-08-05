extends Node2D

@onready var area_2d = $Area2D

var current_card: CardUI
var targeting := false


func _ready() -> void:
	Events.card_aim_started.connect(_on_card_aim_started)
	Events.card_aim_ended.connect(_on_card_aim_ended)


func _on_card_aim_started(card: CardUI) -> void:
	if not card.card.is_single_targeted():
		return
	
	targeting = true
	area_2d.monitoring = true
	area_2d.monitorable = true
	current_card = card


func _on_card_aim_ended(_card: CardUI) -> void:
	targeting = false
	#card_arc.clear_points()
	area_2d.position = Vector2.ZERO
	area_2d.monitoring = false
	area_2d.monitorable = false
	current_card = null


func _on_area_2d_area_entered(area):
	if not current_card or not targeting:
		return
	
	if not current_card.targets.has(area):
		current_card.targets.append(area)


func _on_area_2d_area_exited(area):
	if not current_card or not targeting:
		return
	
	current_card.targets.erase(area)
