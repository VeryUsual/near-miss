extends Node2D

var coinlabel

func _ready() -> void:
	coinlabel = get_tree().current_scene.get_node("CanvasLayer/CoinLabel")

func _on_pickup_range_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		Globals.coins += 1
		var tween = get_tree().create_tween()
		tween.tween_property(self, "global_position", get_viewport().get_canvas_transform().affine_inverse() * Vector2(25, 15), 0.25).set_ease(Tween.EASE_IN)
		tween.chain().tween_property(self, "visible", false, 0.0)
		tween.chain().tween_property(coinlabel, "scale", Vector2(1.1,1.1), 0.05)
		tween.chain().tween_property(coinlabel, "text", "Coins: " + str(Globals.coins), 0.0)
		tween.chain().tween_property(coinlabel, "scale", Vector2(1.0,1.0), 0.05)
		tween.chain().tween_callback(queue_free)
