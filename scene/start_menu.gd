extends Control

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scene/level_select.tscn")

func _on_settings_button_pressed():
	# TODO: 实现设置面板
	pass

func _on_skill_tree_button_pressed():
	get_tree().change_scene_to_file("res://scene/skill_tree.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
