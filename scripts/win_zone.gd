extends Area2D

@onready var win_screen: CanvasLayer = $"../WinScreen"

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and Game.coins >= Game.WIN_POINTS:
		win_game()
	else:
		Utils.reset()

func win_game():
	print("You win!")
	get_tree().paused = true
	
	if win_screen:
		win_screen.visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
