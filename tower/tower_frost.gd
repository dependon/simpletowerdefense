extends "res://tower/tower_base.gd"


# 重写基础属性
func _ready():
	super()
	base_cost = 100  # 冰霜塔基础建造成本
	base_damage = 20  # 基础伤害值较低
	current_damage = base_damage
	fire_rate = 1.0  # 正常攻击速度
	_update_range_display();#刷新范围
	
	UPGRADE_SPRITES = {
		1: "res://assets/tower/tower_ice/tower_ice_1.png", # 假设等级1的素材
		2: "res://assets/tower/tower_ice/tower_ice_2.png", # 请替换为实际的等级2素材路径
		3: "res://assets/tower/tower_ice/tower_ice_3.png", # 请替换为实际的等级3素材路径
		4: "res://assets/tower/tower_ice/tower_ice_4.png", # 请替换为实际的等级4素材路径
	}

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
