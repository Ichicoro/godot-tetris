extends AudioStreamPlayer

const jingle = preload("res://assets/sounds/sfx/tetris_jingle.wav")

func _ready():
	pass # Replace with function body.

func playjingle():
	self.stream = jingle
	self.volume_db = -23
	play()
