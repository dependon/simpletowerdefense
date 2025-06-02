extends Control
var skill_tree_screen
var settings_screen

func _ready() -> void:
	# 初始化技能树数据
	skill_tree_screen = load("res://scene/skill_tree_screen.tscn").instantiate()
	skill_tree_screen.set_tower_type()
	skill_tree_screen.hide()
	add_child(skill_tree_screen)
	
	# 初始化设置界面
	settings_screen = load("res://scene/settings_screen.tscn").instantiate()
	settings_screen.hide()
	add_child(settings_screen)

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
	get_tree().change_scene_to_file("res://scene/help_menu.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
