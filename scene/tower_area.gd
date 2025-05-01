extends "res://scene/tower_base.gd"

# 重写基础属性
func _ready():
	super()
	base_cost = 150  # 群体塔基础建造成本更高
	base_damage = 15  # 基础伤害值较低，因为是群体攻击
	current_damage = base_damage
	fire_rate = 0.8  # 攻击速度较慢

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
				var bullet_scene = preload("res://scene/bullet.tscn")
				var bullet = bullet_scene.instantiate()
				bullet.direction = (enemy.global_position - position).normalized()
				bullet.damage = current_damage
				get_parent().add_child(bullet)
				bullet.position = position
				target_count += 1  # 增加目标计数
		if has_enemy:
			time_since_last_fire = 0
