extends CharacterBody2D

var speed = 500

func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed

	move_and_slide()
	
	if global_position.x >= 1152+30 or global_position.x <= -10-30:
		get_tree().change_scene_to_file("res://Scenes/GameOver.tscn")
	if global_position.y >= 648+30 or global_position.y <= -10-30:
		get_tree().change_scene_to_file("res://Scenes/GameOver.tscn")

func _on_hitbox_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://Scenes/GameOver.tscn")
