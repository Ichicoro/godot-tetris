extends Control
class_name SafeAreaContainer

export var force_disable: bool = false
var project_setting_name: String = "display/window/ios/disable_safe_zone"

func _ready():
	if (ProjectSettings.has_setting(project_setting_name)):
		if (ProjectSettings.get_setting(project_setting_name)):
			return
	if (force_disable):
		return
	update_safe_area()
	get_tree().get_root().connect("size_changed", self, "update_safe_area")


func update_safe_area():
	print_debug("resizing safe zone...")
	var scaled_win_size: Vector2 = get_tree().root.get_visible_rect().size
	var self_scale: float = self.rect_scale.x
	print("self scale: ", self_scale)
	print("get_viewport_rect().size: ", get_viewport_rect().size)
	if OS.get_name() == "iOS":
		var safe_area: Rect2 = OS.get_window_safe_area()
		var real_win_size: Vector2 = OS.get_real_window_size()
		var scale: float = (real_win_size.x / scaled_win_size.x)# * self_scale
		print("real window scale: ", scale)
		print("Safe area pos: ", safe_area.position)
		self.anchor_bottom = 0
		self.anchor_top    = 0
		self.anchor_left   = 0
		self.anchor_right  = 0
		print("Safe area: ", safe_area)
		print("Screen scale: ", scale)
		self.rect_position = safe_area.position / scale
		self.rect_size = safe_area.size / scale
	else:
		var parent = get_parent()
		self.anchor_bottom = 1
		self.anchor_top    = 0
		self.anchor_left   = 0
		self.anchor_right  = 1
		self.rect_position = parent.rect_position
		self.rect_size = parent.rect_size
