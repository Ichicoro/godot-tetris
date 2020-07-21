extends Control
class_name SafeAreaContainer

func _ready():
	if OS.get_name() == "ios":
		var safe_area: Rect2 = OS.get_window_safe_area()
		print(safe_area)
		self.rect_position = safe_area.position
		self.rect_size = safe_area.size
