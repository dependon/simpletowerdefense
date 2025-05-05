extends "res://scene/tower_base.gd"

# 新防御塔：快速攻击，低伤害

func _ready():
	super()
	# 设置新的基础属性
	fire_rate = fire_rate * 10  # 攻击速度是基础塔的10倍
	base_damage = base_damage / 4 # 基础伤害是基础塔的1/4
	current_damage = base_damage # 更新当前伤害值

	# 可以选择性地修改建造成本
	base_cost = 500 # 例如，设置一个不同的建造成本

	# 更新按钮文本以反映新的成本（如果修改了成本）
	# upgrade_button.text = "升级 (" + str(get_upgrade_cost()) + " 金币)"
	# destroy_button.text = "销毁 (+" + str(int(base_cost * level * 0.7)) + " 金币)"
	
	# 更新等级标签
	level_label.text = "Lv. " + str(level)
	_update_range_display();#刷新范围

# 其他逻辑继承自 tower_base.gd，无需重复编写
