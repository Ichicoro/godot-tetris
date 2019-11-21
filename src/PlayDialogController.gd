extends Control

var template_str: String = '%s'
var levelValue: int = Settings.min_difficulty
onready var incrBtn = $Panel/VBoxContainer/HBoxContainer/incrLvlBtn
onready var decrBtn = $Panel/VBoxContainer/HBoxContainer/decrLvlBtn
onready var levelLabel = $Panel/VBoxContainer/HBoxContainer/ChosenLevel
onready var audio = $AudioStreamPlayer2D

enum LVL_EDIT \
{
	INCREASE = 1,
	DECREASE = -1
}

func _ready():
	
	grab_focus()
	incrBtn.disabled = false
	decrBtn.disabled = true
	setLevelLabel()

func incrLevel() :
	
	setLevel(LVL_EDIT.INCREASE)
	
func decrLevel() :
	
	setLevel(LVL_EDIT.DECREASE)
		
func setLevel(direction) :
	
	var condition = false
	
	match (direction) :
		
		LVL_EDIT.DECREASE : condition = (levelValue > Settings.min_difficulty)
		LVL_EDIT.INCREASE : condition = (levelValue < Settings.max_difficulty)
	
	if condition :
		levelValue += direction
		audio.play()
		incrBtn.disabled = not(levelValue < Settings.max_difficulty)
		decrBtn.disabled = not(levelValue > Settings.min_difficulty)
		setLevelLabel()

func setLevelLabel() :

	levelLabel.text = template_str % str(levelValue)

func _input(event):
	
	if Input.is_action_just_pressed("menu"):
		queue_free()
	elif Input.is_action_just_pressed("ui_accept"):
		startGame()
	elif Input.is_action_just_pressed("move_left"):
		decrLevel()
	elif Input.is_action_just_pressed("move_right"):
		incrLevel()
		
func startGame() :
	queue_free()
	SceneSwitcher.change_scene("res://scenes/GameScene.tscn", {level=levelValue})
