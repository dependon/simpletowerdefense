extends Control

@onready var skill_tree_container = $Panel/MarginContainer/VBoxContainer/SkillTreeContainer
@onready var unused_stars_label = $Panel/MarginContainer/VBoxContainer/StarInfoContainer/UnusedStarsLabel
@onready var used_stars_label = $Panel/MarginContainer/VBoxContainer/StarInfoContainer/UsedStarsLabel
var tower_data = {}
var tower_type = ""
var all_towers_data = {}

func set_tower_type():
	all_towers_data = load_tower_data()

func load_tower_data():
	# 从 JSON 文件加载技能树数据
	var file = FileAccess.open("res://resources/skill_trees/tower_skills.json", FileAccess.READ)
	var json_string = file.get_as_text()
	file.close()
	var json_data = JSON.parse_string(json_string)
	if json_data != null:
		return json_data
	else:
		return {}

func update_skill_tree():
	# 更新星星数量显示
	var used_stars = 0
	for tower_type in all_towers_data:
		var tower_data = all_towers_data[tower_type]
		for skill_name in tower_data:
			var skill = tower_data[skill_name]
			used_stars += skill["level"]
	var unused_stars = GameManager.stars
	unused_stars_label.text = "未使用星星: " + str(unused_stars)
	used_stars_label.text = "已使用星星: " + str(used_stars)

	# 清空 SkillTreeContainer
	for child in skill_tree_container.get_children():
		child.queue_free()

	# 动态创建所有塔的技能按钮
	for tower_type in all_towers_data:
		var tower_data = all_towers_data[tower_type]

		# 创建塔的 VBoxContainer
		var tower_vbox = VBoxContainer.new()
		tower_vbox.name = tower_type
		tower_vbox.add_theme_constant_override("separation", 5)

		# 创建包含塔的名字和技能按钮的 VBoxContainer
		var tower_container = VBoxContainer.new()
		tower_container.name = tower_type + "_container"
		tower_container.add_theme_constant_override("separation", 5)

		var tower_label = Label.new()
		tower_label.text = tower_type
		tower_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		tower_container.add_child(tower_label)

		for skill_name in tower_data:
			var skill = tower_data[skill_name]
			var button = Button.new()
			button.text = skill["name"] + " Lv." + str(skill["level"])
			button.size = Vector2(50, 50)
			button.custom_minimum_size = Vector2(50, 50)
			var can_upgrade = can_upgrade_skill(tower_type, skill_name)
			button.disabled = not can_upgrade
			if not can_upgrade:
				button.modulate = Color(0.5, 0.5, 0.5)  # 设置为灰色
			button.connect("pressed", func(): upgrade_skill(tower_type, skill_name))
			tower_container.add_child(button)

			if skill["level"] == 4 and skill.has("branch1") and skill.has("branch2"):
				var branch1_button = Button.new()
				branch1_button.text = skill["branch1"]["name"]
				var can_upgrade_branch1 = can_upgrade_branch(tower_type, skill_name, "branch1")
				branch1_button.disabled = not can_upgrade_branch1
				if not can_upgrade_branch1:
					branch1_button.modulate = Color(0.5, 0.5, 0.5)  # 设置为灰色
				branch1_button.connect("pressed", func(): upgrade_branch(tower_type, skill_name, "branch1"))
				tower_container.add_child(branch1_button)

				var branch2_button = Button.new()
				branch2_button.text = skill["branch2"]["name"]
				var can_upgrade_branch2 = can_upgrade_branch(tower_type, skill_name, "branch2")
				branch2_button.disabled = not can_upgrade_branch2
				if not can_upgrade_branch2:
					branch2_button.modulate = Color(0.5, 0.5, 0.5)  # 设置为灰色
				branch2_button.connect("pressed", func(): upgrade_branch(tower_type, skill_name, "branch2"))
				tower_container.add_child(branch2_button)

		skill_tree_container.add_child(tower_container)

func can_upgrade_skill(tower_type, skill_name):
	var tower_data = all_towers_data[tower_type]
	var skill = tower_data[skill_name]
	var cost = skill["cost"]
	var current_stars = GameManager.stars
	if skill["level"] < 4:
		if skill["level"] == 0 and current_stars >= 1:
			return true
		elif skill["level"] == 1 and current_stars >= 2:
			return true
		else:
			return false
	else:
		return false

func can_upgrade_branch(tower_type, skill_name, branch_name):
	var tower_data = all_towers_data[tower_type]
	var skill = tower_data[skill_name]
	var branch = skill[branch_name]
	var cost = branch["cost"]
	var current_stars = GameManager.stars
	return current_stars >= cost

func upgrade_skill(tower_type, skill_name):
	# 升级技能
	var tower_data = all_towers_data[tower_type]
	var skill = tower_data[skill_name]
	var cost = skill["cost"]
	var current_stars = GameManager.stars
	if skill["level"] < 4:
		if skill["level"] == 0 and current_stars >= 1:
			GameManager.stars -= 1
			skill["level"] += 1
			tower_data[skill_name] = skill
			update_skill_tree()
			print("成功升级 " + skill_name)
		elif skill["level"] == 1 and current_stars >= 2:
			GameManager.stars -= 2
			skill["level"] += 1
			tower_data[skill_name] = skill
			update_skill_tree()
			print("成功升级 " + skill_name)
		else:
			print("星星数量不足")
	else:
		print("技能已满级")

func upgrade_branch(tower_type, skill_name, branch_name):
	var tower_data = all_towers_data[tower_type]
	var skill = tower_data[skill_name]
	var branch = skill[branch_name]
	var cost = branch["cost"]
	var current_stars = GameManager.stars
	if current_stars >= cost:
		GameManager.stars -= cost
		# 这里应该应用进阶效果，例如修改塔的属性
		print("成功进阶 " + skill_name + " 的 " + branch_name)
		# 移除其他分支
		if branch_name == "branch1":
			skill.erase("branch2")
		else:
			skill.erase("branch1")
		tower_data[skill_name] = skill
		update_skill_tree()
	else:
		print("星星数量不足")

func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://scene/start_menu.tscn")

func reset_skill_tree():
	# 重置技能树
	for tower_type in all_towers_data:
		var tower_data = all_towers_data[tower_type]
		for skill_name in tower_data:
			var skill = tower_data[skill_name]
			GameManager.stars += skill["level"]
			skill["level"] = 0
			tower_data[skill_name] = skill
	update_skill_tree()
	print("技能树已重置")

func _on_reset_skill_button_pressed():
	reset_skill_tree()
