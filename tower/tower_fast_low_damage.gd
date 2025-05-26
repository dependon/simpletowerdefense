extends "res://tower/tower_base.gd"

# 新防御塔：快速攻击，低伤害

func _ready():
	super()
	# 设置新的基础属性
	fire_rate = fire_rate * 10  # 攻击速度是基础塔的10倍
	base_damage = base_damage / 4 # 基础伤害是基础塔的1/4
	current_damage = base_damage # 更新当前伤害值

	# 可以选择性地修改建造成本
	base_cost = 500 # 例如，设置一个不同的建造成本

	# 更新等级标签
	level_label.text = "Lv. " + str(level)
	_update_range_display();#刷新范围
	
	UPGRADE_SPRITES = {
		1: "res://assets/tower/tower_lei/tower_lei_1.png", # 假设等级1的素材
		2: "res://assets/tower/tower_lei/tower_lei_2.png", # 请替换为实际的等级2素材路径
		3: "res://assets/tower/tower_lei/tower_lei_3.png", # 请替换为实际的等级3素材路径
		4: "res://assets/tower/tower_lei/tower_lei_4.png", # 请替换为实际的等级4素材路径
	}
