extends Control

func _ready() -> void:
	$Label2.text = "You survived for " + str(snapped(Globals.last_game_duration, 0.01)) + " seconds."

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
