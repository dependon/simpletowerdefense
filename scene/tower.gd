extends Sprite2D

@onready var tower_area: Area2D = $Area2D
@export var range = 200 # 攻击范围
@export var fire_rate : float = 1   # 每秒发射子弹数量
@export var base_cost = 50  # 基础建造成本
@export var base_damage = 50  # 基础伤害值
var time_since_last_fire = 0 # 上次发射子弹的时间
var level = 1 # 防御塔等级
var current_damage = base_damage # 当前伤害值

@onready var upgrade_button = $upgrade_button
@onready var destroy_button = $destroy_button

# 升级所需金币
func get_upgrade_cost() -> int:
	return base_cost * (level + 1)

func _ready():
	z_index = 3
	# 创建升级按钮
	upgrade_button.text = "升级 (" + str(get_upgrade_cost()) + " 金币)"
	upgrade_button.pressed.connect(_on_upgrade_pressed)
	upgrade_button.hide()
	
	# 创建销毁按钮
	destroy_button.text = "销毁 (+" + str(int(base_cost * level * 0.7)) + " 金币)"
	destroy_button.pressed.connect(_on_destroy_pressed)
	destroy_button.hide()
	
	# 添加鼠标进入和离开事件
	tower_area.mouse_entered.connect(_on_tower_mouse_entered)
	tower_area.mouse_exited.connect(_on_tower_mouse_exited)

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
				get_parent().add_child(bullet)
				bullet.position = position
				time_since_last_fire = 0
				break

func _on_tower_mouse_entered():
	# 更新按钮文本
	upgrade_button.text = "升级 (" + str(get_upgrade_cost()) + " 金币)"
	destroy_button.text = "销毁 (+" + str(int(base_cost * level * 0.7)) + " 金币)"
	# 显示按钮
	upgrade_button.show()
	destroy_button.show()

func _on_tower_mouse_exited():
	# 隐藏按钮
	upgrade_button.hide()
	destroy_button.hide()

func _on_upgrade_pressed():
	var main = get_tree().get_root().get_node("Main")
	if main and main.coins >= get_upgrade_cost():
		main.coins -= get_upgrade_cost()
		level += 1 # 升级防御塔
		fire_rate *= 1.3  # 提升攻击速度
		range *= 1.1     # 提升攻击范围
		current_damage *= 1.3  # 提升伤害值
		tower_area.get_node("CollisionShape2D").shape.radius = range
		main.update_coins_display()
		# 更新按钮文本
		upgrade_button.text = "升级 (" + str(get_upgrade_cost()) + " 金币)"
		destroy_button.text = "销毁 (+" + str(int(base_cost * level * 0.7)) + " 金币)"

func _on_destroy_pressed():
	var main = get_tree().get_root().get_node("Main")
	if main:
		main.coins += int(base_cost * level * 0.7)  # 返还70%建造成本
		main.update_coins_display()
		# 将建造点标记为未占用
		var build_points = get_tree().get_nodes_in_group("build_points")
		for point in build_points:
			if point.position.distance_to(position) < 32:
				point.set_occupied(false)
				break
		queue_free()  # 销毁防御塔
