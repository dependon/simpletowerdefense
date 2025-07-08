extends CanvasLayer

func _ready():
	# 设置UI元素国际化文本
	$CenterContainer/VBoxContainer/Label.text = tr("VICTORY")
	$CenterContainer/VBoxContainer/ConfirmButton.text = tr("CONFIRM")
	
	# 获取当前关卡和基地血量
	var current_level = GameManager.current_level
	var base = get_tree().get_nodes_in_group("base")[0]
	var base_health = base.current_health
	
	# 设置关卡星级
	GameManager.set_level_stars(current_level, base_health)

func _on_confirm_button_pressed():
	# 解锁下一关卡
	GameManager.unlock_next_level()
	
	# 返回关卡选择界面
	get_tree().change_scene_to_file("res://level/level_select.tscn")
	
	#保存游戏进度到本地
	GameManager.save_game()
	queue_free()
	#await get_tree().create_timer(0.2).timeout
	#free()
	
