extends AudioStreamPlayer

class_name DelayableAudioStreamPlayer

export(float, 20) var delay = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(delay), "timeout")
	play()

