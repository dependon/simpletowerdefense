extends Control

signal resume_game
signal return_to_level_select
signal return_to_start_menu
signal restart_level

var settings_screen 

func _ready() -> void:
			# 初始化设置界面
	settings_screen = load("res://scene/settings_screen.tscn").instantiate()
	settings_screen.hide()
	add_child(settings_screen)
	
func _on_resume_button_pressed():
	resume_game.emit()


func _on_level_select_button_pressed():
	return_to_level_select.emit()


func _on_start_menu_button_pressed():
	return_to_start_menu.emit()

func _on_restart_level_button_pressed():
	# 获取 GameManager 节点
	var game_manager = get_node("/root/GameManager")
	if game_manager != null:
		# 重新选择当前关卡以重新加载场景
		game_manager.select_level(game_manager.current_level)
	# 重新开始关卡后，可能需要隐藏设置菜单
	hide()


func _on_main_menu_settings_button_pressed() -> void:
	"""跳转到主菜单设置界面"""
	settings_screen.show_settings()
