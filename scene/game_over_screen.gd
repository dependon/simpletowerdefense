extends CanvasLayer

func _on_confirm_button_pressed():
	get_tree().paused = false # 取消暂停游戏
	
	# 使用GameManager的通用加载屏幕方法切换到关卡选择界面
	GameManager.change_scene_with_loading("res://level/level_select.tscn")
	
	queue_free()
