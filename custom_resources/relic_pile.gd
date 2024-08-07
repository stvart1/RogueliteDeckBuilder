class_name RelicPile
extends Resource

@export var relics: Array[Relic]

func duplicate_relics() -> Array[Relic]:
	var new_array: Array[Relic] = []
	
	for relic: Relic in relics:
		new_array.append(relic.duplicate())
	
	return new_array

# We need this method because of a Godot issue
# reported here: 
# https://github.com/godotengine/godot/issues/74918
func custom_duplicate() -> RelicPile:
	var new_relic_pile := RelicPile.new()
	new_relic_pile.relics = duplicate_relics()
	
	return new_relic_pile
