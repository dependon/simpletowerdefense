extends Control

# 防御塔信息数据
var tower_data = {
	"tower_base": {
		"name": "基础塔",
		"description": "射击速度缓慢的防御塔，适合对付大量弱小敌人",
		"fire_rate": 1.0,
		"damage": 50,
		"cost": 50,
		"range": 200,
		"icon": "res://assets/tower/tower_base/tower_base_1.png",
		"special": "低价格,低射速,低伤害"
	},
	"tower_fast": {
		"name": "快速塔",
		"description": "射击速度极快的防御塔，适合对付大量弱小敌人",
		"fire_rate": 2.0,
		"damage": 50,
		"cost": 100,
		"range": 300,
		"icon": "res://assets/tower/tower_fast/tower_fast_1.png",
		"special": "高射速,低伤害"
	},
	"tower_frost": {
		"name": "冰霜塔",
		"description": "发射冰霜子弹，能够减缓敌人移动速度",
		"fire_rate": 1.0,
		"damage": 15,
		"cost": 100,
		"range": 300,
		"icon": "res://assets/tower/tower_frost/tower_frost_1.png",
		"special": "减速效果，冰冻敌人"
	},
	"tower_area": {
		"name": "群攻塔",
		"description": "能够同时攻击多个敌人的攻击塔",
		"fire_rate": 0.8,
		"damage": 20,
		"cost": 200,
		"range": 300,
		"icon": "res://assets/tower/tower_area/tower_area_1.png",
		"special": "群体攻击，最多攻击10个目标"
	},
	"tower_big_area": {
		"name": "大范围塔",
		"description": "拥有超大攻击范围的防御塔",
		"fire_rate": 1.0,
		"damage": 40,
		"cost": 200,
		"range": 800,
		"icon": "res://assets/tower/tower_zi/tower_zi_1.png",
		"special": "超大攻击范围"
	},
	"tower_fast_low_damage": {
		"name": "超快速伤害塔",
		"description": "拥有急速的射击速度和略低伤害的防御塔，造价高昂",
		"fire_rate": 5.0,
		"damage": 20,
		"cost": 500,
		"range": 300,
		"icon": "res://assets/tower/tower_fast_low_damage/tower_fast_low_damage_1.png",
		"special": "超快攻击速度,低伤害,高造价"
	}
	
}

func _ready():
	create_tower_info_cards()

# 创建防御塔信息卡片
func create_tower_info_cards():
	var towers_container = $MainContainer/ScrollContainer/ContentContainer/TowersSection/TowersContainer
	
	for tower_key in tower_data.keys():
		var tower_info = tower_data[tower_key]
		
		# 创建每个防御塔的容器
		var tower_card = HBoxContainer.new()
		tower_card.custom_minimum_size = Vector2(0, 120)
		towers_container.add_child(tower_card)
		
		# 创建图标容器
		var icon_container = VBoxContainer.new()
		icon_container.custom_minimum_size = Vector2(100, 0)
		tower_card.add_child(icon_container)
		
		# 创建防御塔图标
		var icon = TextureRect.new()
		icon.custom_minimum_size = Vector2(80, 80)
		icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		
		# 尝试加载图标
		if ResourceLoader.exists(tower_info.icon):
			var texture = load(tower_info.icon)
			if texture:
				icon.texture = texture
		else:
			# 如果图标不存在，创建一个占位符
			var placeholder = ColorRect.new()
			placeholder.color = Color.GRAY
			placeholder.custom_minimum_size = Vector2(80, 80)
			icon_container.add_child(placeholder)
			var placeholder_label = Label.new()
			placeholder_label.text = "图标\n缺失"
			placeholder_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			placeholder_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			placeholder.add_child(placeholder_label)
			continue
		
		icon_container.add_child(icon)
		
		# 创建信息容器
		var info_container = VBoxContainer.new()
		info_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		tower_card.add_child(info_container)
		
		# 防御塔名称
		var name_label = Label.new()
		name_label.text = tower_info.name
		name_label.add_theme_font_size_override("font_size", 20)
		name_label.add_theme_color_override("font_color", Color.YELLOW)
		info_container.add_child(name_label)
		
		# 防御塔描述
		var desc_label = RichTextLabel.new()
		desc_label.custom_minimum_size = Vector2(0, 30)
		desc_label.bbcode_enabled = true
		desc_label.text = tower_info.description
		desc_label.fit_content = true
		info_container.add_child(desc_label)
		
		# 属性信息
		var stats_label = RichTextLabel.new()
		stats_label.custom_minimum_size = Vector2(0, 60)
		stats_label.bbcode_enabled = true
		stats_label.text = "[b]属性：[/b]\n" + \
			"• 伤害：%d  • 射速：%.1f/秒\n" % [tower_info.damage, tower_info.fire_rate] + \
			"• 造价：%d  • 射程：%d\n" % [tower_info.cost, tower_info.range] + \
			"• 特殊：%s" % tower_info.special
		stats_label.fit_content = true
		info_container.add_child(stats_label)
		
		# 添加分隔线
		if tower_key != tower_data.keys()[-1]:  # 不是最后一个
			var separator = HSeparator.new()
			towers_container.add_child(separator)

# 返回主菜单按钮处理
func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scene/start_menu.tscn")
