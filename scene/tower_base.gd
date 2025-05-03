extends Sprite2D

@onready var tower_area: Area2D = $Area2D #攻击范围
@onready var tower_area_shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var mouse_detection_area: Area2D = $MouseDetectionArea # 新增：获取鼠标检测区域节点
@onready var range_display = $RangeDisplay # 新增：获取范围显示节点
@export var range = 300 # 攻击范围
@export var fire_rate : float = 1   # 每秒发射子弹数量
@export var base_cost = 50  # 基础建造成本
@export var base_damage = 50  # 基础伤害值
var time_since_last_fire = 0 # 上次发射子弹的时间
var level = 1 # 防御塔等级
var max_level = 4 # 防御塔最大等级
var current_damage = base_damage # 当前伤害值
var isMouseOverButtons = false # 鼠标是否在按钮上

@onready var upgrade_button = $upgrade_button
@onready var destroy_button = $destroy_button
@onready var level_label = $LevelLabel # 新增：获取等级标签节点

# 升级所需金币
func get_upgrade_cost() -> int:
	return base_cost * (level + 1)

# 更新范围显示的辅助函数
func _update_range_display():
	# 假设 circle.png 的基础半径是 64 像素
	var base_radius = 64.0
	# 因为塔本身有缩放，范围显示节点作为子节点也会继承缩放
	# 需要反向应用塔的缩放来获得正确的视觉范围
	# 同时，范围显示节点自身的缩放也需要考虑
	# range 是世界单位，需要转换到 range_display 的本地缩放
	# range_display 的最终世界半径 = range_display.scale.x * base_radius * self.scale.x
	# 我们希望 最终世界半径 = range
	# 所以 range_display.scale.x = range / (base_radius * self.scale.x)
	# 同样适用于 y 轴
	if self.scale.x != 0 and self.scale.y != 0 and base_radius != 0:
		var scale_factor_x = range / (base_radius * self.scale.x)
		var scale_factor_y = range / (base_radius * self.scale.y)
		range_display.scale = Vector2(scale_factor_x, scale_factor_y)
	else:
		# 防止除零错误
		range_display.scale = Vector2.ONE

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
	
	# 添加按钮的鼠标进入和离开事件
	upgrade_button.mouse_entered.connect(_on_buttons_mouse_entered)
	upgrade_button.mouse_exited.connect(_on_buttons_mouse_exited)
	destroy_button.mouse_entered.connect(_on_buttons_mouse_entered)
	destroy_button.mouse_exited.connect(_on_buttons_mouse_exited)
	
	# 连接鼠标检测区域的信号
	mouse_detection_area.input_event.connect(_on_mouse_detection_area_input_event)
	mouse_detection_area.mouse_exited.connect(_on_mouse_exited_tower)
	
	# 初始化等级标签
	level_label.text = "Lv. " + str(level)
	# 初始化范围显示
	_update_range_display()
	# 确保范围显示在塔的下方
	range_display.z_index = z_index-1 
	# 初始隐藏范围显示
	range_display.hide()
	
	tower_area_shape.shape.radius = range


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
				#print(bullet.direction)
				#print(bullet.position)
				time_since_last_fire = 0
				break

func _on_mouse_detection_area_input_event(_viewport, event, _shape_idx):
	if event.is_pressed() and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		# 切换范围显示和按钮的可见性
		if range_display.visible:
			range_display.hide()
			_hide_buttons()
		else:
			range_display.show()
			_show_buttons()

func _on_mouse_exited_tower():
	# 鼠标移出时隐藏范围显示
	range_display.hide()
	# 延迟检查，确保鼠标不是移到了按钮上
	await get_tree().create_timer(0.01).timeout
	_update_buttons_visibility()

func _on_buttons_mouse_entered():
	isMouseOverButtons = true

func _on_buttons_mouse_exited():
	isMouseOverButtons = false
	_update_buttons_visibility()

func _update_buttons_visibility():
	if isMouseOverButtons:
		_show_buttons()
	else:
		_hide_buttons()

func _show_buttons():
	# 更新按钮文本和状态
	if level < max_level:
		upgrade_button.text = "升级 (" + str(get_upgrade_cost()) + " 金币)"
		upgrade_button.disabled = false
	else:
		upgrade_button.text = "已满级"
		upgrade_button.disabled = true
	
	destroy_button.text = "销毁 (+" + str(int(base_cost * level * 0.7)) + " 金币)"
	
	# 显示按钮
	upgrade_button.show()
	destroy_button.show()

func _hide_buttons():
	# 隐藏按钮
	upgrade_button.hide()
	destroy_button.hide()

func _on_upgrade_pressed():
	var BattleScene = get_tree().get_root().get_node("BattleScene")
	# 检查等级和金币
	if level < max_level and BattleScene and BattleScene.coins >= get_upgrade_cost():
		BattleScene.coins -= get_upgrade_cost()
		level += 1 # 升级防御塔
		fire_rate *= 1.3  # 提升攻击速度
		range *= 1.1     # 提升攻击范围
		current_damage *= 1.3  # 提升伤害值
		tower_area_shape.shape.radius = range
		BattleScene.update_coins_display()
		# 更新范围显示
		_update_range_display()
		# 更新按钮文本和状态
		if level < max_level:
			upgrade_button.text = "升级 (" + str(get_upgrade_cost()) + " 金币)"
		else:
			upgrade_button.text = "已满级"
			upgrade_button.disabled = true
		destroy_button.text = "销毁 (+" + str(int(base_cost * level * 0.7)) + " 金币)"
		# 更新等级标签
		level_label.text = "Lv. " + str(level)

func _on_destroy_pressed():
	var BattleScene = get_tree().get_root().get_node("BattleScene")
	if BattleScene:
		BattleScene.coins += int(base_cost * level * 0.7)  # 返还70%建造成本
		BattleScene.update_coins_display()
		# 将建造点标记为未占用
		var build_points = get_tree().get_nodes_in_group("build_points")
		for point in build_points:
			if point.position.distance_to(position) < 32:
				point.set_occupied(false)
				break
		queue_free()  # 销毁防御塔
