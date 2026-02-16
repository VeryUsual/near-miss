extends Control

func _ready() -> void:
	$TabContainer/Graphics/Graphics/ScreenShakeIntensitySlider.value = Globals.screenshake_power

func _on_apply_and_exit_button_pressed() -> void:
	if $TabContainer/Graphics/Graphics/ScreenShakeIntensitySlider.value == 1.0 or $TabContainer/Graphics/Graphics/ScreenShakeIntensitySlider.value == 2.0:
		Globals.screenshake_power = $TabContainer/Graphics/Graphics/ScreenShakeIntensitySlider.value
	
	Globals.master_volume = $TabContainer/Audio/VBoxContainer/MasterVolumeSlider.value
	Globals.music_volume = $TabContainer/Audio/VBoxContainer/MusicVolumeSlider.value
	Globals.sfx_volume = $TabContainer/Audio/VBoxContainer/SFXVolumeSlider.value
	
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
