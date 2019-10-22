extends WindowDialog


func _ready():
	return


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	return
	if not Settings.is_console_enabled:
		return
	if Input.is_action_just_pressed("console_toggle"):
		if is_visible_in_tree():
			hide()
		else:
			popup()


func _on_ConsoleInput_text_entered(new_text):
	#ConsoleManager.handle_input(new_text)
	get_node("ConsoleInput").text = ""
