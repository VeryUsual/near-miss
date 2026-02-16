extends CharacterBody2D

@onready var bullet_scene = load("res://Scenes/archer_enemy_bullet.tscn")
@onready var non_lethal_bullet_scene = load("res://Scenes/archer_enemy_bullet_non_lethal.tscn")
@export var enabled = false

var x = 1

var doingexplode = false

func _on_shoot_timer_timeout() -> void:
	if enabled and get_tree().current_scene.game_started:
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
		
		get_tree().current_scene.get_node("Camera2D").add_trauma(0.7)
		$GPUParticles2D.emitting = true
		get_tree().current_scene.get_node("Camera2D").add_trauma(0.7)
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
