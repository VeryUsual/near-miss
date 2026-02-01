extends Control

func _on_button_pressed() -> void:
	if $OptionButton.get_selected() == -1:
		get_tree().quit()
	Globals.difficulty = $OptionButton.get_item_text($OptionButton.get_selected())
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
