class_name SaveGame
extends Resource

const SAVE_PATH := "user://savegame.res"

@export var rng_seed: int
@export var rng_state: int
@export var char_stats: CharacterStats
@export var current_hp: int
@export var current_deck: CardPile
@export var current_discard: CardPile
@export var current_hand: Array[Card]
@export var relics: RelicPile
@export var map_data: Array[Array]
@export var last_room: Room
@export var level: int
@export var enemy_track: Array[EnemyStats]
@export var draft_row: Array[Card]
@export var draft_deck: Array[Card]
@export var available_managers: Array[EnemyStats]
@export var available_enemies: Array[EnemyStats]

func save_data() -> void:
	var err := ResourceSaver.save(self, SAVE_PATH)
	assert(err == OK, "Couldn't save the game!")


static func load_data() -> SaveGame:
	if FileAccess.file_exists(SAVE_PATH):
		return ResourceLoader.load(SAVE_PATH) as SaveGame
	
	return null


static func delete_data() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)
