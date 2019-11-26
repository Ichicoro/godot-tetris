extends Panel

class_name DialogController

signal buttonPressed(btn)

enum BUTTONS { BTN_A, BTN_B }

onready var btnA = $VBoxContainer/HBoxContainer/VBoxContainer/BtnA
var actionA = ""

onready var btnB = $VBoxContainer/HBoxContainer/VBoxContainer2/BtnB
var actionB = ""

const subFormatStr = "[%s]"

func _ready():
	$AnimationPlayer.seek(0)
	$AnimationPlayer.play("OpenAnimation", -1, 2)

func setup(msg, btnAName, kA, actA, btnBName = "Cancel", kB = "Esc", actB = "menu") :
	$VBoxContainer/Title.text = msg
	
	btnA.text = btnAName
	actionA = actA
	$VBoxContainer/HBoxContainer/VBoxContainer/KeyA.text = subFormatStr % kA
	
	btnB.text = btnBName
	actionB = actB
	$VBoxContainer/HBoxContainer/VBoxContainer2/KeyB.text = subFormatStr % kB
	
func _input(event):
	if Input.is_action_just_pressed(actionA) :
		emit_signal("buttonPressed", BUTTONS.BTN_A)
	elif Input.is_action_just_pressed(actionB) :
		emit_signal("buttonPressed", BUTTONS.BTN_A)

func _on_BtnA_pressed():
	emit_signal("buttonPressed", BUTTONS.BTN_A)
	
func _on_BtnB_pressed():
	emit_signal("buttonPressed", BUTTONS.BTN_B)
