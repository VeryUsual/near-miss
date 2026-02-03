extends Control

var button_type = null

func _on_button_pressed() -> void:
	button_type = "play"
	$FadeTransition.show()
	$FadeTransition/fade_timer.start()
	$FadeTransition/AnimationPlayer.play("fade_in")

func _on_fade_timer_timeout() -> void:
	if button_type == "play":
		if $VBoxContainer/HBoxContainer/OptionButton.get_selected() == -1:
			get_tree().quit()
		Globals.difficulty = $VBoxContainer/HBoxContainer/OptionButton.get_item_text($VBoxContainer/HBoxContainer/OptionButton.get_selected()).strip_edges(true, true)
		get_tree().change_scene_to_file("res://Scenes/game.tscn")
