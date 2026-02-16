extends Node2D

@export var enemy_scene: PackedScene
var spawn_timer: Timer

@onready var countdowntext_tween := get_tree().create_tween()
var countdowntext_texts := ["3", "2", "1", "GO"]
var countdowntext_index := 0

var game_started = false

var current_normal_timescale = 1.0

var enabled_cards = Globals.equipped_cards.duplicate()

var environment

var game_duration := 0.0

var coin_scene = preload("res://Scenes/coin.tscn")

var saturation_value: float = 1.0:
	set(value):
		saturation_value = value
		if environment:
			environment.adjustment_enabled = true
			environment.adjustment_saturation = value

func _ready() -> void:
	environment = $WorldEnvironment.environment
	
	$CanvasLayer/CardDeck.visible = false
	$CanvasLayer/CoinLabel.visible = false
	
	$CanvasLayer/WaveLabel.text = "Wave " + str(Globals.wave)
	
	$CanvasLayer/FadeTransition/AnimationPlayer.play("fade_out")
	
	spawn_timer = Timer.new()
	if Globals.difficulty == "GOD":
		spawn_timer.wait_time = 0.1
	elif Globals.difficulty == "Hard":
		spawn_timer.wait_time = 0.4
	else:
		spawn_timer.wait_time = 0.6
	if Globals.wave >= 4:
		spawn_timer.wait_time = spawn_timer.wait_time / 1.5
	if Globals.wave >= 8:
		spawn_timer.wait_time = spawn_timer.wait_time / 1.5
	spawn_timer.one_shot = false
	spawn_timer.autostart = true
	add_child(spawn_timer)
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	
	if Globals.difficulty != "GOD":
		if Globals.wave >= 2:
			$ArcherEnemy.enabled = true
		if Globals.wave >= 3:
			$ArcherEnemy2.enabled = true
		if Globals.wave >= 4:
			$ArcherEnemy3.enabled = true
		if Globals.wave >= 5:
			$ArcherEnemy4.enabled = true
	else:
		$ArcherEnemy.enabled = true
		$ArcherEnemy2.enabled = true
		$ArcherEnemy3.enabled = true
		$ArcherEnemy4.enabled = true
	
	if Globals.wave == 4:
		$KingSnipe.enabled = true
		spawn_timer.wait_time = 5.0
	
	$Camera2D.zoom = Vector2(0.7, 0.7)
	var tween := create_tween()
	tween.tween_property(
		$Camera2D,
		"zoom",
		Vector2(0.9, 0.9),
		1.2
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	$CanvasLayer/Countdown.scale = Vector2.ONE
	$CanvasLayer/Countdown.pivot_offset = $CanvasLayer/Countdown.size / 2
	_next_number()

func _on_spawn_timer_timeout() -> void:
	if game_started:
		randomize()
		var spawn_positions = $EnemySpawnPositions.get_children()
		var spawn_pos = spawn_positions[randi() % spawn_positions.size()].position
		
		var enemy = enemy_scene.instantiate()
		enemy.position = spawn_pos
		add_child(enemy)

func _on_countdowntext_done():
	game_started = true

func _next_number():
	if countdowntext_index >= countdowntext_texts.size():
		countdowntext_tween = get_tree().create_tween()
		countdowntext_tween.tween_property($CanvasLayer/Countdown, "scale", Vector2.ZERO, 0.4).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		countdowntext_tween.tween_callback(Callable(self, "_on_countdowntext_done"))
		return

	$CanvasLayer/Countdown.text = countdowntext_texts[countdowntext_index]
	countdowntext_index += 1

	$CanvasLayer/Countdown.scale = Vector2(0.2, 0.2)
	countdowntext_tween = get_tree().create_tween()
	countdowntext_tween.tween_property($CanvasLayer/Countdown, "scale", Vector2.ONE, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	countdowntext_tween.tween_interval(0.1)
	countdowntext_tween.tween_callback(Callable(self, "_next_number"))

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("open_deck"):
		if $CanvasLayer/CardDeck.visible == false:
			var saturationtween = get_tree().create_tween()
			saturation_value = 2.0
			saturationtween.tween_property(self, "saturation_value", 0.1, 0.2)
		if "slowmo" in enabled_cards:
			$CanvasLayer/CardDeck/Card1Area2D/Sprite2D.modulate = Color(1.0, 1.0, 1.0)
		else:
			$CanvasLayer/CardDeck/Card1Area2D/Sprite2D.modulate = Color(0.5, 0.5, 0.5)
		if "clean" in enabled_cards:
			$CanvasLayer/CardDeck/Card2Area2D/Sprite2D.modulate = Color(1.0, 1.0, 1.0)
		else:
			$CanvasLayer/CardDeck/Card2Area2D/Sprite2D.modulate = Color(0.5, 0.5, 0.5)
		
		if "slowmo" in Globals.equipped_cards:
			$CanvasLayer/CardDeck/Card1Area2D/Sprite2D.modulate = Color(1.0, 1.0, 1.0, 1.0)
		else:
			$CanvasLayer/CardDeck/Card1Area2D/Sprite2D.modulate = Color(0.0, 0.0, 0.0, 0.0)
		if "clean" in Globals.equipped_cards:
			$CanvasLayer/CardDeck/Card2Area2D/Sprite2D.modulate = Color(1.0, 1.0, 1.0, 1.0)
		else:
			$CanvasLayer/CardDeck/Card2Area2D/Sprite2D.modulate = Color(0.0, 0.0, 0.0, 0.0)
		if "speed" in Globals.equipped_cards:
			$CanvasLayer/CardDeck/Card3Area2D/Sprite2D.modulate = Color(1.0, 1.0, 1.0, 1.0)
		else:
			$CanvasLayer/CardDeck/Card3Area2D/Sprite2D.modulate = Color(0.0, 0.0, 0.0, 0.0)
		
		$CanvasLayer/CardDeck.visible = true
		Engine.time_scale = 0.25
	else:
		if $CanvasLayer/CardDeck.visible == true:
			var saturationtween = get_tree().create_tween()
			saturation_value = 0.1
			saturationtween.tween_property(self, "saturation_value", 2.0, 0.2)
		$CanvasLayer/CardDeck.visible = false
		Engine.time_scale = current_normal_timescale
	
	if Input.is_action_just_pressed("esc"):
		if $CanvasLayer/ESCMenu.visible:
			Engine.time_scale = 1.0
			current_normal_timescale = 1.0
			$CanvasLayer/ESCMenu.visible = false
		else:
			Engine.time_scale = 0.001
			current_normal_timescale = 0.001
			$CanvasLayer/ESCMenu.visible = true

func _on_card_1_area_2d_mouse_entered() -> void:
	var cardopentween = get_tree().create_tween()
	cardopentween.tween_property($CanvasLayer/CardDeck/Card1Area2D, "position", Vector2(0, -130), 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

func _on_card_1_area_2d_mouse_exited() -> void:
	var cardclosetween = get_tree().create_tween()
	cardclosetween.tween_property($CanvasLayer/CardDeck/Card1Area2D, "position", Vector2.ZERO, 0.06).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

func _on_card_1_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if "slowmo" in enabled_cards and "slowmo" in Globals.equipped_cards:
				var cardclosetween = get_tree().create_tween()
				cardclosetween.tween_property($CanvasLayer/CardDeck/Card1Area2D/Sprite2D, "modulate", Color(0.5, 0.5, 0.5), 0.06).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
				enabled_cards.erase("slowmo")
				$CanvasLayer/CardDeck.visible = false
				current_normal_timescale = 0.5
				Engine.time_scale = current_normal_timescale
				await get_tree().create_timer(2.5).timeout
				current_normal_timescale = 1.0
				Engine.time_scale = current_normal_timescale
				$CanvasLayer/CardDeck/Card1Area2D/Card1CooldownTimer.start()
				$CanvasLayer/CardDeck/Card1Area2D/Card1CooldownTimerLabel.visible = true
				$CanvasLayer/CardDeck/Card1Area2D/Card1CooldownTimerLabel.text = "15"
				await $CanvasLayer/CardDeck/Card1Area2D/Card1CooldownTimer.timeout  # card use cooldown also
				enabled_cards.append("slowmo")

func _process(delta: float) -> void:
	if game_started:
		$CanvasLayer/CoinLabel.visible = true
		$CanvasLayer/CoinLabel.text = "Coins: " + str(Globals.coins)
		
		game_duration += delta
		if (Globals.wave_durations[Globals.wave-1] - snapped(game_duration, 0.1) <= 0):
			$CanvasLayer/WaveCompleted.show()
			await get_tree().create_timer(0.5).timeout
			get_tree().change_scene_to_file("res://Scenes/wavecompleted.tscn")
		var gamedurlabeltext = str(Globals.wave_durations[Globals.wave-1] - snapped(game_duration, 0.1))
		if len(gamedurlabeltext.split(".")[1]) == 0:
			gamedurlabeltext = gamedurlabeltext + "0"
		$CanvasLayer/GameDurationLabel.text = gamedurlabeltext
	
	if $CanvasLayer/CardDeck/Card1Area2D/Card1CooldownTimer.time_left != 0:
		$CanvasLayer/CardDeck/Card1Area2D/Card1CooldownTimerLabel.visible = true
		$CanvasLayer/CardDeck/Card1Area2D/Card1CooldownTimerLabel.text = str(int($CanvasLayer/CardDeck/Card1Area2D/Card1CooldownTimer.time_left))
	else:
		$CanvasLayer/CardDeck/Card1Area2D/Card1CooldownTimerLabel.visible = false
	if $CanvasLayer/CardDeck/Card2Area2D/Card2CooldownTimer.time_left != 0:
		$CanvasLayer/CardDeck/Card2Area2D/Card2CooldownTimerLabel.visible = true
		$CanvasLayer/CardDeck/Card2Area2D/Card2CooldownTimerLabel.text = str(int($CanvasLayer/CardDeck/Card2Area2D/Card2CooldownTimer.time_left))
	else:
		$CanvasLayer/CardDeck/Card2Area2D/Card2CooldownTimerLabel.visible = false
	if $CanvasLayer/CardDeck/Card3Area2D/Card3CooldownTimer.time_left != 0:
		$CanvasLayer/CardDeck/Card3Area2D/Card3CooldownTimerLabel.visible = true
		$CanvasLayer/CardDeck/Card3Area2D/Card3CooldownTimerLabel.text = str(int($CanvasLayer/CardDeck/Card3Area2D/Card3CooldownTimer.time_left))
	else:
		$CanvasLayer/CardDeck/Card3Area2D/Card3CooldownTimerLabel.visible = false

func _on_card_2_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if "clean" in enabled_cards and "clean" in Globals.equipped_cards:
				var cardclosetween = get_tree().create_tween()
				cardclosetween.tween_property($CanvasLayer/CardDeck/Card2Area2D/Sprite2D, "modulate", Color(0.5, 0.5, 0.5), 0.06).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
				enabled_cards.erase("clean")
				$CanvasLayer/CardDeck.visible = false
				var enemies := get_tree().get_nodes_in_group("Enemy")
				for enemy in enemies:
					enemy.queue_free()
				$CanvasLayer/CardDeck/Card2Area2D/Card2CooldownTimer.start()
				$CanvasLayer/CardDeck/Card2Area2D/Card2CooldownTimerLabel.visible = true
				$CanvasLayer/CardDeck/Card2Area2D/Card2CooldownTimerLabel.text = "50"
				await $CanvasLayer/CardDeck/Card2Area2D/Card2CooldownTimer.timeout  # card use cooldown also
				enabled_cards.append("clean")

func _on_card_2_area_2d_mouse_entered() -> void:
	var cardopentween = get_tree().create_tween()
	cardopentween.tween_property($CanvasLayer/CardDeck/Card2Area2D, "position", Vector2(162, -130), 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

func _on_card_2_area_2d_mouse_exited() -> void:
	var cardclosetween = get_tree().create_tween()
	cardclosetween.tween_property($CanvasLayer/CardDeck/Card2Area2D, "position", Vector2(162, 0), 0.06).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)


func _on_card_3_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if "speed" in enabled_cards and "speed" in Globals.equipped_cards:
				var cardclosetween = get_tree().create_tween()
				cardclosetween.tween_property($CanvasLayer/CardDeck/Card3Area2D/Sprite2D, "modulate", Color(0.5, 0.5, 0.5), 0.06).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
				enabled_cards.erase("speed")
				$CanvasLayer/CardDeck.visible = false
				$Player.speed = 1100
				await get_tree().create_timer(2.5).timeout
				$Player.speed = 500
				$CanvasLayer/CardDeck/Card3Area2D/Card3CooldownTimer.start()
				$CanvasLayer/CardDeck/Card3Area2D/Card3CooldownTimerLabel.visible = true
				$CanvasLayer/CardDeck/Card3Area2D/Card3CooldownTimerLabel.text = "50"
				await $CanvasLayer/CardDeck/Card3Area2D/Card3CooldownTimer.timeout
				enabled_cards.append("speed")

func _on_card_3_area_2d_mouse_entered() -> void:
	var cardopentween = get_tree().create_tween()
	cardopentween.tween_property($CanvasLayer/CardDeck/Card3Area2D, "position", Vector2(325, -130), 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

func _on_card_3_area_2d_mouse_exited() -> void:
	var cardclosetween = get_tree().create_tween()
	cardclosetween.tween_property($CanvasLayer/CardDeck/Card3Area2D, "position", Vector2(325, 0), 0.06).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

func _on_exit_to_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")

func _on_coin_spawn_timer_timeout() -> void:
	var coin = coin_scene.instantiate()
	add_child(coin)
	coin.position = Vector2(randi_range(20, 1000), randi_range(20, 600))
	
	if Globals.wave == 4:
		var coinn
		for n in range(3):
			coinn = coin_scene.instantiate()
			add_child(coinn)
			coinn.position = Vector2(randi_range(20, 1000), randi_range(20, 600))
