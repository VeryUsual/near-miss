extends CharacterBody2D

@onready var bullet_scene = load("res://Scenes/archer_enemy_bullet.tscn")
@onready var non_lethal_bullet_scene = load("res://Scenes/archer_enemy_bullet_non_lethal.tscn")
@export var enabled = false

var x = 1

func _on_shoot_timer_timeout() -> void:
	if enabled:
		var bullet = non_lethal_bullet_scene.instantiate()
		if x == 4:
			bullet = bullet_scene.instantiate()
			x = 1
		add_child(bullet)
		bullet.global_position = global_position
		x += 1

func _process(delta: float) -> void:
	if enabled:
		visible = true
	else:
		visible = false
