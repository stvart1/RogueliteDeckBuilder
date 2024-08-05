extends Card

@export var reduction:= 1


func get_default_tooltip():
	return tooltip_text % reduction


func get_updated_tooltip(_player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler): # step 7.1
	return tooltip_text % reduction


func apply_effects(_targets: Array[Node], _modifiers: ModifierHandler):
	var draft_area = _targets[0].get_tree().get_first_node_in_group("draft_area")
	for draftcard: DraftCard in draft_area.cards.get_children():
		if draftcard.card.price > 0:
			draftcard.card.price -= reduction
	draft_area.update_cards()
