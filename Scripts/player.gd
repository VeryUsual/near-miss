extends CharacterBody2D

var speed = 500
var shiftingenergy = 100

func _physics_process(delta):
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
	get_parent().get_node("CanvasLayer/ShiftingEnergyBar").value = shiftingenergy
	if shiftingenergy >= 100:
		get_parent().get_node("CanvasLayer/ShiftingEnergyBar").visible = false
	else:
		get_parent().get_node("CanvasLayer/ShiftingEnergyBar").visible = true

func _on_hitbox_body_entered(body: Node2D) -> void:
	get_parent().get_node("Camera2D").add_trauma(0.5)
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://Scenes/GameOver.tscn")
