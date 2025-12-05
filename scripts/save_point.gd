extends Area2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("Save point")
		Game.position_x = body.global_position.x
		Game.position_y = body.global_position.y
		collision_shape.disabled = true
		Utils.save_game()
