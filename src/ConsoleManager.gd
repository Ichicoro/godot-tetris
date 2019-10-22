extends Node

onready var main_ui: Node = get_tree().root.get_children()[-1]
onready var consolecontrol = load("res://ConsoleUI.tscn")
onready var base_window = str(main_ui.get_path()) + "/ConsoleControl/ConsoleWindow"


func _ready():
	#main_ui.add_child(consolecontrol.instance())
	pass


func _process(delta):
	if not Settings.is_console_enabled:
		return
	if Input.is_action_just_pressed("console_toggle"):
		if get_node(base_window) == null:
			get_tree().root.get_children()[-1].add_child(consolecontrol.instance())
		if get_node(base_window).is_visible_in_tree():
			get_node(base_window).hide()
		else:
#			print(get_node(base_window).print_tree_pretty())
			get_node(base_window).popup()


func print(string: String):
	get_node(base_window + "/ConsoleTextView").bbcode_text += string


func println(string: String):
	self.print(string + '\n')


func handle_input(string: String):
	println("You wrote " + string)
