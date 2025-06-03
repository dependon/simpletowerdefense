extends "res://tower/tower_base.gd"


func _ready():
	fire_rate = 2.0  # 快速射击
	base_cost = 100
	damage = 50
	upgrade_materials = {
		1: "res://assets/tower/tower_fast/tower_fast_1.png", # 假设等级1的素材
		2: "res://assets/tower/tower_fast/tower_fast_2.png", # 请替换为实际的等级2素材路径
		3: "res://assets/tower/tower_fast/tower_fast_3.png", # 请替换为实际的等级3素材路径
		4: "res://assets/tower/tower_fast/tower_fast_4.png", # 请替换为实际的等级4素材路径
	}
	super._ready()

# 重写获取塔类型方法
func get_tower_type() -> String:
	return "tower_fast"
