extends CanvasLayer

func _on_confirm_button_pressed():
	get_tree().change_scene_to_file("res://scene/level_select.tscn")
	queue_free()
	#await get_tree().create_timer(0.2).timeout
	#free()
	
