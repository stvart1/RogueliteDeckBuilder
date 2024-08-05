class_name StatusEffect
extends RefCounted

var sound: AudioStream
var status: Status


func execute(targets: Array[Node]) -> void:
	for target in targets:
		if not target:
			continue
		if target is Enemy or target is Player:
			print(target)
			target.status_handler.add_status(status)

