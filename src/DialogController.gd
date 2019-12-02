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
	var keyA = $VBoxContainer/HBoxContainer/VBoxContainer/KeyA
	btnB = $VBoxContainer/HBoxContainer/VBoxContainer2/BtnB
	var keyB = $VBoxContainer/HBoxContainer/VBoxContainer2/KeyB
	
	btnA.text = btnAName
	actionA = actA
	if OS.has_touchscreen_ui_hint():
		keyA.queue_free()
	else:
		keyA.text = subFormatStr % kA
	
	btnB.text = btnBName
	actionB = actB
	if OS.has_touchscreen_ui_hint():
		keyB.queue_free()
	else:
		keyB.text = subFormatStr % kB

func remove_one_button():
	$VBoxContainer/HBoxContainer/VBoxContainer2.queue_free()

func add_subtitle(subtitle: String = ""):
	$VBoxContainer/Subtitle.show()
	$VBoxContainer/Subtitle.text = subtitle

func _input(event):
	if event is InputEventKey: 
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
