extends "res://scene/tower_base.gd"

func _ready():
	super()
	range = 800  
	base_cost = 200  
	base_damage = 45  
	fire_rate = 1.0  # 正常攻击速度
	# 更新等级标签
	level_label.text = "Lv. " + str(level)
