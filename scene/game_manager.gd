extends Node

# 存档文件名
const SAVE_GAME_FILENAME = "user://savegame.dat"

# 数据变量
var stars: int = 0
var current_level: int = 1
var diamonds: int = 0
var unlocked_levels: Array[int] = [1]  # 默认解锁第一关
var level_stars: Dictionary = {}  # 存储每个关卡的星级
var tower_skill_effects: Dictionary = {}  # 存储塔的技能效果
var skill_data: Dictionary = {}  # 存储技能树数据

func add_stars(amount : int):
	stars += amount
	print("获得星星！当前星星数量：" + str(stars))
	
signal next_wave_requested #开启下一波
signal level_selected(level_number: int)

func _ready():
	load_game()
	
	# 添加调试信息
	print("GameManager初始化完成")
	
	# 测试异步加载功能
	# 注释掉下面这行代码以禁用自动测试
	await get_tree().create_timer(2.0).timeout
	test_async_loading()

# 初始化关卡星级
func initialize_level_stars() -> void:
	for level in unlocked_levels:
		if not level in level_stars:
			level_stars[level] = 0

# 加载游戏存档
func load_game():
	var file = FileAccess.open(SAVE_GAME_FILENAME, FileAccess.READ)
	if file != null and !file.eof_reached():
		var data = file.get_var()
		stars = data.stars
		current_level = data.current_level
		diamonds = data.diamonds
		# 确保unlocked_levels是正确的类型
		if data.unlocked_levels is Array:
			unlocked_levels.clear()
			for level in data.unlocked_levels:
				unlocked_levels.append(int(level))
		else:
			unlocked_levels = [1]
		level_stars = data.level_stars
		# 加载技能效果数据
		if data.has("tower_skill_effects"):
			tower_skill_effects = data.tower_skill_effects
		else:
			tower_skill_effects = {}
		# 加载技能树数据
		if data.has("skill_data"):
			skill_data = data.skill_data
		else:
			skill_data = {}
		unlock_next_level()
		print("游戏存档加载成功！")
	else:
		print("没有找到游戏存档，使用默认设置。")
		initialize_level_stars()

# 保存游戏存档
func save_game():
	var data = {
		"stars": stars,
		"current_level": current_level,
		"diamonds": diamonds,
		"unlocked_levels": unlocked_levels,
		"level_stars": level_stars,
		"tower_skill_effects": tower_skill_effects,
		"skill_data": skill_data
	}
	var file = FileAccess.open(SAVE_GAME_FILENAME, FileAccess.WRITE)
	if file != null:
		file.store_var(data)
		print("游戏存档保存成功！")
	else:
		print("无法保存游戏存档！")

func select_level(level: int) -> void:
	get_tree().paused = false
	# 检查关卡是否已解锁
	if level in unlocked_levels:
		current_level = level
		level_selected.emit(level)
		# 使用通用加载屏幕方法切换到战斗场景
		change_scene_with_loading("res://scene/battle_scene.tscn")

# 解锁下一关卡
func unlock_next_level() -> void:
	var next_level = current_level + 1
	if next_level <= 10 and not next_level in unlocked_levels:  # 假设总共有10个关卡
		unlocked_levels.append(next_level)
		# 初始化新解锁关卡的星级
		level_stars[next_level] = 0

# 检查关卡是否已解锁
func is_level_unlocked(level: int) -> bool:
	return level in unlocked_levels

# 根据基地剩余血量设置关卡星级
func set_level_stars(level: int, base_health: int) -> void:
	var earned_stars = 0
	if base_health == 10:  # 满血通关
		earned_stars = 3
	elif base_health > 5:  # 大于50%血量
		earned_stars = 2
	else:  # 其他情况
		earned_stars = 1
	
	# 只有新的星级更高时才更新
	if level_stars[level] < earned_stars:
		level_stars[level] = earned_stars
		add_stars(earned_stars) # 增加星星数量

# 获取关卡星级
func get_level_stars(level: int) -> int:
	if level in level_stars:
		return level_stars[level]
	return 0

func add_diamonds(amount: int) -> void:
	diamonds += amount

# 请求下一波
func request_next_wave() -> void:
	next_wave_requested.emit()

# 获取当前钻石数量
func get_diamonds() -> int:
	return diamonds

# 技能系统相关方法

# 更新塔的技能效果
func update_tower_skill_effect(tower_type: String, effect_type: String, effect_value: float):
	if not tower_skill_effects.has(tower_type):
		tower_skill_effects[tower_type] = {}
	
	tower_skill_effects[tower_type][effect_type] = effect_value
	print("更新塔技能效果: ", tower_type, " - ", effect_type, ": ", effect_value)

# 获取塔的技能效果
func get_tower_skill_effect(tower_type: String, effect_type: String) -> float:
	if tower_skill_effects.has(tower_type) and tower_skill_effects[tower_type].has(effect_type):
		return tower_skill_effects[tower_type][effect_type]
	return 0.0

# 重置所有塔的技能效果
func reset_all_tower_skills():
	tower_skill_effects.clear()
	print("所有塔的技能效果已重置")

# 获取塔的所有技能效果
func get_all_tower_skill_effects(tower_type: String) -> Dictionary:
	if tower_skill_effects.has(tower_type):
		return tower_skill_effects[tower_type]
	return {}

# 技能数据管理函数

# 保存技能数据
func save_skill_data(data: Dictionary):
	skill_data = data.duplicate(true)
	print("技能数据已保存到GameManager")

# 获取技能数据
func get_skill_data() -> Dictionary:
	return skill_data

# 通用场景切换方法，使用异步加载屏幕
func change_scene_with_loading(target_scene_path: String) -> void:
	print("GameManager: 开始切换场景到 %s" % target_scene_path)
	# 使用加载屏幕切换到目标场景
	var loading_screen = load("res://scene/loading_screen.tscn").instantiate()
	# 添加到场景树
	var root = get_tree().root
	root.add_child(loading_screen)
	# 设置目标场景并开始异步加载
	loading_screen.set_target_scene(target_scene_path)

# 测试异步加载功能
func test_async_loading() -> void:
	print("开始测试异步加载功能")
	change_scene_with_loading("res://scene/start_menu.tscn")
