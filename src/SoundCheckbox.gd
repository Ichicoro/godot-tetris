extends CheckBox

export(Settings.EDITABLES) var target = Settings.EDITABLES.MUSIC

func _ready():
	_on_ResetBtn_reset()

func _toggled(button_pressed):
	Settings.setValue(target, button_pressed)

func _on_ResetBtn_reset():
	pressed = Settings.getValue(target)
