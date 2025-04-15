extends CanvasLayer

func _on_confirm_button_pressed():
	get_tree().change_scene_to_file("res://scene/level_select.tscn")
	await get_tree().create_timer(0.5).timeout
	free()
	
