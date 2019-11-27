extends Node

signal pauseToggled(pause)

var gameview: Node = null
var pausescreen: Node = null
var isPaused = false
var dialog

func _ready():
	gameview = get_parent().get_node("Game view/GridContainer")
	#pausescreen = get_parent().get_node("Pause screen")

func _input(event):
	if not gameview.get("table").can_tick or isPaused:
		return
	if Input.is_action_just_pressed("menu"):
		if not isPaused:
			get_tree().set_input_as_handled()
			showPauseScreen()

func setPaused(newVal):
	isPaused = newVal
	emit_signal("pauseToggled", isPaused)

func hidePauseScreen(togglePause = true):
	if togglePause: setPaused(false)
	#pausescreen.hide()

func showPauseScreen():
#	pausescreen.show()
	dialog = Dialog.new("Paused", "Unpause", "Esc", "menu", "Exit", "Q", "quit_confirm")
	dialog.connect("button_a_pressed", self, "_on_Continue_button_pressed")
	dialog.connect("button_b_pressed", self, "_on_Exit_button_pressed")
	get_tree().root.add_child(dialog)
	setPaused(true)

func _on_Continue_button_pressed():
	setPaused(false)
	get_tree().set_input_as_handled()

func _on_Exit_button_pressed():
	gameview.table.do_finish_animation()
	dialog = null

func _on_Dialog_buttonPressed(btn):
	hidePauseScreen((btn == DialogController.BUTTONS.BTN_A))
	if btn == DialogController.BUTTONS.BTN_B : 
		gameview.table.do_finish_animation()
		pausescreen = null
