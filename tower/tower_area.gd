extends "res://tower/tower_base.gd"

func _ready():
	fire_rate = 0.8  # 较慢的射击速度
	base_cost = 120
	damage = 40
	upgrade_materials = {
		1: "res://assets/tower/tower_area/tower_area_1.png", # 假设等级1的素材
		2: "res://assets/tower/tower_area/tower_area_2.png", # 请替换为实际的等级2素材路径
		3: "res://assets/tower/tower_area/tower_area_3.png", # 请替换为实际的等级3素材路径
		4: "res://assets/tower/tower_area/tower_area_4.png", # 请替换为实际的等级4素材路径
	}
	fire_count = 10
	super._ready()

# 重写获取塔类型方法
func get_tower_type() -> String:
	return "tower_area"

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
				bullet.damage = damage
				get_parent().add_child(bullet)
				bullet.position = position
				target_count += 1  # 增加目标计数
		if has_enemy:
			time_since_last_fire = 0
