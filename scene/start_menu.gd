extends Control
var skill_tree_screen
var settings_screen

func _ready() -> void:
	# 设置按钮国际化文本
	_update_ui_texts()
	
	# 连接语言改变信号
	SettingsManager.language_changed.connect(_on_language_changed)
	
	# 初始化技能树数据
	skill_tree_screen = load("res://scene/skill_tree_screen.tscn").instantiate()
	skill_tree_screen.set_tower_type()
	skill_tree_screen.hide()
	add_child(skill_tree_screen)
	
	# 初始化设置界面
	settings_screen = load("res://scene/settings_screen.tscn").instantiate()
	settings_screen.hide()
	add_child(settings_screen)
	
	# 确保背景在VBoxContainer后面
	var background_node = $"Background"
	var vbox_container = $"VBoxContainer"
	if background_node and vbox_container:
		background_node.set_as_top_level(false)
		vbox_container.set_as_top_level(false)
		background_node.z_index = -1
		vbox_container.z_index = 0

func _update_ui_texts():
	"""更新UI文本"""
	$VBoxContainer/StartButton.text = tr("START_GAME")
	$VBoxContainer/SkillTreeButton.text = tr("SKILL_TREE")
	$VBoxContainer/SettingsButton.text = tr("SETTINGS")
	$VBoxContainer/UnlockLevelsButton.text = tr("UNLOCK_ALL_LEVELS")
	$VBoxContainer/HelpButton.text = tr("GAME_HELP")
	$VBoxContainer/AboutButton.text = tr("ABOUT")
	$VBoxContainer/QuitButton.text = tr("EXIT")

func _on_language_changed(_new_language: String):
	"""语言改变时更新UI文本"""
	_update_ui_texts()


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://level/level_select.tscn")
	
func _on_settings_button_pressed():
	# 显示设置界面
	settings_screen.show_settings()

func _on_unlock_levels_button_pressed():
	print("Unlock Levels button pressed")
	var game_manager = get_node("/root/GameManager") # Assuming GameManager is an autoloaded singleton
	if game_manager != null:
		game_manager.unlocked_levels.clear()
		for i in range(1, 12): # Assuming levels are 1 to 10
			game_manager.unlocked_levels.append(i)
			if not i in game_manager.level_stars:
				game_manager.level_stars[i] = 0
		game_manager.save_game()
		print("所有关卡已解锁！")
	pass
	
func _on_skill_tree_button_pressed():
	skill_tree_screen.update_skill_tree()
	skill_tree_screen.show()
	#get_tree().change_scene_to_file("res://scene/skill_tree_screen.tscn")
	
	
func _on_help_button_pressed():
	# 使用GameManager的通用加载屏幕方法切换到帮助界面
	GameManager.change_scene_with_loading("res://scene/help_menu.tscn")

func _on_about_button_pressed():
	# 使用GameManager的通用加载屏幕方法切换到关于界面
	GameManager.change_scene_with_loading("res://scene/about_menu.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
