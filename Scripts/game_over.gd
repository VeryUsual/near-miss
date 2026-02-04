extends Control

var last_game_duration: int = 0: set = _on_last_game_dur_set
var fake_tweened_last_game_duration: int = 0: set = _on_fake_tweened_last_game_duration_set
var tween: Tween

func _ready() -> void:
	Engine.time_scale = 1.0
	$PBLabel.hide()
	
	last_game_duration = snapped(Globals.last_game_duration, 0.01)
	
	if Globals.last_game_duration > Globals.personal_best:
		Globals.personal_best = Globals.last_game_duration
		$PBLabel.text = "You set a NEW personal best!"
	else:
		$PBLabel.text = "Personal Best: " + str(snapped(Globals.personal_best, 0.01)) + " seconds."
	$PBLabel.show()

func _on_last_game_dur_set(new_value: int) -> void:
	last_game_duration = new_value
	
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	if last_game_duration >= 5.0:
		if last_game_duration <= 10.0:
			tween.tween_property(self, "fake_tweened_last_game_duration", last_game_duration, 1.0)
		else:
			tween.tween_property(self, "fake_tweened_last_game_duration", last_game_duration, 2.0)
	else:
		fake_tweened_last_game_duration = last_game_duration

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")

func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

func _on_fake_tweened_last_game_duration_set(new_value: int) -> void:
	fake_tweened_last_game_duration = new_value
	$Label2.text = "You survived for " + str(snapped(fake_tweened_last_game_duration, 0.01)) + " seconds."
