class_name Room
extends Node

signal room_status_change

enum Type {UNASSIGNED, STOREROOM, FIRST_AID, WAITING_ROOM, EVENT, MYSTERY, PLAIN, OFFICE, KIOSK, SECURITY, ELEVATOR}

@export var xpos: int
@export var ypos: int
@export var pos: Vector2
@export var type: Type
@export var connections: Array
@export var visited := false
@export var available : bool : set = _set_available
@export var occupying: bool : set = _set_occupying
@export var move_cost := 1


func _set_available(value: bool):
	available = value
	room_status_change.emit()


func _set_occupying(value: bool):
	occupying = value
	room_status_change.emit()
