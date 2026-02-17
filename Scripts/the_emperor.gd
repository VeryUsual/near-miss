extends CharacterBody2D

@onready var bullet_scene = load("res://Scenes/archer_enemy_bullet.tscn")
@onready var non_lethal_bullet_scene = load("res://Scenes/archer_enemy_bullet_non_lethal.tscn")
@onready var player: Node = get_tree().get_first_node_in_group("Player")
@export var enabled = false

var x = 1

var doingexplode = false

var oldplayerpos = Vector2(100, 100)

func _on_shoot_timer_timeout() -> void:
	if enabled and get_tree().current_scene.game_started:
		oldplayerpos = player.global_position
		
		await get_tree().create_timer(1.5).timeout
		
		var tween = get_tree().create_tween()
		tween.tween_property(self, "global_position", get_viewport().get_canvas_transform().affine_inverse() * oldplayerpos, 0.25).set_ease(Tween.EASE_IN)
		
		var bullet = non_lethal_bullet_scene.instantiate()
		if x == 3:
			bullet = bullet_scene.instantiate()
			x = 1
		add_child(bullet)
		bullet.global_position = global_position
		bullet.SPEED = bullet.SPEED * 2.2
		x += 1

func _process(delta: float) -> void:
	if enabled and get_tree().current_scene.game_duration >= 38 and doingexplode == false:
		doingexplode = true
		
		await get_tree().create_timer(0.5).timeout
		
		$ShootTimer.wait_time = 0.02
		await get_tree().create_timer(0.5).timeout
		
		Engine.time_scale = 0.4
		get_tree().current_scene.current_normal_timescale = 0.4
		
		get_tree().current_scene.get_node("Camera2D").add_trauma(0.9)
		$GPUParticles2D.emitting = true
		get_tree().current_scene.get_node("Camera2D").add_trauma(0.9)
		await get_tree().create_timer(0.5).timeout
		$GPUParticles2D.emitting = false
		enabled = false
		visible = false
		$CollisionPolygon2D.disabled = true
	
	if enabled:
		$CollisionPolygon2D.disabled = false
		visible = true
	else:
		$CollisionPolygon2D.disabled = true
		visible = false

func _on_hitbox_body_entered(body: Node2D) -> void:
	if enabled:
		if body.name == "Player":
			body.hurt()
