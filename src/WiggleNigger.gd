extends Sprite

var time_start = 0


func _ready():
	pass


func _process(delta):
	time_start += delta*2
	position.x = sin(time_start/2)*10+atan(time_start/3)*2
	position.y = cos(time_start)*21.1
