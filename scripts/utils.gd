extends Node

var SAVE_PATH = "res://savegame.bin"

func save_game() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data: Dictionary = {
		"playerHP": Game.playerHP,
		"coins": Game.coins,
		"position_x": Game.position_x,
		"position_y": Game.position_y
	}
	var jstr = JSON.stringify(data)
	file.store_line(jstr)

func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
		
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file.eof_reached():
		var current_line = JSON.parse_string(file.get_line())
		if current_line:
			Game.playerHP = current_line["playerHP"]
			Game.coins = current_line["coins"]
			Game.position_x = current_line["position_x"]
			Game.position_y = current_line["position_y"]

func reset_save_point() -> void:
	Game.playerHP = Game.PLAYER_HEALTH
	Game.coins = max(Game.coins - 10, Game.COINS)
	save_game()

func reset() -> void:
	Game.playerHP = Game.PLAYER_HEALTH
	Game.coins = Game.COINS
	Game.position_x = Game.POSITION_X
	Game.position_y = Game.POSITION_Y
	save_game()
