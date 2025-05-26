extends "res://tower/tower_base.gd"

func _ready():
	super()
	range = 800  
	base_cost = 200  
	base_damage = 45  
	fire_rate = 1.0  # 正常攻击速度
	_update_range_display();#刷新范围
	
	UPGRADE_SPRITES = {
		1: "res://assets/tower/tower_zi/tower_zi_1.png", # 假设等级1的素材
		2: "res://assets/tower/tower_zi/tower_zi_2.png", # 请替换为实际的等级2素材路径
		3: "res://assets/tower/tower_zi/tower_zi_3.png", # 请替换为实际的等级3素材路径
		4: "res://assets/tower/tower_zi/tower_zi_4.png", # 请替换为实际的等级4素材路径
	}
	
