extends Node

onready var AlertScene = preload("res://scenes/Alert.tscn")

func show_alert(text):
	var scene = AlertScene.instance()
	scene.set_alert_text(text)
	return scene
