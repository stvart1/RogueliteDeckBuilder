class_name Map
extends Node2D

const MAP_ROOM = preload("res://scenes/map/map_room.tscn")

@onready var map_generator: MapGenerator = $MapGenerator
@onready var visuals = $Visuals
@onready var rooms = $Visuals/Rooms

var map_data: Array[Array]
var last_room: Room
var player: Player
var occupied_room: Room
var enemy_handler: EnemyHandler
var shop


func _ready():
	player = get_tree().get_first_node_in_group("player")
	enemy_handler = get_tree().get_first_node_in_group("enemy_handler")
	shop = get_tree().get_first_node_in_group("shop")
	
	last_room = Room.new()
	occupied_room = Room.new()
	Events.stats_changed.connect(update_available_rooms)


func generate_new_map():
	map_data = map_generator.generate_map()
	create_map()
	Events.new_map_generated.emit(map_data[0][2].pos)
	map_data[0][2].occupying = true
	occupied_room = map_data[0][2]

func create_map():
	for current_floor: Array in map_data:
		for room: Room in current_floor:
			if room.connections.size() > 0:
				_spawn_room(room)

	#var map_width_pixels := MapGenerator.X_DIST * (MapGenerator.WIDTH - 1)
	#visuals.position.x = (get_viewport_rect().size.x - map_width_pixels) / 2
	#visuals.position.y = get_viewport_rect().size.y / 2


func _spawn_room(room: Room):
	var new_map_room := MAP_ROOM.instantiate() as MapRoom
	rooms.add_child(new_map_room)
	new_map_room.room = room
	new_map_room.clicked.connect(_on_map_room_clicked.bind(new_map_room.room))
	

func _on_map_room_clicked(room: Room):
	if room.available:
		last_room = occupied_room.duplicate()
		Events.room_clicked.emit(room)
		room.occupying = true
		occupied_room = room
		last_room.occupying = false
		for room_to_set: Room in last_room.connections:
			room_to_set.available = false
		update_available_rooms()
		
		match room.type:
			Room.Type.STOREROOM:
				shop.shop_cards = room.this_shop_cardpile
				shop.visible = true
			
			Room.Type.FIRST_AID:
				player.stats.heal(1)
			
			Room.Type.WAITING_ROOM:
				player.stats.fatigued = true
			
			Room.Type.OFFICE:
				if room.has_key:
					player.stats.has_key = true
			
			Room.Type.KIOSK:
				player.stats.buy += 1
			
			Room.Type.SECURITY:
				enemy_handler.progress_enemies()
			
			Room.Type.ELEVATOR:
				if player.stats.has_key:
					self.queue_free()


func update_available_rooms():
	for room_to_set: Room in occupied_room.connections:
		room_to_set.available = true
		room_to_set.occupying = false
