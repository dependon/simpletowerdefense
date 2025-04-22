extends Control

signal resume_game
signal return_to_level_select
signal return_to_start_menu

func _on_resume_button_pressed():
	resume_game.emit()


func _on_level_select_button_pressed():
	return_to_level_select.emit()


func _on_start_menu_button_pressed():
	return_to_start_menu.emit()
