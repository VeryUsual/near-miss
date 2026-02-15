extends Control

var abilities_to_buy = []

func _ready() -> void:
	if "speed" not in Globals.equipped_cards:
		abilities_to_buy.append("speed")
	if "clean" not in Globals.equipped_cards:
		abilities_to_buy.append("clean")
	
	for i in range(2):
		if len(abilities_to_buy) < 2:
			abilities_to_buy.append("")
	
	$AbilityButton1.text = abilities_to_buy[0]
	$AbilityButton2.text = abilities_to_buy[1]

func next_wave():
	Globals.wave += 1
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

func _on_ability_button_1_pressed() -> void:
	Globals.equipped_cards.append(abilities_to_buy[0])
	next_wave()

func _on_ability_button_2_pressed() -> void:
	Globals.equipped_cards.append(abilities_to_buy[1])
	next_wave()
