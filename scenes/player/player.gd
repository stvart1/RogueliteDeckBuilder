class_name Player
extends Node2D

#const WHITE_SPRITE_MATERIAL := preload("res://art/white_sprite_material.tres")

@export var stats: CharacterStats : set = set_character_stats
@export var gridpos: Vector2i

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var status_handler: StatusHandler = $StatusHandler
@onready var modifier_handler: ModifierHandler = $ModifierHandler

var map: Map


func _ready() -> void:
	#status_handler.status_owner = self
	if not Events.player_gain_move.is_connected(gain_move):
		Events.player_gain_move.connect(gain_move)
	if not Events.player_gain_buy.is_connected(gain_buy):
		Events.player_gain_buy.connect(gain_buy)
	if not Events.new_map_generated.is_connected(move_to_elevator):
		Events.new_map_generated.connect(move_to_elevator)
	if not Events.room_clicked.is_connected(move_to_room):
		Events.room_clicked.connect(move_to_room)
	
	map = get_tree().get_first_node_in_group("map")


func move_to_room(room: Room):
	position = room.pos + map.position


func move_to_elevator(elevator_pos: Vector2):
	position = elevator_pos + map.position


func set_character_stats(value: CharacterStats) -> void:
	stats = value
	#Events.relic_gained.emit(stats.starting_relic)
	
	if not Events.stats_changed.is_connected(update_stats):
		Events.stats_changed.connect(update_stats)

	update_player()


func update_player() -> void:
	if not stats is CharacterStats: 
		return
	if not is_inside_tree(): 
		await ready

	sprite_2d.texture = stats.art
	update_stats()


func update_stats() -> void:
	if not self.is_queued_for_deletion():
		Events.stats_update.emit(stats)
		get_tree().create_timer(0.2, false).timeout.connect(
			func():Events.stats_changed_delay.emit()
		)


func take_damage(damage: int, which_modifier: Modifier.Type) -> void:
	if stats.health <= 0:
		return
	
	#sprite_2d.material = WHITE_SPRITE_MATERIAL
	var modified_damage := modifier_handler.get_modified_value(damage, which_modifier)
	
	var tween := create_tween()
	#tween.tween_callback(Shaker.shake.bind(self, 16, 0.15))
	tween.tween_callback(stats.take_damage.bind(modified_damage))
	tween.tween_interval(0.17)
	
	tween.finished.connect(
		func():
			sprite_2d.material = null
			
			if stats.health <= 0:
				Events.player_died.emit()
				queue_free()
	)


func gain_move(move: int):
	stats.move += move
	Events.stats_changed.emit()


func gain_buy(buy: int):
	stats.buy += buy
	Events.stats_changed.emit()
