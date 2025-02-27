class_name Card
extends Resource

enum Rarity {BASIC, COMMON, UNCOMMON, RARE}
enum Target {SELF, SINGLE_ENEMY, ALL_ENEMIES, DRAFT_CARD, ALL_DRAFT_CARDS}

const RARITY_COLORS := {
	Card.Rarity.BASIC: Color.BLACK,
	Card.Rarity.COMMON: Color.GRAY,
	Card.Rarity.UNCOMMON: Color.DEEP_SKY_BLUE,
	Card.Rarity.RARE: Color.REBECCA_PURPLE,
}

@export_group("Card Attributes")
@export var id: String
@export var rarity: Rarity
@export var title: String
@export var exhausts: bool = false
@export var target: Target
@export var price: int

@export_group("Card Visuals")
@export var art: Texture
@export_multiline var tooltip_text: String
@export var sound : AudioStream


func is_single_targeted() -> bool:
	if target == Target.SINGLE_ENEMY or target == Target.DRAFT_CARD:
		return true
	return false


func _get_targets(targets: Array[Node]) -> Array[Node]:
	print("get targets")
	if not targets:
		return []
		
	var tree := targets[0].get_tree()
	
	match target:
		Target.SELF:
			print( tree.get_nodes_in_group("player"))
			return tree.get_nodes_in_group("player")
		Target.ALL_ENEMIES:
			return tree.get_nodes_in_group("enemies")
		Target.ALL_DRAFT_CARDS:
			return tree.get_nodes_in_group("drafcards")
		_:
			return []


func play(targets: Array[Node], _char_stats: CharacterStats, modifiers: ModifierHandler) -> void:
	print("play")
	if is_single_targeted():
		apply_effects(targets, modifiers)
	else:
		apply_effects(_get_targets(targets), modifiers)
	print("card: %s, targets: %s" % [title, targets])
	Events.card_played.emit(self)


func apply_effects(_targets: Array[Node], _modifiers: ModifierHandler) -> void:
	pass


func get_default_tooltip() -> String:
	return tooltip_text


func get_updated_tooltip(_player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler) -> String:
	return tooltip_text
