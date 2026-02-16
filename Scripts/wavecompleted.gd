extends Control

var abilities_to_buy = []

func _ready() -> void:
	if Globals.wave % 2 != 0: # if the wave isn't a multiple of 2, just go to next wave
		next_wave()
	
	$CoinsLabel.text = "Coins: " + str(Globals.coins)
	
	$UpgradePicking.hide()
	$AbilityPicking.show()
	
	if "speed" not in Globals.equipped_cards:
		abilities_to_buy.append("speed")
	if "clean" not in Globals.equipped_cards:
		abilities_to_buy.append("clean")
	
	for i in range(2):
		if len(abilities_to_buy) < 2:
			abilities_to_buy.append("")
	
	$AbilityPicking/HBoxContainer/AbilityButton1.text = abilities_to_buy[0]
	$AbilityPicking/HBoxContainer/AbilityButton2.text = abilities_to_buy[1]

func next_wave():
	Globals.wave += 1
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

func _on_ability_button_1_pressed() -> void:
	Globals.equipped_cards.append(abilities_to_buy[0])
	$AbilityPicking.hide()
	$UpgradePicking.show()

func _on_ability_button_2_pressed() -> void:
	Globals.equipped_cards.append(abilities_to_buy[1])
	$AbilityPicking.hide()
	$UpgradePicking.show()

func _on_upgrade_button_1_pressed() -> void:
	if Globals.coins >= 10:
		Globals.coins -= 10
		Globals.player_speed += 50
		next_wave()
	else:
		$UpgradePicking/HBoxContainer/UpgradeButton1.disabled = true
		$UpgradePicking/HBoxContainer/UpgradeButton1.text = "Too poor to buy."

func _on_upgrade_button_2_pressed() -> void:
	if Globals.coins >= 11:
		Globals.coins -= 11
		# todo: actually implement this
		next_wave()
	else:
		$UpgradePicking/HBoxContainer/UpgradeButton2.disabled = true
		$UpgradePicking/HBoxContainer/UpgradeButton2.text = "Too poor to buy."

func _on_skip_button_pressed() -> void:
	next_wave()
