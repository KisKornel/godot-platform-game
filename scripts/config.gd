extends Node

const CONFIG_FILE_PATH = "user://settings.cfg"
var config = ConfigFile.new()

func save_settings() -> void:
	var error = config.save(CONFIG_FILE_PATH)
	if error != OK:
		print("Error saving configuration: ", error)

func load_settings() -> bool:
	var error = Config.config.load(CONFIG_FILE_PATH)
	
	if error != OK:
		return false
	return true
	
