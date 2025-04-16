extends CanvasLayer

func _on_confirm_button_pressed():
	get_tree().paused = false # 取消暂停游戏
	get_tree().change_scene_to_file("res://scene/level_select.tscn")
	queue_free()
