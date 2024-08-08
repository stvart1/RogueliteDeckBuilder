class_name MapRoom
extends Area2D

signal clicked

const ICONS := {
	Room.Type.UNASSIGNED: null,
	Room.Type.FIRST_AID: preload("res://place_holder_art/player_heart.png"),
	Room.Type.STOREROOM: preload("res://place_holder_art/gold.png"),
	Room.Type.KIOSK: preload("res://place_holder_art/tile_0084.png"),
	Room.Type.WAITING_ROOM: preload("res://place_holder_art/tile_0085.png"),
	Room.Type.SECURITY: preload("res://place_holder_art/tile_0087.png"),
	Room.Type.PLAIN: preload("res://place_holder_art/tile_0082.png"),
	Room.Type.OFFICE: preload("res://place_holder_art/tile_0096.png"),
	Room.Type.ELEVATOR: preload("res://place_holder_art/tile_0101.png"),
}

@onready var icon_button = $Visuals/IconButton
#@onready var line_2d: Line2D = $Visuals/Line2D
#@onready var animation_player: AnimationPlayer = $AnimationPlayer

#var available := true : set = set_available
var room: Room : set = set_room
var player: Player
var map: Map


func _ready():
	player = get_tree().get_first_node_in_group("player")
	map = get_tree().get_first_node_in_group("map")
	Events.stats_changed.connect(room_status_changed)

func room_status_changed():
	var modified_cost: int = map.modifier_handler.get_modified_value(room.move_cost + 1, Modifier.Type.MOVE_COST)
	if room.available and player.stats.move >= modified_cost and not player.stats.fatigued:
		icon_button.modulate = Color.WHITE
		icon_button.disabled = !room.available
	elif room.available:
		icon_button.modulate = Color(0.501, 0.501, 0.501)
		icon_button.disabled = !room.available
	else:
		icon_button.modulate = Color(0.252, 0.252, 0.252)
	#icon_button.disabled = !((room.available and player.stats.move >= modified_cost and not player.stats.fatigued) or room.occupying)
	#print("x: %s, y: %s; button disabled: %s, available: %s, player move: %s, move cost: %s, modified move cost: %s occupied: %s" % [room.xpos, room.ypos, icon_button.disabled, room.available, player.stats.move, room.move_cost, modified_cost, room.occupying])



#func set_available(new_value: bool) -> void:
	#available = new_value
	
	#if available:
		#animation_player.play("highlight")
	#elif not room.selected:
		#animation_player.play("RESET")


func set_room(new_data: Room) -> void:
	room = new_data
	position = room.pos
	#line_2d.rotation_degrees = randi_range(0, 360)
	icon_button.texture_normal = ICONS[room.type]
	room.room_status_change.connect(room_status_changed)

#func show_selected() -> void:
	#line_2d.modulate = Color.WHITE


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not room.available or not event.is_action_pressed("left_mouse"):
		return

	room.selected = true
	clicked.emit(room)
	#animation_player.play("select")


# Called by the AnimationPLayer when the 
# "select" animation finishes.
#func _on_map_room_selected() -> void:


func _on_icon_pressed():
	var modified_cost: int = map.modifier_handler.get_modified_value((room.move_cost + 1), Modifier.Type.MOVE_COST)
	if room.available and player.stats.move >= modified_cost and not player.stats.fatigued:
		player.stats.move -= modified_cost
		clicked.emit()
