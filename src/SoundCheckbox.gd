extends CheckBox

export(Settings.EDITABLES) var target = Settings.EDITABLES.MUSIC

func _ready():
	reset()

func _toggled(button_pressed):
	Settings.setValue(target, button_pressed)

func reset():
	pressed = Settings.getValue(target)
