extends TextureButton

const event_map = {
	"LeftButton": "move_left",
	"RightButton": "move_right",
	"SoftDropButton": "soft_drop",
	"HardDropButton": "hard_drop",
	"RotateLeftButton": "spin_left",
	"RotateRightButton": "spin_right",
	"HoldButton": "hold",
	"PauseButton": "menu"
}

func create_action_event(action_name: String, pressed: bool):
	var iea = InputEventAction.new()
	iea.action = action_name
	iea.pressed = pressed
	return iea

func _gui_input(event):
	if event is InputEventMouseButton:
		Input.parse_input_event(create_action_event(event_map[self.name], event.pressed))
		self.modulate = Color(1,1,1,0.7) if event.pressed else Color(1,1,1,1)
