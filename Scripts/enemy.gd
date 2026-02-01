extends CharacterBody2D

const SPEED = 500
var destination = Vector2.ZERO

func _ready() -> void:
	destination = get_parent().get_node("Player").global_position

func _process(delta):
	position += position.direction_to(destination) * SPEED * delta
	if position.distance_to(destination) < 5.0:
		queue_free()
