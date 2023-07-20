extends Control

func _ready():
	get_tree().reload_scene()

func _on_Retry_pressed():
	get_tree().change_scene("res://Scenes/World.tscn")

func _on_Quit_pressed():
	get_tree().quit()
