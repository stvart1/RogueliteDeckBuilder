class_name BoardEnemy
extends VBoxContainer

@onready var enemy_visuals = %EnemyVisuals
@onready var fight_button = $FightButton

var enemy : EnemyStats :set = set_enemy
var fight : int : set = set_fight
var player 
var enemy_handler
var mouse_over := false


func _ready():
	#enemy_visuals.stats = enemy
	fight = enemy.health
	Events.stats_changed.connect(update_button)
	player = get_tree().get_first_node_in_group("player")
	enemy_handler = get_tree().get_first_node_in_group("enemy_handler")
	update_button()


func set_enemy(value: EnemyStats):
	enemy = value
	if not is_node_ready():
		await ready
	enemy_visuals.stats = value


func set_fight(value: int):
	fight = value
	fight_button.text = str(fight)


func _on_fight_button_pressed():
	fight_button.disabled = true
	player.stats.fight -= enemy_handler.modifier_handler.get_modified_value(fight, Modifier.Type.FIGHT_COST)
	player.stats.gold += enemy.gold_reward
	Events.enemy_died.emit(enemy_visuals)
	self.queue_free()

func update_button():
	
	var modified_fight = enemy_handler.modifier_handler.get_modified_value(fight, Modifier.Type.FIGHT_COST)
	
	fight_button.text = str(modified_fight)
	
	if player.stats.fight < modified_fight:
		fight_button.disabled = true
	else:
		fight_button.disabled = false


func _on_center_container_mouse_entered():
	mouse_over = true


func _on_center_container_mouse_exited():
	mouse_over = false


func _on_center_container_gui_input(event):
	if mouse_over and event.is_action_pressed("right_mouse"):
		Events.tooltip_requested.emit(enemy.art, enemy.name, ("%s\nDamage: %s\nGold: %s" % [enemy.description, enemy.damage, enemy.gold_reward]), enemy_visuals.status_handler.get_children())
