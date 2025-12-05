extends CanvasLayer

func _ready() -> void:
	visible = false


func _on_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main.tscn")
