extends Node2D

@onready var setting_menu = $UI/SettingMenu
@onready var wave_label = $UI/WaveLabel # 新增：对波次标签的引用
@onready var wait_time_label = $UI/WaitTime # 新增：对等待时间标签的引用

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
	get_tree().change_scene_to_file("res://scene/level_select.tscn")

func return_to_start_menu():
	setting_menu.hide()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scene/start_menu.tscn")

@onready var enemy_scene: PackedScene = preload("res://scene/enemy.tscn")
@onready var tower_scene: PackedScene = preload("res://scene/tower_base.tscn")
@onready var fast_tower_scene: PackedScene = preload("res://scene/tower_fast.tscn")
@onready var area_tower_scene: PackedScene = preload("res://scene/tower_area.tscn")
@onready var frost_tower_scene: PackedScene = preload("res://scene/tower_frost.tscn")
@onready var fast_low_damage_tower_scene: PackedScene = preload("res://scene/tower_fast_low_damage.tscn") 
@onready var big_area_tower_scene: PackedScene = preload("res://scene/tower_big_area.tscn") 

@onready var level1_scene: PackedScene = preload("res://scene/level1.tscn")
@onready var level2_scene: PackedScene = preload("res://scene/level2.tscn")
@onready var level3_scene: PackedScene = preload("res://scene/level3.tscn")
@onready var level4_scene: PackedScene = preload("res://scene/level4.tscn")
@onready var level5_scene: PackedScene = preload("res://scene/level5.tscn")
@onready var level6_scene: PackedScene = preload("res://scene/level6.tscn")
@onready var level7_scene: PackedScene = preload("res://scene/level7.tscn")
@onready var level8_scene: PackedScene = preload("res://scene/level8.tscn")
@onready var level9_scene: PackedScene = preload("res://scene/level9.tscn")
@onready var level10_scene: PackedScene = preload("res://scene/level10.tscn")



var current_tower_type = "normal"  # 可以是 "normal"、"fast"、"area" 、 "frost" 或 "fast_low_damage"
var current_level: Node2D = null
var current_level_path: Path2D = null
var wave_update_connection = null # 新增：用于存储信号连接



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
	if current_w > 0 and total_w > 0: # 确保值有效
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
	

func load_level(level_number: int):
	if current_level:
		# 新增：断开旧关卡的信号连接
		if wave_update_connection and wave_update_connection.is_valid() and current_level.has_signal("wave_updated"):
			current_level.wave_updated.disconnect(update_wave_display)
		current_level.queue_free()
	
	# 重置金币
	coins = 100
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
	else: # 新增：处理无效关卡编号
		printerr("无效的关卡编号: ", level_number)
		level_scene = level1_scene # 默认加载第一关或进行其他错误处理
		# return # 如果关卡号无效，则不继续加载
	current_level = level_scene.instantiate()
	
	add_child(current_level)
	# current_level_path = current_level.get_node("Path2D") # 这行可能需要根据实际关卡结构调整或移除

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
		printerr("当前关卡实例无效或缺少 wait_time_updated 信号: ", current_level)
	
	# 无论如何都尝试更新一次，即使可能显示默认值
	update_wave_display()


func update_wait_time_display(remaining_time: float):
	wait_time_label.text = "下一波: %d" % ceil(remaining_time)


func _physics_process(delta):
	pass

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos = get_local_mouse_position()
		var build_points = get_tree().get_nodes_in_group("build_points")
		for point in build_points:
			if point.position.distance_to(mouse_pos) < 32:
				# 检查建造点是否已被占用
				if point.is_point_occupied():
					break
				var cost
				match current_tower_type:
					"normal": 
						cost = NORMAL_TOWER_COST
					"fast": 
						cost = FAST_TOWER_COST
					"frost": 
						cost = FROST_TOWER_COST
					"fast_low_damage": # 新增：处理快速低伤塔成本
						cost = FAST_LOW_DAMAGE_TOWER_COST
					"big_area_damage":
						cost = BIG_AREA_TOWER_COST
					_: 
						cost = AREA_TOWER_COST

				if coins >= cost:
					var tower
					match current_tower_type:
						"normal": 
							tower = tower_scene.instantiate()
						"fast": 
							tower = fast_tower_scene.instantiate()
						"frost": 
							tower = frost_tower_scene.instantiate()
						"fast_low_damage": # 新增：实例化快速低伤塔
							tower = fast_low_damage_tower_scene.instantiate()
						"big_area_damage":
							tower = big_area_tower_scene.instantiate()
						_: 
							tower = area_tower_scene.instantiate()
					
					tower.position = point.position
					tower.set_z_index(3)

					add_child(tower)
					point.set_occupied(true)
					coins -= cost
					update_coins_display()
				break

func _on_normal_tower_button_pressed():
	current_tower_type = "normal"

func _on_fast_tower_button_pressed():
	current_tower_type = "fast"

func _on_area_tower_button_pressed():
	current_tower_type = "area"

func switch_to_level(level_number: int):
	load_level(level_number)


func _on_frost_tower_button_2_pressed() -> void:
	current_tower_type = "frost"

# 新增：快速低伤塔按钮处理函数
func _on_fast_low_tower_button_pressed() -> void:
	current_tower_type = "fast_low_damage"
	pass # Replace with function body.


func _on_big_area_tower_button_pressed() -> void:
	current_tower_type = "big_area_damage"
	pass # Replace with function body.
