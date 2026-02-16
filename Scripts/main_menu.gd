extends Control

var button_type = null

func _ready() -> void:
	Engine.time_scale = 1.0
	
	var versiontwotween = create_tween()
	versiontwotween.set_loops()
	
	versiontwotween.tween_property(
		$VersionTwoText,
		"theme_override_font_sizes/font_size", 21, 0.5
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	versiontwotween.tween_property(
		$VersionTwoText,
		"theme_override_font_sizes/font_size", 19, 0.5
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	versiontwotween.tween_property(
		$VersionTwoText,
		"theme_override_font_sizes/font_size", 20, 0.5
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_button_pressed() -> void:
	button_type = "play"
	$FadeTransition.show()
	$FadeTransition/fade_timer.start()
	$FadeTransition/AnimationPlayer.play("fade_in")

func _on_fade_timer_timeout() -> void:
	if button_type == "play":
		#Globals.wave = 4 ###### CHEAT
		if $VBoxContainer/HBoxContainer/OptionButton.get_selected() == -1:
			Globals.difficulty = "Medium"
		Globals.difficulty = $VBoxContainer/HBoxContainer/OptionButton.get_item_text($VBoxContainer/HBoxContainer/OptionButton.get_selected()).strip_edges(true, true)
		get_tree().change_scene_to_file("res://Scenes/game.tscn")
