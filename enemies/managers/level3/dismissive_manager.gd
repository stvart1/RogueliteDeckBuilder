extends EnemyStats


func on_spawn(_enemy: Enemy):
	Events.card_played.connect(played_card)


func played_card(_card: Card):
	Events.discard_card.emit()


func on_death(_enemy: Enemy):
	Events.card_played.disconnect(played_card)
