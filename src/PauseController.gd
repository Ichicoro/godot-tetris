extends Node

signal pauseToggled(pause)

var gameview: Node = null
var pausescreen: Node = null
var isPaused = false

func _ready():
	gameview = get_parent().get_node("Game view/GridContainer")
	pausescreen = get_parent().get_node("Pause screen")

func _input(event):
	if canPause():
			showPauseScreen()
			
func canPause() :
	return gameview.get("table").can_tick and pausescreen != null and not isPaused and Input.is_action_just_pressed("menu")
	
func setPaused(newVal) :
	isPaused = newVal
	emit_signal("pauseToggled", isPaused)

func hidePauseScreen(togglePause = true) :
	if togglePause : setPaused(false)
	pausescreen.hide()

func showPauseScreen() :
	if OS.has_touchscreen_ui_hint():
		OS.alert("Ehhh", "You can't really pause here lmao")
		pausescreen.hide()
	else:
		pausescreen.show()
		setPaused(true)

func _on_Dialog_buttonPressed(btn):
	
	hidePauseScreen((btn == DialogController.BUTTONS.BTN_A))
	
	if btn == DialogController.BUTTONS.BTN_B : 
		gameview.table.do_finish_animation()
		pausescreen = null
