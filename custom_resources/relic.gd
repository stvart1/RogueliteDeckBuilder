class_name Relic
extends Resource

signal counter_update

@export var icon: Texture
@export var id: String
@export var name: String
@export var visible_counter:= false
@export_multiline var description: String
var counter: int : set = set_counter


func start_of_turn(_player: Player):
	pass

func set_counter(value: int):
	counter = value
	counter_update.emit()
