extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var gameview: Node = null
var pausescreen: Node = null

# Called when the node enters the scene tree for the first time.
func _ready():
	gameview = get_parent().get_node("Game view/GridContainer")
	pausescreen = get_parent().get_node("Pause screen")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !gameview.get("table").can_tick or pausescreen == null:
		return
	if gameview.get("paused"):
		if Input.is_action_just_pressed("menu"):
			gameview.set("paused", false)
			pausescreen.hide()
		if Input.is_key_pressed(KEY_Q):
			pausescreen.hide()
			gameview.table.do_finish_animation()
			pausescreen = null
			return
			var old_hiscore = Utils.load_hiscore()
			if gameview.table.total_lines_cleared > old_hiscore:
				Utils.save_hiscore(gameview.table.total_lines_cleared)
				Utils.show_notification("HI SCORE!", "New score: " + str(gameview.table.total_lines_cleared) + "\nPress ENTER to exit.")
			else:
				Utils.show_notification("GAME OVER", "Total score: " + str(gameview.table.total_lines_cleared) + "\nPress ENTER to exit.")
	else:
		if Input.is_action_just_pressed("menu"):
			gameview.set("paused", true)
			pausescreen.show()
	return

