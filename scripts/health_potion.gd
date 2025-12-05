extends Area2D

const health: int = 50

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if body.has_method("health"):
			print("Player is healing")
			body.health(health)
			queue_free()
