class_name CardPileOpener
extends TextureButton

@onready var shadow = $Shadow

@export var counter: Label
@export var card_pile: CardPile : set = set_card_pile
@export var title: String


func set_card_pile(new_value: CardPile) -> void:
	card_pile = new_value
	
	if not card_pile.card_pile_size_changed.is_connected(_on_card_pile_size_changed):
		card_pile.card_pile_size_changed.connect(_on_card_pile_size_changed)
		_on_card_pile_size_changed(card_pile.cards.size())
	
	
func _on_card_pile_size_changed(cards_amount: int) -> void:
	counter.text = str(cards_amount)
	var new_stylebox = shadow.get_theme_stylebox("StyleBoxFlat").duplicate()
	new_stylebox.shadow_size = cards_amount
	shadow.add_theme_stylebox_override("StyleBoxFlat", new_stylebox)
	#shadow.add_theme_constant_override("theme_override_styles/panel/shadow_size", int(cards_amount))


func _on_pressed():
	var sentpile:= CardPile.new()
	sentpile.cards = card_pile.duplicate_cards()
	sentpile.shuffle()
	Events.cardpile_view_requested.emit(title, sentpile)
