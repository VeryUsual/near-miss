extends Node2D

@export var enemy_scene: PackedScene
var spawn_timer: Timer

@onready var countdowntext_tween := get_tree().create_tween()
var countdowntext_texts := ["3", "2", "1", "GO"]
var countdowntext_index := 0

var game_started = false

func _ready() -> void:
	spawn_timer = Timer.new()
	spawn_timer.wait_time = 0.5
	spawn_timer.one_shot = false
	spawn_timer.autostart = true
	add_child(spawn_timer)
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	
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
