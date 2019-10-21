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
	if !gameview.get("table").can_tick:
		return
	if gameview.get("paused"):
		if Input.is_action_just_pressed("menu"):
			gameview.set("paused", false)
			pausescreen.hide()
		if Input.is_key_pressed(KEY_Q):
			print("Quit to main menu")
			get_tree().change_scene("res://MainMenu.tscn")
	else:
		if Input.is_action_just_pressed("menu"):
			gameview.set("paused", true)
			pausescreen.show()
	return

