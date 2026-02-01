extends CharacterBody2D

const SPEED = 500
var destination = Vector2.ZERO
var direction

func _ready() -> void:
	destination = get_parent().get_node("Player").global_position
	direction = global_position.direction_to(destination)

func _process(delta):
	position += direction * SPEED * delta
	if global_position.x >= 1152+30 or global_position.x <= -10-30:
		queue_free()
	if global_position.y >= 648+30 or global_position.y <= -10-30:
		queue_free()
