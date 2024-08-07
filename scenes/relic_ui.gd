extends TextureRect

@export var relic: Relic

@onready var counter = $Counter

var player: Player

func _ready():
	texture = relic.icon
	counter.visible = relic.visible_counter
	relic.counter_update.connect(update_counter)
	
	Events.player_draw_cards.connect(relic.start_of_turn())


func update_counter():
	counter.text = str(relic.counter)
