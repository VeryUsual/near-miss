extends Node2D

@export var enemy_scene: PackedScene
var spawn_timer: Timer

func _ready() -> void:
	spawn_timer = Timer.new()
	spawn_timer.wait_time = 1.0
	spawn_timer.one_shot = false
	spawn_timer.autostart = true
	add_child(spawn_timer)
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)

func _on_spawn_timer_timeout() -> void:
	var enemy = enemy_scene.instantiate()
	add_child(enemy)
	enemy.position = Vector2(100, 100)
