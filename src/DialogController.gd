extends Panel
class_name DialogController

signal buttonPressed(btn)

enum BUTTONS { BTN_A, BTN_B }

var btnA = null
var actionA = ""

var btnB = null
var actionB = ""

const subFormatStr = "[%s]"

var signalSent = false

func _ready():
	$AnimationPlayer.play("OpenAnimation", -1, 2)

func setup(msg, btnAName, kA, actA, btnBName = "Cancel", kB = "Esc", actB = "menu"):
	$VBoxContainer/Title.text = msg
	
	btnA = $VBoxContainer/HBoxContainer/VBoxContainer/BtnA
	btnA.text = btnAName
	actionA = actA
	if OS.has_touchscreen_ui_hint():
		$VBoxContainer/HBoxContainer/VBoxContainer/KeyA.queue_free()
	else:
		$VBoxContainer/HBoxContainer/VBoxContainer/KeyA.text = subFormatStr % kA
	
	btnB = $VBoxContainer/HBoxContainer/VBoxContainer2/BtnB
	btnB.text = btnBName
	actionB = actB
	if OS.has_touchscreen_ui_hint():
		$VBoxContainer/HBoxContainer/VBoxContainer2/KeyB.queue_free()
	else:
		$VBoxContainer/HBoxContainer/VBoxContainer2/KeyB.text = subFormatStr % kB

func _input(event):
	if not event is InputEventKey: return
	if Input.is_action_just_pressed(actionA) :
		emit_signal("buttonPressed", BUTTONS.BTN_A)
	elif Input.is_action_just_pressed(actionB) :
		emit_signal("buttonPressed", BUTTONS.BTN_B)

func _on_BtnA_pressed():
	if not signalSent :
		emit_signal("buttonPressed", BUTTONS.BTN_A)
		signalSent = true
	
func _on_BtnB_pressed():
	if not signalSent :
		emit_signal("buttonPressed", BUTTONS.BTN_B)
		signalSent = true

func _on_Dialog_visibility_changed():
	signalSent = false
