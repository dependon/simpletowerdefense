extends Control

func _on_level1_button_pressed():
	GameManager.select_level(1)

func _on_level2_button_pressed():
	GameManager.select_level(2)


func _on_level_3_button_pressed() -> void:
	GameManager.select_level(3)
	pass # Replace with function body.
