class_name PlayArea
extends CanvasLayer

@export var char_stats: CharacterStats : set = _set_char_stats

@onready var hand = %Hand
@onready var end_turn_button = $EndTurnButton
@onready var draw_pile_button = %DrawPileButton
@onready var discard_pile_button = %DiscardPileButton

var turn := 1

func _ready() -> void:
	Events.player_hand_drawn.connect(_on_player_hand_drawn)
	#end_turn_button.pressed.connect(_on_end_turn_button_pressed)
	#draw_pile_button.pressed.connect(draw_pile_view.show_current_view.bind("Draw Pile", true))
	#discard_pile_button.pressed.connect(discard_pile_view.show_current_view.bind("Discard Pile"))


func _on_player_hand_drawn(_player) -> void:
	end_turn_button.disabled = false


func _on_end_turn_button_pressed() -> void:
	end_turn_button.disabled = true
	Events.player_turn_ended.emit()
	turn += 1
	print("Turn: %s" % turn)

func _set_char_stats(value: CharacterStats) -> void:
	char_stats = value
	hand.char_stats = char_stats

func initialize_card_pile_ui() -> void:
	draw_pile_button.card_pile = char_stats.draw_pile
	#draw_pile_view.card_pile = char_stats.draw_pile
	discard_pile_button.card_pile = char_stats.discard
	#discard_pile_view.card_pile = char_stats.discard
