extends "res://scene/tower_base.gd"

# 重写基础属性
func _ready():
	super()
	base_cost = 100  # 冰霜塔基础建造成本
	base_damage = 20  # 基础伤害值较低
	current_damage = base_damage
	fire_rate = 1.0  # 正常攻击速度
	_update_range_display();#刷新范围

# 重写攻击逻辑，添加减速效果
func _physics_process(delta):
	time_since_last_fire += delta
	if time_since_last_fire >= 1 / fire_rate:
		var enemies = tower_area.get_overlapping_areas()
		for enemy in enemies:
			if enemy.is_in_group("enemies"):
				var bullet_scene = preload("res://scene/bullet.tscn")
				var bullet = bullet_scene.instantiate()
				bullet.direction = (enemy.global_position - position).normalized()
				bullet.damage = current_damage
				# 设置子弹为冰霜类型，用于在击中时触发减速效果
				bullet.set_meta("type", "frost")
				get_parent().add_child(bullet)
				bullet.position = position
				time_since_last_fire = 0
				break
