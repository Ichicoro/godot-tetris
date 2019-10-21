extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func show_notification(title: String, subtitle: String = ""):
	var notification = load("res://Notification.tscn").instance()
	notification.get_node("Title").text = title
	notification.get_node("Subtitle").text = subtitle
	get_tree().root.add_child(notification)


func pause_node(node : Node) -> void:
	node.set_process(false)
	node.set_process_internal(false)
	for c in get_children():
		pause_node(c)


func unpause_node(node : Node) -> void:
	node.set_process(true)
	node.set_process_internal(true)
	for c in get_children():
		unpause_node(c)

