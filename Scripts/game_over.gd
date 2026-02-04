extends Control

func _ready() -> void:
	Engine.time_scale = 1.0
	$PBLabel.hide()
	
	$Label2.text = "You survived for " + str(snapped(Globals.last_game_duration, 0.01)) + " seconds."
	if Globals.last_game_duration > Globals.personal_best:
		Globals.personal_best = Globals.last_game_duration
		$PBLabel.text = "You set a NEW personal best!"
	else:
		$PBLabel.text = "Personal Best: " + str(snapped(Globals.personal_best, 0.01)) + " seconds."
	$PBLabel.show()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")

func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
