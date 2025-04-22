extends Control

@onready var grid_container = $Panel/MarginContainer/VBoxContainer/GridContainer
var tower_data = {}
var tower_type = ""

func set_tower_type(type):
	tower_type = type
	tower_data = load_tower_data(tower_type)
	update_skill_tree()

func load_tower_data(tower_type):
	# 从 JSON 文件加载技能树数据
	var file = FileAccess.open("res://resources/skill_trees/tower_skills.json", FileAccess.READ)
	var json_string = file.get_as_text()
	file.close()
	var json_data = JSON.parse_string(json_string)
	if json_data != null and json_data.has(tower_type):
		return json_data[tower_type]
	else:
		return {}

func update_skill_tree():
	# 清空 GridContainer
	for child in grid_container.get_children():
		child.queue_free()

	# 动态创建技能按钮
	for skill_name in tower_data:
		var skill = tower_data[skill_name]
		var button = Button.new()
		button.text = skill["name"] + " Lv." + str(skill["level"])
		button.connect("pressed", func(): upgrade_skill(skill_name))
		grid_container.add_child(button)
		
		if skill["level"] == 4 and skill.has("branch1") and skill.has("branch2"):
			var branch1_button = Button.new()
			branch1_button.text = skill["branch1"]["name"]
			branch1_button.connect("pressed", func(): upgrade_branch(skill_name, "branch1"))
			grid_container.add_child(branch1_button)
			
			var branch2_button = Button.new()
			branch2_button.text = skill["branch2"]["name"]
			branch2_button.connect("pressed", func(): upgrade_branch(skill_name, "branch2"))
			grid_container.add_child(branch2_button)

func upgrade_skill(skill_name):
	# 升级技能
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

func upgrade_branch(skill_name, branch_name):
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
