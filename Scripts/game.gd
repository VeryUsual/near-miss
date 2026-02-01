extends Node2D

@export var enemy_scene: PackedScene
var spawn_timer: Timer

@onready var countdowntext_tween := get_tree().create_tween()
var countdowntext_texts := ["3", "2", "1", "GO"]
var countdowntext_index := 0

var game_started = false

var current_normal_timescale = 1.0

func _ready() -> void:
	spawn_timer = Timer.new()
	if Globals.difficulty == "GOD":
		spawn_timer.wait_time = 0.1
	elif Globals.difficulty == "Hard":
		spawn_timer.wait_time = 0.4
	else:
		spawn_timer.wait_time = 0.6
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

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("open_deck"):
		$CanvasLayer/CardDeck.visible = true
		Engine.time_scale = 0.25
	else:
		$CanvasLayer/CardDeck.visible = false
		Engine.time_scale = current_normal_timescale

func _on_card_1_area_2d_mouse_entered() -> void:
	var cardopentween = get_tree().create_tween()
	cardopentween.tween_property($CanvasLayer/CardDeck/Card1Area2D, "position", Vector2(0, -130), 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

func _on_card_1_area_2d_mouse_exited() -> void:
	var cardclosetween = get_tree().create_tween()
	cardclosetween.tween_property($CanvasLayer/CardDeck/Card1Area2D, "position", Vector2.ZERO, 0.06).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

func _on_card_1_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			$CanvasLayer/CardDeck.visible = false
			current_normal_timescale = 0.5
			Engine.time_scale = current_normal_timescale
			await get_tree().create_timer(2.5).timeout
			current_normal_timescale = 1.0
			Engine.time_scale = current_normal_timescale
