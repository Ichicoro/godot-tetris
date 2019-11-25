extends Node


func _ready():
	print(OS.min_window_size)
	OS.min_window_size = Vector2(430,512)
	if not OS.has_touchscreen_ui_hint():
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, SceneTree.STRETCH_ASPECT_KEEP, Vector2(430,512))


func show_notification(title: String, subtitle: String = ""):
	var notification = load("res://scenes/Notification.tscn").instance()
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


func save_hiscore(score: int):
	var save_game = File.new()
	save_game.open("user://hiscore.save", File.WRITE)
	save_game.seek(0)
	save_game.store_16(score)
	save_game.close()


func load_hiscore() -> int:
	var save_game = File.new()
	if not save_game.file_exists("user://hiscore.save"):
		return -1
	save_game.open("user://hiscore.save", File.READ)
	var hiscore = save_game.get_16()
	save_game.close()
	return hiscore


func print_hiscore_file():
	var save_game = File.new()
	if not save_game.file_exists("user://hiscore.save"):
		print_debug('ded file')
		return
	save_game.open("user://hiscore.save", File.READ)
	print_debug(save_game.get_as_text())
	save_game.close()


func get_version() -> String:
	return "v" + str(ProjectSettings.get_setting("application/config/version"))
