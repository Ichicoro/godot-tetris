extends Control

onready var viewport = get_viewport()
var minimum_size = Vector2(430, 584)

func _ready():
	#viewport.connect("size_changed", self, "window_resize")
	#window_resize()
	pass

func window_resize():
	var current_size = OS.get_window_size()
	print(current_size, "dpi= ", OS.get_screen_dpi())
#	rect_size = current_size/1
