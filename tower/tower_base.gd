extends Sprite2D

signal upgraded(level) # 升级信号，传递当前等级
signal tower_clicked(tower_instance) # 新增：防御塔被点击信号，传递自身实例

@onready var tower_area: Area2D = $Area2D #攻击范围
@onready var tower_area_shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var mouse_detection_area: Area2D = $MouseDetectionArea # 获取鼠标检测区域节点
@onready var range_display = $RangeDisplay # 获取范围显示节点
@onready var attack_audio: AudioStreamPlayer2D = $AttackAudio # 攻击音效播放器
@export var attack_range = 300 # 攻击范围
@export var fire_rate : float = 1   # 每秒发射子弹数量
@export var bullet_count : int = 1   # 每次发射子弹个数
@export var base_cost = 50  # 基础建造成本
@export var damage = 50  # 伤害值
@export var freeze_duration = 5.0 #减速时间
@export var slow_multiplier = 2.0 #减速倍率
@export var critical_chance = 0.01 #暴击概率
@export var critical_ratio = 1.5 #暴击伤害倍率
@export var penetration_count = 1 #子弹碰撞敌人消失次数(用于配置允许穿透敌人个数)
@export var chain_reaction = 0.00 #概率发送两发子弹，连锁反应

@export var burn_damage = 0.0 #燃烧效果，燃烧的伤害(具体逻辑暂时未实现)
@export var nova_chance = 0.0 #冰霜新星，释放冰霜新星冰冻周围敌人(具体逻辑暂时未实现)
@export var shield_strength  = 0.0 #霜甲护盾，为附近友军提供护盾(具体逻辑暂时未实现)
@export var earthquake_chance = 0.0 #地震冲击，攻击造成地震效果(具体逻辑暂时未实现)
@export var armor_pierce = 0.0 #破甲攻击,无视敌人部分护甲(具体逻辑暂时未实现)

var time_since_last_fire = 0 # 上次发射子弹的时间
var level = 1 # 防御塔等级
var max_level = 4 # 防御塔最大等级
var isMouseOverButtons = false # 鼠标是否在按钮上

@onready var upgrade_button = $upgrade_button
@onready var destroy_button = $destroy_button
@onready var level_label = $LevelLabel # 获取等级标签节点

# 升级素材路径数组
var upgrade_materials = {
	1: "res://assets/tower/tower_base/tower_base_1.png", # 假设等级1的素材
	2: "res://assets/tower/tower_base/tower_base_2.png", # 请替换为实际的等级2素材路径
	3: "res://assets/tower/tower_base/tower_base_3.png", # 请替换为实际的等级3素材路径
	4: "res://assets/tower/tower_base/tower_base_4.png", # 请替换为实际的等级4素材路径
}

# 升级所需金币
func get_upgrade_cost() -> int:
	return base_cost * (level + 1)

# 更新范围显示的辅助函数
func _update_range_display():
	tower_area_shape.shape.radius = attack_range
	# 假设 circle.png 的基础半径是 64 像素
	var base_radius = 128.0
	# 因为塔本身有缩放，范围显示节点作为子节点也会继承缩放
	# 需要反向应用塔的缩放来获得正确的视觉范围
	# 同时，范围显示节点自身的缩放也需要考虑
	# attack_range 是世界单位，需要转换到 range_display 的本地缩放
	# range_display 的最终世界半径 = range_display.scale.x * base_radius * self.scale.x
	# 我们希望 最终世界半径 = attack_range
	# 所以 range_display.scale.x = attack_range / (base_radius * self.scale.x)
	# 同样适用于 y 轴
	if self.scale.x != 0 and self.scale.y != 0 and base_radius != 0:
		var scale_factor_x = attack_range / (base_radius * self.scale.x)
		var scale_factor_y = attack_range / (base_radius * self.scale.y)
		range_display.scale = Vector2(scale_factor_x, scale_factor_y)
	else:
		# 防止除零错误
		range_display.scale = Vector2.ONE

func _ready():
	z_index = 3
	
	# 初始化攻击音效
	if not attack_audio:
		attack_audio = AudioStreamPlayer2D.new()
		add_child(attack_audio)
	attack_audio.stream = preload("res://assets/music/attack.wav")
	attack_audio.volume_db = -10.0  # 降低音量避免太突兀
	attack_audio.pitch_scale = 1.0
	
	# 应用技能效果到塔的属性
	apply_skill_effects()
	
	# 创建升级按钮
	upgrade_button.text = tr("UPGRADE") + " (" + str(get_upgrade_cost()) + " " + tr("COINS") + ")"
	upgrade_button.pressed.connect(_on_upgrade_pressed)
	upgrade_button.hide()
	
	# 创建销毁按钮
	destroy_button.text = tr("DESTROY") + " (+" + str(int(base_cost * level * 0.7)) + " " + tr("COINS") + ")"
	destroy_button.pressed.connect(_on_destroy_pressed)
	destroy_button.hide()
	
	# 添加按钮的鼠标进入和离开事件
	upgrade_button.mouse_entered.connect(_on_buttons_mouse_entered)
	upgrade_button.mouse_exited.connect(_on_buttons_mouse_exited)
	destroy_button.mouse_entered.connect(_on_buttons_mouse_entered)
	destroy_button.mouse_exited.connect(_on_buttons_mouse_exited)
	
	# 连接鼠标检测区域的信号
	mouse_detection_area.input_event.connect(_on_mouse_detection_area_input_event)
	# 连接鼠标离开检测区域的信号
	mouse_detection_area.mouse_exited.connect(_on_mouse_exited_detection_area) 
	
	# 初始化等级标签
	level_label.text = "Lv. " + str(level)
	# 初始化范围显示
	_update_range_display()
	# 确保范围显示在塔的下方
	range_display.z_index = z_index-1 
	# 初始隐藏范围显示
	range_display.hide()
	
	# 新增：将自身添加到 "towers" 组，确保在 BattleScene 中可以获取到
	add_to_group("towers")
	
			# 连接 upgraded 信号
	upgraded.connect(_on_upgraded)


func _physics_process(delta):
	time_since_last_fire += delta
	if time_since_last_fire >= 1 / fire_rate:
		var enemies = tower_area.get_overlapping_areas()
		var target_count = 0  # 添加目标计数器
		var has_fired = false  # 标记是否已经发射过子弹
		for enemy in enemies:
			if enemy.is_in_group("enemies"):
				# 第一次发射时播放攻击音效
				if not has_fired and attack_audio:
					# 添加轻微的音调随机化，避免音效太单调
					attack_audio.pitch_scale = randf_range(0.9, 1.1)
					# 添加轻微的音量随机化
					attack_audio.volume_db = randf_range(-12.0, -8.0)
					attack_audio.play()
					has_fired = true
				
				var isChain :int = 1 #是否触发连锁反应
				# 判断是否暴击
				if randf() < chain_reaction :
					isChain = 2
				target_count+=1
				for i in range(isChain):  # 循环两次，i的值为0和1
					var bullet_scene
					var bullet
					if get_tower_type() == "tower_frost":				
						bullet_scene = preload("res://bullet/bullet_ice.tscn")
						bullet = bullet_scene.instantiate()
						bullet.set_meta("type", "frost")
					if get_tower_type() == "tower_area":
						bullet_scene = preload("res://bullet/bullet.tscn")
						bullet = bullet_scene.instantiate()
					else:
						bullet_scene = preload("res://bullet/bullet.tscn")
						bullet = bullet_scene.instantiate()
					bullet.direction = (enemy.global_position - position).normalized()
					bullet.damage = damage
					bullet.freeze_duration = freeze_duration #减速时间
					bullet.slow_multiplier = slow_multiplier #减速倍率
					bullet.critical_chance = critical_chance #暴击概率
					bullet.critical_ratio = critical_ratio #暴击伤害倍率
					bullet.penetration_count = penetration_count#子弹碰撞敌人消失次数(用于配置允许穿透敌人个数)						
					get_parent().add_child(bullet)
					bullet.position = position
					time_since_last_fire = 0
				#如果发射子弹数大于或者等于最大子弹数
				if target_count >= bullet_count:	
					break

func _on_mouse_detection_area_input_event(_viewport, event, _shape_idx):
	# 只有在 BattleScene 中没有选中防御塔类型时，才允许选中场上已有的防御塔
	var BattleScene = get_tree().get_root().get_node("BattleScene")
	if BattleScene and BattleScene.current_tower_type == "":
		if event.is_pressed() and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			# 鼠标左键点击时，发出信号通知 BattleScene
			emit_signal("tower_clicked", self)

func _on_mouse_exited_detection_area():
	# 鼠标离开防御塔检测区域时，如果鼠标不在按钮上，则隐藏范围显示和按钮
	# 延迟检查，确保鼠标不是移到了按钮上
	await get_tree().create_timer(0.01).timeout
	if not isMouseOverButtons:
		var BattleScene = get_tree().get_root().get_node("BattleScene")
		if BattleScene and BattleScene.get_selected_tower() == self:
			set_selected(false)

func _on_buttons_mouse_entered():
	isMouseOverButtons = true

func _on_buttons_mouse_exited():
	isMouseOverButtons = false
	# 鼠标离开按钮时，如果防御塔未被选中，则隐藏按钮和范围显示
	# 这里不再调用 _update_buttons_visibility，而是依赖 set_selected 来统一管理
	var BattleScene = get_tree().get_root().get_node("BattleScene")
	if BattleScene and BattleScene.get_selected_tower() != self:
		set_selected(false)

# 新增：设置防御塔选中状态的公共函数
func set_selected(is_selected: bool):
	if is_selected:
		range_display.show()
		_show_buttons()
	else:
		range_display.hide()
		_hide_buttons()

func _show_buttons():
	# 更新按钮文本和状态
	if level < max_level:
		upgrade_button.text = tr("UPGRADE") + " (" + str(get_upgrade_cost()) + " " + tr("COINS") + ")"
		upgrade_button.disabled = false
	else:
		upgrade_button.text = tr("MAX_LEVEL")
		upgrade_button.disabled = true
	
	destroy_button.text = tr("DESTROY") + " (+" + str(int(base_cost * level * 0.7)) + " " + tr("COINS") + ")"
	
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
		attack_range *= 1.1     # 提升攻击范围
		damage *= 1.3  # 提升伤害值
		tower_area_shape.shape.radius = attack_range
		
		print("attack_range: %d",attack_range)
		print("level: %d",level)
		print("fire_rate: %f",fire_rate)
		print("damage: %f",damage)
		
		BattleScene.update_coins_display()
		# 更新范围显示
		_update_range_display()
		# 更新按钮文本和状态
		if level < max_level:
			upgrade_button.text = tr("UPGRADE") + " (" + str(get_upgrade_cost()) + " " + tr("COINS") + ")"
		else:
			upgrade_button.text = tr("MAX_LEVEL")
			upgrade_button.disabled = true
		destroy_button.text = tr("DESTROY") + " (+" + str(int(base_cost * level * 0.7)) + " " + tr("COINS") + ")"
		# 更新等级标签
		level_label.text = "Lv. " + str(level)
		
		# 触发升级信号
		emit_signal("upgraded", level)

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
		# 新增：销毁后通知 BattleScene 清除选中状态
		if BattleScene.get_selected_tower() == self:
			BattleScene.set_selected_tower(null)

# 处理升级信号的函数
func _on_upgraded(new_level):
	print("快速低伤害防御塔已升级到等级: ", new_level)
	_update_sprite(new_level)

# 更新素材的辅助函数
func _update_sprite(current_level):
	if upgrade_materials.has(current_level):
		texture = load(upgrade_materials[current_level])
	else:
		print("警告: 未找到等级 ", current_level, " 的素材")

# 应用技能效果到塔的属性
func apply_skill_effects():
	# 获取塔的类型名称
	var tower_type = get_tower_type()
	
	apply_skill_effects_to_tower_stats(tower_type)
	
	# 更新范围显示
	_update_range_display()
	
	print("塔 ", tower_type, " 应用技能效果后的属性: 伤害=", damage, ", 射程=", attack_range, ", 攻速=", fire_rate)

# 获取塔的类型名称（子类需要重写此方法）
func get_tower_type() -> String:
	return "tower_base"
	
func apply_skill_effects_to_tower_stats(tower_type: String):
	var effects = GameManager.get_all_tower_skill_effects(tower_type)
	
	# 应用伤害倍率
	if effects.has("damage_multiplier"):
		damage *= (1.0 + effects["damage_multiplier"])
	
	# 应用射程倍率
	if effects.has("range_multiplier"):
		attack_range *= (1.0 + effects["range_multiplier"])
	
	# 应用攻速倍率
	if effects.has("fire_rate_multiplier"):
		fire_rate *= (1.0 + effects["fire_rate_multiplier"])
		
	# 应用增加暴击几率和伤害
	if effects.has("critical_chance"):
		critical_chance +=  effects["critical_chance"]
		critical_ratio *= (1.0 + effects["critical_chance"])
		
	# 应用穿透射击,子弹可以穿透多个敌人
	if effects.has("penetration_count"):
		penetration_count += effects["penetration_count"]
		
	# 多重射击
	if effects.has("bullet_count"):
		bullet_count += effects["bullet_count"]
	
	# 爆炸范围(因为没有实现范围爆炸，暂时加伤害)
	if effects.has("explosion_radius"):
		damage += effects["explosion_radius"]
	
	# 连锁反应
	if effects.has("chain_reaction"):
		chain_reaction += effects["chain_reaction"]
		
	# 燃烧效果(具体功能未实现)
	if effects.has("burn_damage"):
		burn_damage += effects["burn_damage"]
		
	# 冰冻时长
	if effects.has("freeze_duration"):
		freeze_duration += effects["freeze_duration"]
	
	# 减速强化
	if effects.has("slow_multiplier"):
		slow_multiplier += effects["slow_multiplier"]
		
	# 冰霜新星
	if effects.has("nova_chance"):
		nova_chance += effects["nova_chance"]
		
	# 霜甲护盾
	if effects.has("shield_strength"):
		shield_strength += effects["shield_strength"]
	
	# 地震冲击
	if effects.has("earthquake_chance"):
		earthquake_chance += effects["earthquake_chance"]
		
	# 破甲攻击
	if effects.has("armor_pierce"):
		armor_pierce += effects["armor_pierce"]
