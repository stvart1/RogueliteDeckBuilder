extends TextureRect

@onready var animation_player = $AnimationPlayer

var lowhp:= false

func _ready():
	Events.stats_update.connect(hp_check)
	Events.player_hit.connect(single_hit)


func hp_check(stats: CharacterStats):
	lowhp = stats.health <= 2
	pulse()


func pulse():
	if lowhp:
		animation_player.play("pulse")
	else:
		animation_player.stop()


func single_hit():
	animation_player.play("single_hit")
	#single_hit calls pulse()
