extends Control
var skill_tree_screen

func _ready() -> void:
		# 初始化技能树数据
	skill_tree_screen = load("res://scene/skill_tree_screen.tscn").instantiate()
	skill_tree_screen.set_tower_type()
	skill_tree_screen.hide()
	add_child(skill_tree_screen)

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://level/level_select.tscn")
	
func _on_settings_button_pressed():
	# TODO: 实现设置面板
	pass
func _on_skill_tree_button_pressed():
	skill_tree_screen.update_skill_tree()
	skill_tree_screen.show()
	#get_tree().change_scene_to_file("res://scene/skill_tree_screen.tscn")
	
	
func _on_quit_button_pressed():
	get_tree().quit()
