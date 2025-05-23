extends Node2D

@onready var setting_menu = $UI/SettingMenu
@onready var next_wave_timer = $NextWaveTimer # 新增：下一波按钮冷却计时器

var is_next_wave_button_disabled = false # 新增：下一波按钮是否禁用

@onready var wave_label = $UI/WaveLabel # 新增：对波次标签的引用
@onready var wait_time_label = $UI/WaitTime # 新增：对等待时间标签的引用
@onready var next_wave_button = $UI/NextWave # 新增：对下一波按钮的引用
@onready var current_enemy_num_label = $UI/CurrentEnemyNum # 新增：对当前剩余怪物数量标签的引用
@onready var last_enemy_count

# 新增：防御塔选择按钮引用
@onready var normal_tower_button = $UI/BoxContainer/NormalTowerButton
@onready var fast_tower_button = $UI/BoxContainer/FastTowerButton
@onready var area_tower_button = $UI/BoxContainer/AreaTowerButton
@onready var frost_tower_button = $UI/BoxContainer/FrostTowerButton # 注意这里的名称可能需要根据场景文件确认
@onready var fast_low_tower_button = $UI/BoxContainer/FastLowTowerButton # 注意这里的名称可能需要根据场景文件确认
@onready var big_area_tower_button = $UI/BoxContainer/BigAreaTowerButton # 注意这里的名称可能需要根据场景文件确认

var selected_tower: Node = null # 新增：当前选中的防御塔实例

func _on_setting_button_pressed():
	get_tree().paused = true
	setting_menu.show()
	
	setting_menu.resume_game.connect(resume_game)
	setting_menu.return_to_level_select.connect(return_to_level_select)
	setting_menu.return_to_start_menu.connect(return_to_start_menu)

func resume_game():
	get_tree().paused = false
	setting_menu.hide()

func return_to_level_select():
	setting_menu.hide()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://level/level_select.tscn")

func return_to_start_menu():
	setting_menu.hide()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scene/start_menu.tscn")

@onready var enemy_scene: PackedScene = preload("res://enemy/enemy.tscn")
@onready var tower_scene: PackedScene = preload("res://tower/tower_base.tscn")
@onready var fast_tower_scene: PackedScene = preload("res://tower/tower_fast.tscn")
@onready var area_tower_scene: PackedScene = preload("res://tower/tower_area.tscn")
@onready var frost_tower_scene: PackedScene = preload("res://tower/tower_frost.tscn")
@onready var fast_low_damage_tower_scene: PackedScene = preload("res://tower/tower_fast_low_damage.tscn") 
@onready var big_area_tower_scene: PackedScene = preload("res://tower/tower_big_area.tscn") 

@onready var level1_scene: PackedScene = preload("res://level/level1.tscn")
@onready var level2_scene: PackedScene = preload("res://level/level2.tscn")
@onready var level3_scene: PackedScene = preload("res://level/level3.tscn")
@onready var level4_scene: PackedScene = preload("res://level/level4.tscn")
@onready var level5_scene: PackedScene = preload("res://level/level5.tscn")
@onready var level6_scene: PackedScene = preload("res://level/level6.tscn")
@onready var level7_scene: PackedScene = preload("res://level/level7.tscn")
@onready var level8_scene: PackedScene = preload("res://level/level8.tscn")
@onready var level9_scene: PackedScene = preload("res://level/level9.tscn")
@onready var level10_scene: PackedScene = preload("res://level/level10.tscn")
@onready var level11_scene: PackedScene = preload("res://level/level11.tscn")



var current_tower_type = ""  # 可以是 "normal"、"fast"、"area" 、 "frost" 或 "fast_low_damage"，初始为空
var current_level: Node2D = null
var current_level_paths: Array[Path2D] = [] # 修改：存储多个 Path2D 节点
var wave_update_connection = null # 新增：用于存储信号连接

# 新增：防御塔虚影相关变量
var tower_ghost: Sprite2D = null # 用于显示防御塔虚影的节点
var selected_tower_scene_for_ghost: PackedScene = null # 用于实例化虚影的场景
var can_place_tower = false # 标记当前位置是否可以放置防御塔

# 金币系统
var coins = 100  # 初始金币
const NORMAL_TOWER_COST = 50  # 普通塔消耗
const FAST_TOWER_COST = 100   # 快速塔消耗
const AREA_TOWER_COST = 150   # 群体塔消耗
const FROST_TOWER_COST = 100  # 冰霜塔消耗
const FAST_LOW_DAMAGE_TOWER_COST = 400 # 新增：快速低伤塔消耗 (示例成本)
const BIG_AREA_TOWER_COST = 200 # 新增：快速低伤塔消耗 (示例成本)

# 金币UI和钻石UI
func update_coins_display():
	$UI/Coins.text = "金币: " + str(coins)

func update_diamonds_display():
	$UI/Diamonds.text = "钻石: " + str(GameManager.get_diamonds())

# 新增：更新波次显示
func update_wave_display(current_w = -1, total_w = -1):
	# 优先使用信号传递过来的值
	if current_w >= 0 and total_w > 0: # 确保值有效
		wave_label.text = "波次: %d / %d" % [current_w, total_w]
	# 否则，尝试从当前关卡获取
	elif current_level and current_level.has_method("get_wave_info"):
		var wave_info = current_level.get_wave_info()
		if wave_info and wave_info.has("current") and wave_info.has("total"):
			wave_label.text = "波次: %d / %d" % [wave_info.current, wave_info.total]
		else:
			# 如果 get_wave_info 返回无效，显示默认值
			wave_label.text = "波次: 0 / -"
	else:
		# 如果无法获取信息，显示默认值
		wave_label.text = "波次: 0 / -"

func _ready():
	# 设置金币和钻石显示
	update_coins_display()
	update_diamonds_display()
	
	# 连接GameManager的level_selected信号
	GameManager.level_selected.connect(load_level)
	
	load_level(GameManager.current_level)
	update_wave_display() # 新增：初始更新波次显示
	
	update_enemy_count_display() # 初始更新一次
	_update_tower_button_selection_visuals() # 新增：初始更新按钮视觉状态

func load_level(level_number: int):
	if current_level:
		# 新增：断开旧关卡的信号连接
		if wave_update_connection and wave_update_connection.is_valid() and current_level.has_signal("wave_updated"):
			current_level.wave_updated.disconnect(update_wave_display)
		# 新增：断开等待时间更新信号
		if current_level and current_level.has_signal("wait_time_updated"):
			current_level.wait_time_updated.disconnect(update_wait_time_display)
		# 新增：断开初始等待时间更新信号
		if current_level and current_level.has_signal("initial_wait_time_updated"):
			current_level.initial_wait_time_updated.disconnect(update_initial_wait_time_display)
			
		current_level.queue_free()
	
	# 根据关卡编号设置初始金币
	coins = 100 + (level_number - 1) * 50
	update_coins_display()
	
	var level_scene
	if level_number == 1:
		level_scene = level1_scene
	elif level_number == 2:
		level_scene = level2_scene
	elif level_number == 3:
		level_scene = level3_scene
	elif level_number == 4:
		level_scene = level4_scene
	elif level_number == 5:
		level_scene = level5_scene
	elif level_number == 6:
		level_scene = level6_scene
	elif level_number == 7:
		level_scene = level7_scene
	elif level_number == 8:
		level_scene = level8_scene
	elif level_number == 9:
		level_scene = level9_scene
	elif level_number == 10:
		level_scene = level10_scene
	elif level_number == 11:
		level_scene = level11_scene
	else: # 新增：处理无效关卡编号
		printerr("无效的关卡编号: ", level_number)
		level_scene = level1_scene # 默认加载第一关或进行其他错误处理
		# return # 如果关卡号无效，则不继续加载
	current_level = level_scene.instantiate()
	
	add_child(current_level)
	# 查找当前关卡下的所有 Path2D 节点并存储
	current_level_paths.clear() # 清空之前的路径
	var found_nodes = current_level.find_children("*", "Path2D")
	if found_nodes.is_empty():
		printerr("当前关卡未找到任何 Path2D 节点!")
	else:
		for node in found_nodes:
			if node is Path2D:
				current_level_paths.append(node)
			else:
				printerr("找到一个非 Path2D 类型的节点，名称: ", node.name)


	# 新增：连接新关卡的信号
	if current_level and current_level.has_signal("wave_updated"):
		wave_update_connection = current_level.wave_updated.connect(update_wave_display)
		# 尝试立即更新一次波次显示（如果关卡已准备好）
		if current_level.has_method("get_wave_info"):
			update_wave_display()
		else:
			# 如果关卡还没有 get_wave_info 方法，可能需要在关卡 _ready 后更新
			# 可以稍后通过信号更新，所以这里暂时留空
			pass
	else:
		printerr("当前关卡实例无效或缺少 wave_updated 信号: ", current_level)
	
	# 新增：连接等待时间更新信号
	if current_level and current_level.has_signal("wait_time_updated"):
		current_level.wait_time_updated.connect(update_wait_time_display)
	else:
		printerr("当前关卡实例无效或缺少 wave_updated 信号: ", current_level) # 修正错误信息
	
	# 新增：连接初始等待时间更新信号
	if current_level and current_level.has_signal("initial_wait_time_updated"):
		current_level.initial_wait_time_updated.connect(update_initial_wait_time_display)
	else:
		printerr("当前关卡实例无效或缺少 initial_wait_time_updated 信号: ", current_level)
	
	# 无论如何都尝试更新一次，即使可能显示默认值
	update_wave_display()


func update_wait_time_display(remaining_time: float):
	wait_time_label.text = "下一波倒计时: %d" % ceil(remaining_time)

# 新增：更新初始等待时间显示
func update_initial_wait_time_display(remaining_time: float):
	wait_time_label.text = "初始等待: %d" % ceil(remaining_time)


func _physics_process(delta):
	update_enemy_count_display()
	# 新增：更新虚影位置和颜色
	if tower_ghost:
		var mouse_pos = get_global_mouse_position()
		tower_ghost.global_position = mouse_pos
		can_place_tower = check_can_place_tower(mouse_pos)
		if can_place_tower:
			tower_ghost.modulate = Color(0.56, 0.93, 0.56, 0.7) # 微绿色，带透明度
		else:
			tower_ghost.modulate = Color(1.0, 0.0, 0.0, 0.7) # 红色，带透明度


# 路径检测阈值（像素）
const PATH_DETECTION_THRESHOLD = 60
# 防御塔最小放置距离（像素）
const TOWER_MIN_DISTANCE = 60

@onready var ui_box_container = $UI/BoxContainer # 新增：对 BoxContainer 的引用

# 新增：检查是否可以放置防御塔的函数
func check_can_place_tower(position: Vector2) -> bool:
	# 1. 检查是否在 BoxContainer 范围内
	if ui_box_container and ui_box_container.get_global_rect().has_point(position):
		return false # 在UI范围内，不允许放置

	# 2. 检查是否在敌人路径附近
	if not current_level_paths.is_empty():
		for path_node in current_level_paths:
			var baked_points = path_node.curve.get_baked_points()
			for point in baked_points:
				# 将路径点从局部坐标转换为全局坐标
				var global_path_point = path_node.to_global(point)
				if global_path_point.distance_to(position) < PATH_DETECTION_THRESHOLD:
					return false # 在路径附近，不允许放置

	# 3. 检查是否与其他防御塔位置过近
	var towers = get_tree().get_nodes_in_group("towers")
	for tower in towers:
		if tower.global_position.distance_to(position) < TOWER_MIN_DISTANCE:
			return false # 与现有防御塔过近，不允许放置

	# 如果通过了所有检查，则可以放置
	return true


func _input(event):
	var mouse_pos = get_global_mouse_position() # 使用全局鼠标位置

	# 检测右键按下事件，用于取消选中防御塔类型
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		if current_tower_type != "":
			current_tower_type = ""
			_update_tower_button_selection_visuals() # 更新按钮视觉状态
			remove_tower_ghost() # 移除虚影
			print("Tower selection cleared by right-click.")
		# TODO: Add logic to deselect an existing tower if one is selected

	# 检测左键按下事件
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# 检查是否点击了UI元素 (例如防御塔选择按钮)
		var clicked_ui = false
		for child in $UI.get_children():
			if child is Control and child.visible and child.get_global_rect().has_point(mouse_pos):
				clicked_ui = true
				break
		
		if clicked_ui:
			# 如果点击了UI，则不执行其他逻辑，直接返回
			return

		# 放置防御塔的逻辑
		if current_tower_type != "" and can_place_tower:
			var cost
			var tower_scene_to_instantiate: PackedScene = null

			match current_tower_type:
				"normal":
					cost = NORMAL_TOWER_COST
					tower_scene_to_instantiate = tower_scene
				"fast":
					cost = FAST_TOWER_COST
					tower_scene_to_instantiate = fast_tower_scene
				"frost":
					cost = FROST_TOWER_COST
					tower_scene_to_instantiate = frost_tower_scene
				"fast_low_damage":
					cost = FAST_LOW_DAMAGE_TOWER_COST
					tower_scene_to_instantiate = fast_low_damage_tower_scene
				"big_area_damage":
					cost = BIG_AREA_TOWER_COST
					tower_scene_to_instantiate = big_area_tower_scene
				"area": # 确保 area 类型也在匹配中
					cost = AREA_TOWER_COST
					tower_scene_to_instantiate = area_tower_scene
				_:
					print("Unknown tower type: ", current_tower_type)
					return # 未知类型，退出

			if coins >= cost and tower_scene_to_instantiate:
				var tower = tower_scene_to_instantiate.instantiate()

				# 将防御塔位置设置为鼠标点击的全局位置
				tower.global_position = mouse_pos
				tower.set_z_index(3) # 确保防御塔在敌人上方显示

				add_child(tower)
				# 连接新放置防御塔的点击信号
				if tower.has_signal("tower_clicked"):
					tower.tower_clicked.connect(_on_tower_clicked)
				
				coins -= cost
				update_coins_display()
				
				# 成功放置后清空选中状态并移除虚影
				current_tower_type = ""
				_update_tower_button_selection_visuals()
				remove_tower_ghost()
				get_viewport().set_input_as_handled() # 阻止事件继续传播
				
			elif coins < cost:
				print("Not enough coins to place tower.")
		elif current_tower_type != "" and not can_place_tower:
			# 如果选中了防御塔但不能放置，打印提示
			print("Cannot place tower at this location.")
		else:
			# 如果没有选中防御塔类型，则处理已放置防御塔的选中逻辑
			var towers_under_mouse = []
			var all_towers = get_tree().get_nodes_in_group("towers")
			
			# 找到所有鼠标点击位置下的防御塔
			for tower in all_towers:
				# 假设 tower_base.gd 中的 MouseDetectionArea 是一个 Area2D
				# 并且其碰撞形状覆盖了塔的点击区域
				if tower.has_node("MouseDetectionArea"):
					var mouse_detection_area = tower.get_node("MouseDetectionArea")
					# 使用 PhysicsPointQueryParameters2D 来检测鼠标位置下的碰撞体
					var query = PhysicsPointQueryParameters2D.new()
					query.position = mouse_pos
					query.collide_with_areas = true
					query.collide_with_bodies = false
					
					var result = get_world_2d().direct_space_state.intersect_point(query)
					for r in result:
						if r.collider == mouse_detection_area:
							towers_under_mouse.append(tower)
							break # 找到一个就够了，避免重复添加

			if not towers_under_mouse.is_empty():
				# 找到离鼠标最近的防御塔
				var closest_tower = null
				var min_distance = INF
				
				for tower in towers_under_mouse:
					var distance = tower.global_position.distance_to(mouse_pos)
					if distance < min_distance:
						min_distance = distance
						closest_tower = tower
				
				# 选中最近的防御塔
				if closest_tower:
					_on_tower_clicked(closest_tower)
			else:
				# 如果没有点击到任何防御塔，则取消所有防御塔的选中状态
				if selected_tower:
					if selected_tower.has_method("set_selected"):
						selected_tower.set_selected(false)
					selected_tower = null


# 新增：创建防御塔虚影
func create_tower_ghost(tower_scene: PackedScene):
	remove_tower_ghost() # 先移除旧的虚影
	if tower_scene:
		var tower_instance = tower_scene.instantiate()
		# 使用实例化场景的根节点作为虚影，并确保它是 Sprite2D
		if tower_instance is Sprite2D:
			tower_ghost = tower_instance
			# 移除虚影节点的所有子节点和脚本，只保留 Sprite2D 的外观
			for child in tower_ghost.get_children():
				child.queue_free()
			tower_ghost.set_script(null)
			
			# 将虚影添加到场景中
			add_child(tower_ghost)
			tower_ghost.set_z_index(4) # 确保虚影在所有东西上面显示
			tower_ghost.modulate = Color(1.0, 1.0, 1.0, 0.7) # 初始半透明白色
		else:
			printerr("Selected tower scene root node is not a Sprite2D: ", tower_instance.get_class())
			tower_instance.queue_free() # 释放实例化的节点
			tower_ghost = null # 确保 tower_ghost 为 null

# 新增：移除防御塔虚影
func remove_tower_ghost():
	if tower_ghost and is_instance_valid(tower_ghost):
		tower_ghost.queue_free()
		tower_ghost = null
	selected_tower_scene_for_ghost = null # 清空选中的虚影场景

# 新增：更新防御塔选择按钮的视觉状态
func _update_tower_button_selection_visuals():
	var buttons = [
		{ "type": "normal", "button": normal_tower_button, "scene": tower_scene },
		{ "type": "fast", "button": fast_tower_button, "scene": fast_tower_scene },
		{ "type": "area", "button": area_tower_button, "scene": area_tower_scene },
		{ "type": "frost", "button": frost_tower_button, "scene": frost_tower_scene },
		{ "type": "fast_low_damage", "button": fast_low_tower_button, "scene": fast_low_damage_tower_scene },
		{ "type": "big_area_damage", "button": big_area_tower_button, "scene": big_area_tower_scene },
	]
	
	for item in buttons:
		if item.button: # 确保按钮节点存在
			if item.type == current_tower_type:
				# 高亮选中的按钮 (例如，改变颜色)
				item.button.modulate = Color("ffff00") # 浅黄色
				# 新增：设置虚影场景并创建虚影
				selected_tower_scene_for_ghost = item.scene
				create_tower_ghost(selected_tower_scene_for_ghost)
			else:
				# 恢复其他按钮的颜色
				item.button.modulate = Color("ffffff") # 白色 (正常颜色)
	
	# 如果没有选中任何防御塔类型，移除虚影
	if current_tower_type == "":
		remove_tower_ghost()


func _on_normal_tower_button_pressed():
	current_tower_type = "normal"
	_update_tower_button_selection_visuals() # 更新按钮视觉状态

func _on_fast_tower_button_pressed():
	current_tower_type = "fast"
	_update_tower_button_selection_visuals() # 更新按钮视觉状态

func _on_area_tower_button_pressed():
	current_tower_type = "area"
	_update_tower_button_selection_visuals() # 更新按钮视觉状态

func switch_to_level(level_number: int):
	load_level(level_number)


func _on_frost_tower_button_pressed() -> void:
	current_tower_type = "frost"
	_update_tower_button_selection_visuals() # 更新按钮视觉状态

# 新增：快速低伤塔按钮处理函数
func _on_fast_low_tower_button_pressed() -> void:
	current_tower_type = "fast_low_damage"
	_update_tower_button_selection_visuals() # 更新按钮视觉状态
	pass 


func _on_big_area_tower_button_pressed() -> void:
	current_tower_type = "big_area_damage"
	_update_tower_button_selection_visuals() # 更新按钮视觉状态
	pass 


func _on_next_wave_pressed() -> void:
	if not is_next_wave_button_disabled:
		is_next_wave_button_disabled = true
		next_wave_button.disabled = true # 禁用按钮
		next_wave_timer.start()
		GameManager.request_next_wave()
	pass

# 新增：下一波按钮冷却计时器超时处理函数
func _on_next_wave_timer_timeout() -> void:
	is_next_wave_button_disabled = false
	next_wave_button.disabled = false # 启用按钮

# 新增：更新当前剩余怪物数量显示
func update_enemy_count_display():
	var enemy_count = get_tree().get_nodes_in_group("enemies").size()
	if last_enemy_count != enemy_count :
		last_enemy_count = enemy_count
		current_enemy_num_label.text = "剩余怪物: " + str(enemy_count)


func _on_clear_tower_button_pressed() -> void:
	# 新增：清空选中状态并移除虚影
	current_tower_type = ""
	_update_tower_button_selection_visuals() # 更新按钮视觉状态
	remove_tower_ghost() # 移除虚影

# 新增：处理防御塔点击事件
func _on_tower_clicked(tower_instance: Node):
	# 如果当前有选中的防御塔，并且不是本次点击的防御塔，则取消其选中状态
	if selected_tower and selected_tower != tower_instance:
		if selected_tower.has_method("set_selected"):
			selected_tower.set_selected(false)
	
	# 设置新的选中防御塔
	selected_tower = tower_instance
	if selected_tower and selected_tower.has_method("set_selected"):
		selected_tower.set_selected(true)

# 新增：获取当前选中的防御塔
func get_selected_tower() -> Node:
	return selected_tower

# 新增：设置当前选中的防御塔（用于销毁时清除）
func set_selected_tower(tower: Node):
	selected_tower = tower
