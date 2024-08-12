class_name MapGenerator
extends Node

const FIRST_AID_CHANCE := 5
const STOREROOM_CHANCE := 5
const WAITINGROOM_CHANCE := 10
const KIOSK_CHANCE := 5
const SECURITY_CHANCE := 20
const HALLWAY_CHANCE := (100 - FIRST_AID_CHANCE - STOREROOM_CHANCE - WAITINGROOM_CHANCE - KIOSK_CHANCE - SECURITY_CHANCE)

const X_DIST := 60
const Y_DIST := 60
const PLACEMENT_OFFSET := 10
const WIDTH := 15
const HEIGHT := 7
const PATHS := 4

@export var office_count := 2

@onready var modifier_handler = $ModifierHandler

var random_room_type_weights = {
	Room.Type.FIRST_AID: 0.0,
	Room.Type.STOREROOM: 0.0,
	Room.Type.KIOSK: 0.0,
	Room.Type.WAITING_ROOM: 0.0,
	Room.Type.SECURITY: 0.0,
	Room.Type.PLAIN: 0.0
}
var random_room_type_total_weight := 0
var map_data: Array[Array]


func generate_map(level: int) -> Array[Array]:
	#if not is_node_ready():
		#await ready
	office_count = 2 + level
	print("level: %s, office_count: %s" % [level, office_count])
	map_data = _generate_initial_grid()
	_setup_start_point()
	_setup_offices()
	_setup_roomweights(level)
	_setup_rooms()
	map_data = setup_connections(map_data)
	return map_data


func _generate_initial_grid() -> Array[Array]:
	var result: Array[Array] = []
	
	for i in WIDTH:
		var adjacent_rooms: Array[Room] = []
		
		for j in HEIGHT:
			var current_room := Room.new()
			current_room.pos = Vector2(i * X_DIST, j * Y_DIST)
			current_room.xpos = i
			current_room.ypos = j
			current_room.connections = []
			
			adjacent_rooms.append(current_room)
		
		result.append(adjacent_rooms)
	
	return result


func _setup_start_point():
	var elevator := map_data[0][floor(HEIGHT/2.0)] as Room
	elevator.type = Room.Type.ELEVATOR


func _setup_offices():
	for i in office_count:
		var new_office := map_data[RNG.instance.randi_range(WIDTH - 4, WIDTH - 1)][RNG.instance.randi_range(0, HEIGHT - 1)] as Room
		
		#	Make sure the new office isn't replacin and old office
		while map_data[new_office.xpos][new_office.ypos].type == Room.Type.OFFICE:
			new_office = map_data[RNG.instance.randi_range(WIDTH - 4, WIDTH - 1)][RNG.instance.randi_range(0, HEIGHT - 1)] as Room
		var room = Office.new()
		room.type  = Room.Type.OFFICE
		room.xpos = new_office.xpos
		room.ypos = new_office.ypos
		room.pos = new_office.pos
		room.move_cost = Office.OFFICE_MOVE_COST
		if i == 1 :
			room.has_key = true
		
		map_data[room.xpos].remove_at(room.ypos)
		map_data[room.xpos].insert(room.ypos, room)
		
		


func _setup_roomweights(level: int):
	random_room_type_weights[Room.Type.FIRST_AID] = FIRST_AID_CHANCE
	random_room_type_weights[Room.Type.STOREROOM] = random_room_type_weights[Room.Type.FIRST_AID] + STOREROOM_CHANCE
	random_room_type_weights[Room.Type.KIOSK] = random_room_type_weights[Room.Type.STOREROOM] + KIOSK_CHANCE
	random_room_type_weights[Room.Type.WAITING_ROOM] = random_room_type_weights[Room.Type.KIOSK] + WAITINGROOM_CHANCE
	random_room_type_weights[Room.Type.SECURITY] = random_room_type_weights[Room.Type.WAITING_ROOM] + modifier_handler.get_modified_value(SECURITY_CHANCE * level ,Modifier.Type.SECURITY_CHANCE)
	random_room_type_weights[Room.Type.PLAIN] = random_room_type_weights[Room.Type.SECURITY] + HALLWAY_CHANCE
	
	random_room_type_total_weight = random_room_type_weights[Room.Type.PLAIN]
	
	print(random_room_type_weights[Room.Type.SECURITY]-random_room_type_weights[Room.Type.WAITING_ROOM])
	print(random_room_type_total_weight)
	print((random_room_type_weights[Room.Type.SECURITY]-random_room_type_weights[Room.Type.WAITING_ROOM])/random_room_type_total_weight)


func _setup_rooms():
	for current_colomn in map_data:
		for room: Room in current_colomn:
			if room.type == Room.Type.UNASSIGNED:
				room.type = _get_random_room_type()
				if room.type == Room.Type.STOREROOM:
					_set_room_storeroom(room)


func _get_random_room_type() -> Room.Type:
	var roll := RNG.instance.randf_range(0.0, random_room_type_total_weight)
	
	for type: Room.Type in random_room_type_weights:
		if random_room_type_weights[type] > roll:
			return type
	
	return Room.Type.UNASSIGNED


func setup_connections(mapdata: Array[Array]):
	for current_colomn in mapdata:
		for room: Room in current_colomn:
			if room.type != Room.Type.UNASSIGNED:
				_setup_connections_for_room(mapdata, room)
	return mapdata


func _setup_connections_for_room(mapdata: Array[Array], room: Room):
	var room_to_add : Room
	var room_pos: Vector2i
	room.connections = []
	
	if room.xpos > 0 :
		room_to_add = mapdata[room.xpos - 1][room.ypos]
		if room_to_add.type != Room.Type.UNASSIGNED:
			room_pos = Vector2i(room_to_add.xpos, room_to_add.ypos)
			room.connections.append(room_pos)
	
	if room.xpos < (WIDTH - 1) :
		room_to_add = mapdata[room.xpos + 1][room.ypos]
		if room_to_add.type != Room.Type.UNASSIGNED:
			room_pos = Vector2i(room_to_add.xpos, room_to_add.ypos)
			room.connections.append(room_pos)
	
	if room.ypos > 0 :
		room_to_add = mapdata[room.xpos][room.ypos - 1]
		if room_to_add.type != Room.Type.UNASSIGNED:
			room_pos = Vector2i(room_to_add.xpos, room_to_add.ypos)
			room.connections.append(room_pos)
	
	if room.ypos < (HEIGHT - 1) :
		room_to_add = mapdata[room.xpos][room.ypos + 1]
		if room_to_add.type != Room.Type.UNASSIGNED:
			room_pos = Vector2i(room_to_add.xpos, room_to_add.ypos)
			room.connections.append(room_pos)

func _set_room_storeroom(room: Room):
	var temp_room = Room.new()
	temp_room = room
	room = Storeroom.new()
	room.set_signals()
	room.relic_container = get_tree().current_scene.relic_container
	room.type  = temp_room.type
	room.xpos = temp_room.xpos
	room.ypos = temp_room.ypos
	room.pos = temp_room.pos
	room.move_cost = temp_room.move_cost
	room.this_shop_cardpile = Storeroom.SHOP_CARDPILE.custom_duplicate()
	room.set_relic_pool_from_default()
	map_data[room.xpos].remove_at(room.ypos)
	map_data[room.xpos].insert(room.ypos, room)
