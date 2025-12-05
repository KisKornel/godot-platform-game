extends Node

@onready var score_label: Label = $ScoreLabel

func _ready() -> void:
	score_label.text = "Coins: " + str(Game.coins)

func add_point(point: int):
	Game.coins += point
	score_label.text = "Coins: " + str(Game.coins)
