extends CharacterBody2D

var SPEED = 400
var destination = Vector2.ZERO
var direction

@onready var ray: RayCast2D = $RayCast2D
@onready var player: Node = get_tree().get_first_node_in_group("Player")

func _ready() -> void:
	if Globals.difficulty == "Easy":
		SPEED = 350
	elif Globals.difficulty == "Hard":
		SPEED = 500
	elif Globals.difficulty == "GOD":
		SPEED = 600
	
	destination = get_parent().get_node("Player").global_position
	direction = global_position.direction_to(destination)
	$RayCast2D.rotation = direction.angle() - PI / 2

func _process(delta):
	position += direction * SPEED * delta
	if global_position.x >= 1152+50 or global_position.x <= -10-50:
		queue_free()
	if global_position.y >= 648+50 or global_position.y <= -10-50:
		queue_free()

func _physics_process(delta: float) -> void:
	if ray.is_colliding():
		var hit = ray.get_collider()
		if hit == player:
			Engine.time_scale = 0.8
			await get_tree().create_timer(0.4).timeout
			if get_tree().current_scene: # race condition prevention stuffs
				if get_tree().current_scene.current_normal_timescale:
					Engine.time_scale = get_tree().current_scene.current_normal_timescale
