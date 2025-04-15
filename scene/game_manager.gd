extends Node

signal level_selected(level_number: int)

var current_level: int = 0

func select_level(level: int) -> void:
	current_level = level
	level_selected.emit(level)
	get_tree().change_scene_to_file("res://scene/Main.tscn")
