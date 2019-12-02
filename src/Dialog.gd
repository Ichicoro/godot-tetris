extends Node
class_name Dialog

signal button_a_pressed
signal button_b_pressed

const DialogScene = preload("res://scenes/Dialog.tscn")

var crect: ColorRect
var dialog_instance: DialogController

func _init(msg, btnAName, kA, actA, btnBName = "Cancel", kB = "Esc", actB = "menu"):
	crect = ColorRect.new()
	crect.color = Color(0, 0, 0, 0.62)
	crect.rect_position = Vector2(0,0)
	crect.rect_size = Vector2(430, 512)
	crect.anchor_bottom = 1
	crect.anchor_right = 1
	crect.anchor_top = 0
	crect.anchor_left = 0
	self.add_child(crect)
	dialog_instance = DialogScene.instance()
	dialog_instance.setup(msg, btnAName, kA, actA, btnBName, kB, actB)
	dialog_instance.connect("buttonPressed", self, "handle_btn_pressed")
	self.add_child(dialog_instance)

func handle_btn_pressed(btn):
	match btn:
		DialogController.BUTTONS.BTN_A: emit_signal("button_a_pressed")
		DialogController.BUTTONS.BTN_B: emit_signal("button_b_pressed")
	self.queue_free()

func one_button():
	dialog_instance.remove_one_button()
	return dialog_instance

func add_subtitle(text: String = ""):
	dialog_instance.add_subtitle(text)
