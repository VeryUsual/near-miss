extends CharacterBody2D

var speed = Globals.player_speed
var shiftingenergy = 100
var coins = 0
var health = Globals.max_hp

var gameover = false

func _physics_process(delta):
	if get_tree().current_scene.get_node("CanvasLayer/CardDeck").visible == false and gameover == false:
		var direction = Input.get_vector("left", "right", "up", "down")
		var shifting = false
		
		if Input.is_action_pressed("shift") and shiftingenergy > 0:
			shifting = true
			velocity = direction * (speed * 2)
			if direction != Vector2.ZERO: # deplete energy only when we're moving
				shiftingenergy -= 1
		else:
			velocity = direction * speed

		move_and_slide()
		
		if not shifting and shiftingenergy < 100:
			shiftingenergy += 0.065

func _process(delta: float) -> void:
	get_tree().current_scene.get_node("CanvasLayer/HealthBar").value = health
	
	get_parent().get_node("CanvasLayer/ShiftingEnergyBar").value = shiftingenergy
	if shiftingenergy >= 100:
		get_parent().get_node("CanvasLayer/ShiftingEnergyBar").visible = false
	else:
		get_parent().get_node("CanvasLayer/ShiftingEnergyBar").visible = true

func hurt():
	health -= 1
	
	if health <= 0:
		get_tree().current_scene.get_node("ExplosionSFXAudioPlayer").play()
		get_parent().get_node("Camera2D").add_trauma(0.5)
		Globals.last_game_duration = get_tree().current_scene.game_duration
		
		get_tree().current_scene.get_node("CanvasLayer/GameDurationLabel").visible = false
		
		var saturationtween = get_tree().create_tween()
		get_tree().current_scene.saturation_value = 2.0
		saturationtween.tween_property(get_tree().current_scene, "saturation_value", 0.01, 0.3)
		
		var enemies := get_tree().get_nodes_in_group("Enemy")
		for enemy in enemies:
			enemy.queue_free()
			
		get_tree().current_scene.get_node("CanvasLayer/FadeTransition/AnimationPlayer").play("fade_in")
		
		gameover = true
		get_tree().current_scene.get_node("CanvasLayer/CardDeck").visible = false
		get_tree().current_scene.get_node("CanvasLayer/CardDeck").modulate = Color(0, 0, 0, 0) # a weird trick to force the carddeck to be not visible during this period
		
		await get_tree().create_timer(0.9).timeout
		
		Engine.time_scale = 1.0
		
		get_tree().change_scene_to_file("res://Scenes/GameOver.tscn")
	else:
		get_parent().get_node("Camera2D").add_trauma(0.3)

func _on_hitbox_body_entered(body: Node2D) -> void:
	hurt()
