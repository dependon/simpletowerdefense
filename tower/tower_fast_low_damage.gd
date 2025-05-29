extends "res://tower/tower_base.gd"

# 新防御塔：快速攻击，低伤害

func _ready():
	fire_rate = 5.0  # 非常快的攻击速度
	base_cost = 150
	damage = 8  # 低伤害
	upgrade_materials = {
		1: "res://assets/tower/tower_lei/tower_lei_1.png", # 假设等级1的素材
		2: "res://assets/tower/tower_lei/tower_lei_2.png", # 请替换为实际的等级2素材路径
		3: "res://assets/tower/tower_lei/tower_lei_3.png", # 请替换为实际的等级3素材路径
		4: "res://assets/tower/tower_lei/tower_lei_4.png", # 请替换为实际的等级4素材路径
}
	super._ready()

# 重写获取塔类型方法
func get_tower_type() -> String:
	return "tower_fast_low_damage"
