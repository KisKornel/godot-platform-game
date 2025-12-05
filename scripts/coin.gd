extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ui: CanvasLayer = %UI
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _process(delta: float) -> void:
	animated_sprite.play("bronze_one_coins")


func _on_body_entered(body: Node2D) -> void:
	ui.add_point(1)
	animation_player.play("pickup")
