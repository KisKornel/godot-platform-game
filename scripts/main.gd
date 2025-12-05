extends Node2D

@onready var center_container: CenterContainer = $Actions/CenterContainer
@onready var settings_panel_container: CenterContainer = $Actions/SettingsPanelContainer
@onready var sfx_volume_slider_2: HSlider = $Actions/SettingsPanelContainer/ColorRect/MarginContainer/VBoxContainer/SFXVolumeSlider2
@onready var music_volume_slider: HSlider = $Actions/SettingsPanelContainer/ColorRect/MarginContainer/VBoxContainer/MusicVolumeSlider

const MUSIC_BUS_NAME = "Music"
const SFX_BUS_NAME = "SFX"

var music_bus_index = AudioServer.get_bus_index(MUSIC_BUS_NAME)
var sfx_bus_index = AudioServer.get_bus_index(SFX_BUS_NAME)

func _ready() -> void:
	center_container.visible = true
	settings_panel_container.visible = false
	
	var is_err = Config.load_settings()
	
	if is_err == true:
		var saved_sfx_volume = Config.config.get_value("Audio", "sfx_volume", 80.0)
		var saved_music_volume = Config.config.get_value("Audio", "music_volume", 60.0)
		sfx_volume_slider_2.value = saved_sfx_volume
		music_volume_slider.value = saved_music_volume
		set_db_value(saved_sfx_volume, sfx_bus_index)
		set_db_value(saved_music_volume, music_bus_index)
	else:
		var initial_sfx_volume = sfx_volume_slider_2.value
		var initial_music_volume = music_volume_slider.value
		set_db_value(initial_sfx_volume, sfx_bus_index)
		set_db_value(initial_music_volume, music_bus_index)

	Utils.load_game()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_settings_pressed() -> void:
	center_container.visible = false
	settings_panel_container.visible = true


func _on_back_pressed() -> void:
	center_container.visible = true
	settings_panel_container.visible = false

func _on_sfx_volume_slider_2_value_changed(value: float) -> void:
	set_db_value(value, sfx_bus_index)
	Config.config.set_value("Audio", "sfx_volume", value)
	Config.save_settings()

func _on_music_volume_slider_value_changed(value: float) -> void:
	set_db_value(value, music_bus_index)
	Config.config.set_value("Audio", "music_volume", value)
	Config.save_settings()

func set_db_value(value: float, index: int) -> void:
	var linear_value = value / 100.0
	var db_value = linear_to_db(linear_value)
	AudioServer.set_bus_volume_db(index, db_value)
