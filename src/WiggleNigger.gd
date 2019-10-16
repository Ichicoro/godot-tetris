extends Sprite

var time_start = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_start += delta*2
	position.x = sin(time_start/2)*10
	position.y = cos(time_start)*21.1
