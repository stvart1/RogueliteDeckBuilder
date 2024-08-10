extends EnemyStats


func on_spawn(_enemy: Enemy):
	Events.card_played.connect(played_card)


func played_card(_card: Card):
	enemy_dealing_damage.emit(1)
