extends Node

var hiscoreFile = "user://hiscore.save"
var settingsFile = "user://settings.save"

func _ready():
	print(OS.min_window_size)
	OS.min_window_size = Vector2(430,512)
	if not OS.has_touchscreen_ui_hint():
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, SceneTree.STRETCH_ASPECT_KEEP, Vector2(430,512))


func show_notification(title: String, subtitle: String = ""):
	var dialog = Dialog.new(title, "Ok", "Enter", "ui_accept")
	dialog.one_button()
	dialog.add_subtitle(subtitle)
	get_tree().root.add_child(dialog)
	return dialog


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
	save_game.open(hiscoreFile, File.WRITE)
	save_game.seek(0)
	save_game.store_16(score)
	save_game.close()
	
func save_settings() :
	var save_sets = File.new()
	save_sets.open(settingsFile, File.WRITE)
	save_sets.seek(0)
	save_sets.store_8(Settings.canPlayMusic)
	save_sets.store_8(Settings.canPlaySFX)
	save_sets.close()


func load_hiscore() -> int:
	var save_game = File.new()
	if not save_game.file_exists(hiscoreFile):
		return -1
	save_game.open(hiscoreFile, File.READ)
	var hiscore = save_game.get_16()
	save_game.close()
	return hiscore

func load_settings() -> bool:
	var save_sets = File.new()
	if not save_sets.file_exists(settingsFile):
		return false
	save_sets.open(settingsFile, File.READ)
	Settings.canPlayMusic = (save_sets.get_8() != 0)
	Settings.canPlaySFX = (save_sets.get_8() != 0)
	save_sets.close()
	
	return true

func print_hiscore_file():
	var save_game = File.new()
	if not save_game.file_exists(hiscoreFile):
		print_debug('ded file')
		return
	save_game.open(hiscoreFile, File.READ)
	print_debug(save_game.get_as_text())
	save_game.close()


func get_version() -> String:
	return "v" + str(ProjectSettings.get_setting("application/config/version"))
