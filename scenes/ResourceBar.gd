class_name ResourceBar
extends HBoxContainer


@onready var health = %Health
@onready var gold = %Gold
@onready var move = %Move
@onready var fight = %Fight
@onready var buy = %Buy
@onready var keycard = %Keycard


func _ready() -> void:
	if not Events.stats_update.is_connected(update_stats):
		Events.stats_update.connect(update_stats)


func update_stats(stats: CharacterStats):
	health.update_stats(stats)
	buy.update_stats(stats)
	fight.update_stats(stats)
	move.update_stats(stats)
	gold.update_stats(stats)
	if stats.has_key:
		keycard.visible = stats.has_key



