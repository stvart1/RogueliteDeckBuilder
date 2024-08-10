class_name Map
extends Node2D

const MAP_ROOM = preload("res://scenes/map/map_room.tscn")
const TEST_MANAGER = preload("res://enemies/test_manager.tres")


@onready var map_generator: MapGenerator = $MapGenerator
@onready var visuals = $Visuals
@onready var rooms = $Rooms
@onready var modifier_handler = $ModifierHandler
@onready var legend_button = $LegendButton
@onready var legend_layer = $LegendLayer
@onready var hide_legend_button = %HideLegendButton

var map_data: Array[Array]
var last_room: Room
var occupied_room: Room
var level := 1

var player: Player
var enemy_handler: EnemyHandler
var shop


func _ready():
	player = get_tree().get_first_node_in_group("player")
	enemy_handler = get_tree().get_first_node_in_group("enemy_handler")
	shop = get_tree().get_first_node_in_group("shop")
	
	last_room = Room.new()
	occupied_room = Room.new()
	Events.stats_changed_delay.connect(update_available_rooms)
	



func generate_new_map():
	map_data = map_generator.generate_map(level)
	create_map()
	Events.new_map_generated.emit(map_data[0][floor(MapGenerator.HEIGHT/2.0)].pos)
	map_data[0][floor(MapGenerator.HEIGHT/2.0)].occupying = true
	occupied_room = map_data[0][floor(MapGenerator.HEIGHT/2.0)]
	
	Events.level_enetered.emit(level)

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
		for pos: Vector2i in last_room.connections:
			var connected_room: Room = map_data[pos.x][pos.y]
			connected_room.available = false
		update_available_rooms()
		
		match room.type:
			Room.Type.STOREROOM:
				shop.shop_cards = room.this_shop_cardpile
				shop.set_shop_relics_array(room.this_shop_relics)
				shop.visible = true
			
			Room.Type.FIRST_AID:
				player.stats.heal(1)
			
			Room.Type.WAITING_ROOM:
				if not player.stats.has_coffee:
					player.stats.fatigued = true
			
			Room.Type.OFFICE:
				if not room.visited:
					if room.has_key:
						player.stats.has_key = true
					enemy_handler.progress_enemies(EnemyStats.Type.MANAGER)
			
			Room.Type.KIOSK:
				player.stats.buy += 1
			
			Room.Type.SECURITY:
				enemy_handler.progress_enemies(EnemyStats.Type.SECURITY)
			
			Room.Type.ELEVATOR:
				if player.stats.has_key:
					level += 1
					player.stats.has_key = false
					for maproom: MapRoom in rooms.get_children():
						maproom.queue_free()
					generate_new_map()
					player.stats.has_key = false
		
		room.visited = true


func update_available_rooms():
	for pos: Vector2i in occupied_room.connections:
		var room: Room = map_data[pos.x][pos.y]
		if room:
			room.available = true
			room.occupying = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("up"):
			if occupied_room.ypos > 0:
				for maproom: MapRoom in rooms.get_children():
					if (maproom.room.xpos == occupied_room.xpos) and (maproom.room.ypos == occupied_room.ypos - 1):
						maproom._on_icon_pressed()
						return
	
	if event.is_action_pressed("down"):
			if occupied_room.ypos < MapGenerator.HEIGHT - 1:
				for maproom: MapRoom in rooms.get_children():
					if (maproom.room.xpos == occupied_room.xpos) and (maproom.room.ypos == occupied_room.ypos + 1):
						maproom._on_icon_pressed()
						return
	
	if event.is_action_pressed("left"):
			if occupied_room.xpos > 0:
				for maproom: MapRoom in rooms.get_children():
					if (maproom.room.xpos == occupied_room.xpos - 1) and (maproom.room.ypos == occupied_room.ypos):
						maproom._on_icon_pressed()
						return
	
	if event.is_action_pressed("right"):
			if occupied_room.xpos < MapGenerator.WIDTH - 1:
				for maproom: MapRoom in rooms.get_children():
					if (maproom.room.xpos == occupied_room.xpos + 1) and (maproom.room.ypos == occupied_room.ypos):
						maproom._on_icon_pressed()
						return


func _on_legend_button_pressed():
	legend_layer.visible = true


func _on_hide_legend_button_pressed():
	legend_layer.visible = false
