extends Control

# 技能树数据
var skill_data = {}
# 当前选中的防御塔
var current_tower = "tower_1"
# 技能节点缓存
var skill_nodes = {}
# 星星数量
var available_stars = 0

# 节点样式常量
const DIAMOND_SIZE = Vector2(60, 60)
const LEVEL_SPACING = Vector2(150, 100)
const BRANCH_SPACING = Vector2(0, 80)
const NORMAL_COLOR = Color(0.3, 0.3, 0.3)
const UNLOCKED_COLOR = Color(0.2, 0.6, 0.2)
const AVAILABLE_COLOR = Color(0.6, 0.6, 0.2)

func _ready():
	# 加载技能树数据
	var file = FileAccess.open("res://resources/skill_trees/tower_skills.json", FileAccess.READ)
	if file:
		var json = JSON.new()
		var parse_result = json.parse(file.get_as_text())
		if parse_result == OK:
			skill_data = json.get_data()
		file.close()
	
	# 初始化技能树显示
	_create_skill_tree()

# 创建技能树
func _create_skill_tree():
	var tower = skill_data[current_tower]
	if not tower:
		return
	
	for skill_name in tower.skills:
		var skill = tower.skills[skill_name]
		var start_pos = Vector2(300, 150) # 起始位置
		
		# 创建技能分支
		for i in range(skill.levels.size()):
			var level = skill.levels[i]
			var node_pos = start_pos + Vector2(i * LEVEL_SPACING.x, 0)
			
			# 创建技能节点
			var node = _create_skill_node(skill_name, level, node_pos)
			skill_nodes[skill_name + str(level.level)] = node
			
			# 如果是4级技能，创建分支
			if level.level == 4 and level.has("branches"):
				for j in range(level.branches.size()):
					var branch = level.branches[j]
					var branch_pos = node_pos + Vector2(LEVEL_SPACING.x, (j - 0.5) * BRANCH_SPACING.y)
					_create_skill_node(skill_name, branch, branch_pos, true)
		
		start_pos.y += LEVEL_SPACING.y

# 创建技能节点
func _create_skill_node(skill_name, level_data, position, is_branch = false):
	var node = Control.new()
	node.set_position(position - DIAMOND_SIZE / 2)
	node.custom_minimum_size = DIAMOND_SIZE
	$SkillContainer.add_child(node)
	
	# 添加点击检测
	var button = Button.new()
	button.flat = true
	button.size = DIAMOND_SIZE
	button.modulate = Color(1, 1, 1, 0) # 透明按钮
	node.add_child(button)
	
	# 添加技能描述
	var tooltip = level_data.description
	if not is_branch:
		tooltip += "\n需要星星: " + str(level_data.stars_required)
	button.tooltip_text = tooltip
	
	# 连接信号
	button.pressed.connect(_on_skill_pressed.bind(skill_name, level_data))
	
	return node

# 绘制技能节点
func _draw():
	for skill_name in skill_data[current_tower].skills:
		var skill = skill_data[current_tower].skills[skill_name]
		var prev_node = null
		
		for i in range(skill.levels.size()):
			var current_node = skill_nodes[skill_name + str(i + 1)]
			if current_node:
				# 绘制连线
				if prev_node:
					draw_line(
						prev_node.position + DIAMOND_SIZE / 2,
						current_node.position + DIAMOND_SIZE / 2,
						Color(0.5, 0.5, 0.5),
						2
					)
				
				# 绘制菱形
				var points = [
					Vector2(DIAMOND_SIZE.x / 2, 0),
					Vector2(DIAMOND_SIZE.x, DIAMOND_SIZE.y / 2),
					Vector2(DIAMOND_SIZE.x / 2, DIAMOND_SIZE.y),
					Vector2(0, DIAMOND_SIZE.y / 2)
				]
				
				var color = NORMAL_COLOR
				# TODO: 根据解锁状态设置颜色
				
				draw_colored_polygon(points, color)
				
				prev_node = current_node

# 技能点击处理
func _on_skill_pressed(skill_name, level_data):
	# TODO: 实现技能解锁逻辑
	pass

# 返回按钮处理
func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scene/start_menu.tscn")