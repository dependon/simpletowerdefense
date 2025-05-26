extends "res://tower/tower_base.gd"


# 定义不同等级对应的素材路径
const UPGRADE_SPRITES = {
	1: "res://assets/tower/tower_ice/tower_ice_1.png", # 假设等级1的素材
	2: "res://assets/tower/tower_ice/tower_ice_2.png", # 请替换为实际的等级2素材路径
	3: "res://assets/tower/tower_ice/tower_ice_3.png", # 请替换为实际的等级3素材路径
	4: "res://assets/tower/tower_ice/tower_ice_4.png", # 请替换为实际的等级4素材路径
}

# 重写基础属性
func _ready():
	super()
	base_cost = 100  # 冰霜塔基础建造成本
	base_damage = 20  # 基础伤害值较低
	current_damage = base_damage
	fire_rate = 1.0  # 正常攻击速度
	_update_range_display();#刷新范围
	
		# 连接 upgraded 信号
	upgraded.connect(_on_upgraded)

# 重写攻击逻辑，添加减速效果
func _physics_process(delta):
	time_since_last_fire += delta
	if time_since_last_fire >= 1 / fire_rate:
		var enemies = tower_area.get_overlapping_areas()
		for enemy in enemies:
			if enemy.is_in_group("enemies"):
				var bullet_scene = preload("res://bullet/bullet_ice.tscn")
				var bullet = bullet_scene.instantiate()
				bullet.direction = (enemy.global_position - position).normalized()
				bullet.damage = current_damage
				# 设置子弹为冰霜类型，用于在击中时触发减速效果
				bullet.set_meta("type", "frost")
				get_parent().add_child(bullet)
				bullet.position = position
				time_since_last_fire = 0
				break

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
