extends CharacterBody2D

var SPEED = 400
var destination = Vector2.ZERO
var direction

@onready var player: Node = get_tree().get_first_node_in_group("Player")

func _ready() -> void:
	if Globals.difficulty == "Easy":
		SPEED = 280
	elif Globals.difficulty == "Hard":
		SPEED = 500
	elif Globals.difficulty == "GOD":
		SPEED = 600
	
	destination = player.global_position
	direction = global_position.direction_to(destination)

func _process(delta):
	position += direction * SPEED * delta
	if global_position.x >= 1152+50 or global_position.x <= -10-50:
		queue_free()
	if global_position.y >= 648+50 or global_position.y <= -10-50:
		queue_free()
