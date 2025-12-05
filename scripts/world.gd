extends Node2D

@onready var player: CharacterBody2D = $Player

func _ready() -> void:
	player.position.x = Game.position_x
	player.position.y = Game.position_y

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_APPLICATION_PAUSED:
		print("Exit")
		Utils.save_game()
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		print("Go back")
		Utils.load_game()
