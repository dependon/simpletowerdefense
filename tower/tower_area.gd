extends "res://tower/tower_base.gd"

# 定义不同等级对应的素材路径
const UPGRADE_SPRITES = {
	1: "res://assets/tower/tower_zi/tower_zi_1.png", # 假设等级1的素材
	2: "res://assets/tower/tower_zi/tower_zi_2.png", # 请替换为实际的等级2素材路径
	3: "res://assets/tower/tower_zi/tower_zi_3.png", # 请替换为实际的等级3素材路径
	4: "res://assets/tower/tower_zi/tower_zi_4.png", # 请替换为实际的等级4素材路径
}

# 重写基础属性
func _ready():
	super()
	base_cost = 150  # 群体塔基础建造成本更高
	base_damage = 15  # 基础伤害值较低，因为是群体攻击
	current_damage = base_damage
	fire_rate = 0.8  # 攻击速度较慢
	_update_range_display();#刷新范围
	
			# 连接 upgraded 信号
	upgraded.connect(_on_upgraded)

# 重写攻击逻辑，对范围内所有敌人造成伤害
func _physics_process(delta):
	time_since_last_fire += delta
	if time_since_last_fire >= 1 / fire_rate:
		var enemies = tower_area.get_overlapping_areas()
		var has_enemy = false
		var target_count = 0  # 添加目标计数器
		for enemy in enemies:
			if enemy.is_in_group("enemies"):
				if target_count >= 10:  # 限制最大攻击目标数量
					break
				has_enemy = true
				var bullet_scene = preload("res://bullet/bullet.tscn")
				var bullet = bullet_scene.instantiate()
				bullet.direction = (enemy.global_position - position).normalized()
				bullet.damage = current_damage
				get_parent().add_child(bullet)
				bullet.position = position
				target_count += 1  # 增加目标计数
		if has_enemy:
			time_since_last_fire = 0

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
