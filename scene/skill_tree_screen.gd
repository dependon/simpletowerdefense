extends Control

# 技能树界面管理器
class_name SkillTreeScreen

# UI节点引用
@onready var background_panel = $BackgroundPanel
@onready var title_label = $BackgroundPanel/MainContainer/TitleContainer/TitleLabel
@onready var star_info_container = $BackgroundPanel/MainContainer/TitleContainer/StarInfoContainer
@onready var unused_stars_label = $BackgroundPanel/MainContainer/TitleContainer/StarInfoContainer/UnusedStarsLabel
@onready var used_stars_label = $BackgroundPanel/MainContainer/TitleContainer/StarInfoContainer/UsedStarsLabel
@onready var tower_tabs_container = $BackgroundPanel/MainContainer/TowerTabsContainer
@onready var skill_tree_container = $BackgroundPanel/MainContainer/SkillTreeContainer
@onready var button_container = $BackgroundPanel/MainContainer/ButtonContainer
@onready var main_menu_button = $BackgroundPanel/MainContainer/ButtonContainer/MainMenuButton
@onready var reset_button = $BackgroundPanel/MainContainer/ButtonContainer/ResetButton

# 数据变量
var all_towers_data = {}
var current_tower_type = "tower_base"
var tower_types = ["tower_base", "tower_fast", "tower_area", "tower_frost", "tower_big_area", "tower_fast_low_damage"]
var tower_display_names = {
	"tower_base": tr("BASIC_TOWER"),
	"tower_fast": tr("FAST_TOWER"),
	"tower_area": tr("AREA_TOWER"),
	"tower_frost": tr("FROST_TOWER"),
	"tower_big_area": tr("BIG_AREA_TOWER"),
	"tower_fast_low_damage": tr("FAST_LOW_DAMAGE_TOWER")
}

# 技能按钮数组，用于管理技能按钮
var skill_buttons = {}
var tower_tab_buttons = {}

func _ready():
	# 设置UI元素国际化文本
	_update_ui_texts()
	
	# 连接语言改变信号
	SettingsManager.language_changed.connect(_on_language_changed)
	
	load_skill_data()
	setup_ui()
	update_display()

func load_skill_data():
	# 首先从JSON文件加载最新的技能树数据
	var file = FileAccess.open("res://resources/skill_trees/tower_skills.json", FileAccess.READ)
	var json_data = {}
	if file:
		var json_string = file.get_as_text()
		file.close()
		var parsed_data = JSON.parse_string(json_string)
		if parsed_data != null:
			json_data = parsed_data
		else:
			print("技能树数据解析失败")
	else:
		print("无法打开技能树数据文件")
	
	# 从GameManager获取已保存的技能数据
	var saved_data = GameManager.get_skill_data()
	
	# 合并数据：保留已升级的技能等级，添加新的技能
	all_towers_data = merge_skill_data(json_data, saved_data)
	
	# 保存合并后的数据到GameManager
	GameManager.save_skill_data(all_towers_data)

func merge_skill_data(json_data: Dictionary, saved_data: Dictionary) -> Dictionary:
	# 以JSON数据为基础，合并保存的技能等级
	var merged_data = json_data.duplicate(true)
	
	for tower_type in merged_data.keys():
		if saved_data.has(tower_type):
			for skill_name in merged_data[tower_type].keys():
				if saved_data[tower_type].has(skill_name):
					# 保留已升级的技能等级
					if saved_data[tower_type][skill_name].has("level"):
						merged_data[tower_type][skill_name]["level"] = saved_data[tower_type][skill_name]["level"]
	
	return merged_data

func setup_ui():
	# 设置UI样式和布局
	setup_tower_tabs()
	setup_skill_tree()
	
	# 连接按钮信号
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	reset_button.pressed.connect(_on_reset_pressed)

func setup_tower_tabs():
	# 创建塔类型选择标签页
	for child in tower_tabs_container.get_children():
		child.queue_free()
	
	for tower_type in tower_types:
		if tower_type in all_towers_data:
			var tab_button = Button.new()
			tab_button.text = tower_display_names.get(tower_type, tower_type)
			tab_button.custom_minimum_size = Vector2(150, 45)
			tab_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
			tab_button.add_theme_font_size_override("font_size", 14)
			tab_button.clip_contents = true
			tab_button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			
			# 设置按钮样式
			if tower_type == current_tower_type:
				tab_button.add_theme_color_override("font_color", Color.YELLOW)
				tab_button.disabled = true
			else:
				tab_button.add_theme_color_override("font_color", Color.WHITE)
			
			tab_button.pressed.connect(_on_tower_tab_pressed.bind(tower_type))
			tower_tabs_container.add_child(tab_button)
			tower_tab_buttons[tower_type] = tab_button

func setup_skill_tree():
	# 清空现有技能树
	for child in skill_tree_container.get_children():
		child.queue_free()
	
	skill_buttons.clear()
	
	if current_tower_type not in all_towers_data:
		# 显示无技能数据的提示
		var no_data_label = Label.new()
		no_data_label.text = tr("NO_SKILL_DATA")
		no_data_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		no_data_label.add_theme_font_size_override("font_size", 18)
		no_data_label.add_theme_color_override("font_color", Color.YELLOW)
		skill_tree_container.add_child(no_data_label)
		return
	
	var tower_data = all_towers_data[current_tower_type]
	
	# 创建技能网格容器
	var grid_container = GridContainer.new()
	grid_container.columns = 2
	grid_container.add_theme_constant_override("h_separation", 30)
	grid_container.add_theme_constant_override("v_separation", 25)
	grid_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	skill_tree_container.add_child(grid_container)
	
	# 为每个技能创建UI
	for skill_name in tower_data:
		var skill_data = tower_data[skill_name]
		create_skill_node(grid_container, skill_name, skill_data)

func create_skill_node(parent: Node, skill_name: String, skill_data: Dictionary):
	# 创建技能节点容器
	var skill_container = VBoxContainer.new()
	skill_container.custom_minimum_size = Vector2(280, 250)
	skill_container.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	skill_container.add_theme_constant_override("separation", 10)
	
	# 创建技能面板
	var skill_panel = Panel.new()
	skill_panel.custom_minimum_size = Vector2(280, 250)
	skill_panel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	# 添加面板样式
	var style_box = StyleBoxFlat.new()
	style_box.bg_color = Color(0.2, 0.3, 0.4, 0.8)
	style_box.border_width_left = 2
	style_box.border_width_right = 2
	style_box.border_width_top = 2
	style_box.border_width_bottom = 2
	style_box.border_color = Color(0.5, 0.7, 0.9, 0.6)
	style_box.corner_radius_top_left = 8
	style_box.corner_radius_top_right = 8
	style_box.corner_radius_bottom_left = 8
	style_box.corner_radius_bottom_right = 8
	skill_panel.add_theme_stylebox_override("panel", style_box)
	skill_container.add_child(skill_panel)
	
	# 创建技能内容容器
	var content_container = VBoxContainer.new()
	content_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	content_container.add_theme_constant_override("separation", 8)
	skill_panel.add_child(content_container)
	
	# 添加边距
	var margin_container = MarginContainer.new()
	margin_container.add_theme_constant_override("margin_left", 12)
	margin_container.add_theme_constant_override("margin_right", 12)
	margin_container.add_theme_constant_override("margin_top", 12)
	margin_container.add_theme_constant_override("margin_bottom", 12)
	content_container.add_child(margin_container)
	
	var inner_container = VBoxContainer.new()
	inner_container.add_theme_constant_override("separation", 8)
	margin_container.add_child(inner_container)
	
	# 技能图标和名称容器
	var header_container = HBoxContainer.new()
	header_container.add_theme_constant_override("separation", 10)
	header_container.custom_minimum_size = Vector2(0, 48)
	inner_container.add_child(header_container)
	
	# 技能图标
	var icon_texture = TextureRect.new()
	icon_texture.custom_minimum_size = Vector2(48, 48)
	icon_texture.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	icon_texture.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	icon_texture.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	icon_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	
	# 加载技能图标
	if skill_data.has("icon") and ResourceLoader.exists(skill_data["icon"]):
		icon_texture.texture = load(skill_data["icon"])
	else:
		# 如果没有图标，使用默认图标
		if ResourceLoader.exists("res://assets/icons/skill_icon.svg"):
			icon_texture.texture = load("res://assets/icons/skill_icon.svg")
	header_container.add_child(icon_texture)
	
	# 技能名称容器，限制宽度
	var name_container = VBoxContainer.new()
	name_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_container.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	header_container.add_child(name_container)
	
	# 技能名称
	var name_label = Label.new()
	var skill_name_key = skill_data.get("name", skill_name)
	name_label.text = tr(skill_name_key) if skill_name_key.begins_with("SKILL_") else skill_name_key
	name_label.add_theme_font_size_override("font_size", 14)
	name_label.add_theme_color_override("font_color", Color.WHITE)
	name_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	name_label.clip_contents = true
	name_label.custom_minimum_size = Vector2(180, 0)
	name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	name_container.add_child(name_label)
	
	# 技能描述容器，固定高度
	var desc_container = Container.new()
	desc_container.custom_minimum_size = Vector2(0, 60)
	desc_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	inner_container.add_child(desc_container)
	
	# 技能描述
	var desc_label = Label.new()
	var skill_desc_key = skill_data.get("description", "")
	desc_label.text = tr(skill_desc_key) if skill_desc_key.begins_with("SKILL_") else skill_desc_key
	desc_label.add_theme_font_size_override("font_size", 11)
	desc_label.add_theme_color_override("font_color", Color.LIGHT_GRAY)
	desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc_label.clip_contents = true
	desc_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	desc_label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	desc_container.add_child(desc_label)
	
	# 技能等级信息容器，固定高度
	var level_info_container = VBoxContainer.new()
	level_info_container.custom_minimum_size = Vector2(0, 70)
	level_info_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	level_info_container.add_theme_constant_override("separation", 8)
	inner_container.add_child(level_info_container)
	
	# 等级显示
	var level_label = Label.new()
	var current_level = skill_data.get("level", 0)
	var max_level = skill_data.get("max_level", 5)
	level_label.text = tr("LEVEL_FORMAT") + ": %d/%d" % [current_level, max_level]
	level_label.add_theme_font_size_override("font_size", 12)
	level_label.add_theme_color_override("font_color", Color.WHITE)
	level_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	level_info_container.add_child(level_label)
	
	# 升级按钮
	var upgrade_button = Button.new()
	var cost = skill_data.get("cost_per_level", 1)
	
	if current_level >= max_level:
		upgrade_button.text = tr("MAX_LEVEL")
		upgrade_button.disabled = true
	else:
		upgrade_button.text = tr("UPGRADE_COST") + " (" + str(cost) + "⭐)"
	
	upgrade_button.custom_minimum_size = Vector2(180, 32)
	upgrade_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	upgrade_button.add_theme_font_size_override("font_size", 11)
	upgrade_button.clip_contents = true
	
	# 检查是否可以升级
	var can_upgrade = can_upgrade_skill(skill_name, skill_data)
	upgrade_button.disabled = not can_upgrade
	
	# 设置按钮样式
	if can_upgrade and current_level < max_level:
		upgrade_button.add_theme_color_override("font_color", Color.WHITE)
		upgrade_button.modulate = Color(1.0, 1.0, 1.0, 1.0)
	else:
		upgrade_button.add_theme_color_override("font_color", Color.GRAY)
		upgrade_button.modulate = Color(0.7, 0.7, 0.7, 0.8)
	
	upgrade_button.pressed.connect(_on_skill_upgrade_pressed.bind(skill_name))
	level_info_container.add_child(upgrade_button)
	
	# 根据技能等级调整面板边框颜色
	var level_progress = float(current_level) / float(skill_data.get("max_level", 5))
	var border_color = Color(0.5, 0.7, 0.9, 0.6).lerp(Color(1.0, 0.8, 0.2, 1.0), level_progress)
	style_box.border_color = border_color
	
	parent.add_child(skill_container)
	
	# 保存按钮引用
	skill_buttons[skill_name] = {
		"container": skill_container,
		"button": upgrade_button,
		"level_label": level_label,
		"panel": skill_panel
	}

func can_upgrade_skill(_skill_name: String, skill_data: Dictionary) -> bool:
	var current_level = skill_data.get("level", 0)
	var max_level = skill_data.get("max_level", 5)
	var cost = skill_data.get("cost_per_level", 1)
	
	if current_level >= max_level:
		return false
	
	var available_stars = GameManager.stars
	if available_stars < cost:
		return false
	
	return true

func update_display():
	# 更新星星显示
	var used_stars = calculate_used_stars()
	unused_stars_label.text = tr("AVAILABLE_STARS") + ": " + str(GameManager.stars)
	used_stars_label.text = tr("USED_STARS") + ": " + str(used_stars)
	
	# 更新塔标签页按钮状态
	for tower_type in tower_tab_buttons:
		var button = tower_tab_buttons[tower_type]
		if tower_type == current_tower_type:
			button.add_theme_color_override("font_color", Color.YELLOW)
			button.disabled = true
		else:
			button.add_theme_color_override("font_color", Color.WHITE)
			button.disabled = false
	
	# 更新技能按钮状态
	if current_tower_type in all_towers_data:
		var tower_data = all_towers_data[current_tower_type]
		for skill_name in skill_buttons:
			if skill_name in tower_data:
				var skill_data = tower_data[skill_name]
				var skill_ui = skill_buttons[skill_name]
				
				# 更新等级显示
				var current_level = skill_data.get("level", 0)
				var max_level = skill_data.get("max_level", 5)
				skill_ui["level_label"].text = tr("LEVEL_FORMAT") + ": %d/%d" % [current_level, max_level]
				
				# 更新按钮状态和文本
				var can_upgrade = can_upgrade_skill(skill_name, skill_data)
				var cost = skill_data.get("cost_per_level", 1)
				
				if current_level >= max_level:
					skill_ui["button"].text = tr("MAX_LEVEL")
					skill_ui["button"].disabled = true
				else:
					skill_ui["button"].text = tr("UPGRADE_COST") + " (" + str(cost) + "⭐)"
					skill_ui["button"].disabled = not can_upgrade
				
				if can_upgrade and current_level < max_level:
					skill_ui["button"].modulate = Color.WHITE
				else:
					skill_ui["button"].modulate = Color(0.6, 0.6, 0.6)
				
				# 更新面板边框颜色
				var level_progress = float(current_level) / float(max_level)
				var border_color = Color(0.5, 0.7, 0.9, 0.6).lerp(Color(1.0, 0.8, 0.2, 1.0), level_progress)
				# 注意：这里需要重新获取StyleBox来更新颜色
				var panel_style = skill_ui["panel"].get_theme_stylebox("panel")
				if panel_style is StyleBoxFlat:
					panel_style.border_color = border_color

func calculate_used_stars() -> int:
	var total_used_stars = 0
	for tower_type in all_towers_data:
		var tower_data = all_towers_data[tower_type]
		for skill_name in tower_data:
			var skill_data = tower_data[skill_name]
			var level = skill_data.get("level", 0)
			var cost_per_level = skill_data.get("cost_per_level", 1)
			total_used_stars += level * cost_per_level
	return total_used_stars

func _on_tower_tab_pressed(tower_type: String):
	current_tower_type = tower_type
	setup_tower_tabs()
	setup_skill_tree()
	update_display()

func _on_skill_upgrade_pressed(skill_name: String):
	if current_tower_type not in all_towers_data:
		return
	
	var tower_data = all_towers_data[current_tower_type]
	if skill_name not in tower_data:
		return
	
	var skill_data = tower_data[skill_name]
	var cost = skill_data.get("cost_per_level", 1)
	
	if can_upgrade_skill(skill_name, skill_data):
		# 扣除星星
		GameManager.stars -= cost
		
		# 升级技能
		skill_data["level"] = skill_data.get("level", 0) + 1
		
		# 应用技能效果到塔属性
		apply_skill_effect(current_tower_type, skill_name, skill_data)
		
		# 保存技能数据到GameManager
		GameManager.save_skill_data(all_towers_data)
		
		# 保存游戏存档
		GameManager.save_game()
		
		# 更新显示
		update_display()
		
		var skill_name_key = skill_data.get("name", skill_name)
		var display_name = tr(skill_name_key)
		print("成功升级技能: ", display_name, " 到等级 ", skill_data["level"])

func apply_skill_effect(tower_type: String, _skill_name: String, skill_data: Dictionary):
	# 这里可以实现技能效果应用到实际塔属性的逻辑
	# 例如通过信号通知塔管理器更新塔的属性
	var effect_type = skill_data.get("effect_type", "")
	var effect_value = skill_data.get("effect_value", 0)
	var level = skill_data.get("level", 0)
	
	# 发送信号给游戏管理器，让其更新对应塔的属性
	GameManager.update_tower_skill_effect(tower_type, effect_type, effect_value * level)

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://scene/start_menu.tscn")

func _on_reset_pressed():
	# 重置所有技能
	var total_refund = 0
	for tower_type in all_towers_data:
		var tower_data = all_towers_data[tower_type]
		for skill_name in tower_data:
			var skill_data = tower_data[skill_name]
			var level = skill_data.get("level", 0)
			var cost_per_level = skill_data.get("cost_per_level", 1)
			total_refund += level * cost_per_level
			skill_data["level"] = 0
	
	# 返还星星
	GameManager.stars += total_refund
	
	# 重置塔的技能效果
	GameManager.reset_all_tower_skills()
	
	# 保存技能数据到GameManager
	GameManager.save_skill_data(all_towers_data)
	
	# 保存游戏存档
	GameManager.save_game()
	
	# 更新显示
	setup_skill_tree()
	update_display()
	
	print("技能树已重置，返还 ", total_refund, " 颗星星")

# 设置塔类型（从外部调用）
func set_tower_type(tower_type: String = ""):
	if tower_type != "" and tower_type in tower_types:
		current_tower_type = tower_type
	load_skill_data()

func _update_ui_texts():
	"""更新UI文本"""
	$BackgroundPanel/MainContainer/TitleContainer/TitleLabel.text = tr("SKILL_TREE_SYSTEM")
	$BackgroundPanel/MainContainer/ButtonContainer/MainMenuButton.text = tr("BACK_TO_MAIN_MENU")
	$BackgroundPanel/MainContainer/ButtonContainer/ResetButton.text = tr("RESET_SKILL_TREE")

func _on_language_changed(_new_language: String):
	"""语言改变时更新UI文本"""
	_update_ui_texts()
	# 重新设置塔标签页和技能树以应用新的翻译
	setup_tower_tabs()
	setup_skill_tree()
	update_display()

func update_skill_tree():
	# 兼容旧接口
	update_display()
