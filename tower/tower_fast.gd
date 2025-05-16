extends "res://tower/tower_base.gd"

# 定义不同等级对应的素材路径
const UPGRADE_SPRITES = {
	1: "res://assets/tower/tower_fast_1.png", # 假设等级1的素材
	2: "res://assets/tower/tower_fast_2.png", # 请替换为实际的等级2素材路径
	3: "res://assets/tower/tower_fast_3.png", # 请替换为实际的等级3素材路径
	4: "res://assets/tower/tower_fast_4.png", # 请替换为实际的等级4素材路径
}

func _ready():
	super()
		# 连接 upgraded 信号
	upgraded.connect(_on_upgraded)
	
	range = 300  
	base_cost = 100  
	base_damage = 50  
	fire_rate = 1.6  # 正常攻击速度
	_update_range_display();#刷新范围
	
# 处理升级信号的函数
func _on_upgraded(new_level):
	print("快速低伤害防御塔已升级到等级: ", new_level)
	_update_sprite(new_level)

# 更新素材的辅助函数
func _update_sprite(current_level):
	if UPGRADE_SPRITES.has(current_level):
		texture = load(UPGRADE_SPRITES[current_level])
	else:
		print("警告: 未找到等级 ", current_level, " 的素材")
