extends Node

# 存档文件名
const SAVE_GAME_FILENAME = "user://savegame.dat"

var stars : int = 0 # 玩家星星数量

func add_stars(amount : int):
	stars += amount
	print("获得星星！当前星星数量：" + str(stars))
	

signal level_selected(level_number: int)

var current_level: int = 0
var diamonds: int = 0  # 玩家拥有的钻石数量
var unlocked_levels: Array = [1]  # 默认只解锁第一关
var level_stars: Dictionary = {}  # 每个关卡的星级评分，默认为0星

func _ready():
	load_game()

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
		unlocked_levels = data.unlocked_levels
		level_stars = data.level_stars
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
		"level_stars": level_stars
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
		get_tree().change_scene_to_file("res://scene/battle_scene.tscn")

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
	var stars = 0
	if base_health == 10:  # 满血通关
		stars = 3
	elif base_health > 5:  # 大于50%血量
		stars = 2
	else:  # 其他情况
		stars = 1
	
	# 只有新的星级更高时才更新
	if level_stars[level] < stars:
		level_stars[level] = stars
		add_stars(stars) # 增加星星数量

# 获取关卡星级
func get_level_stars(level: int) -> int:
	if level in level_stars:
		return level_stars[level]
	return 0

func add_diamonds(amount: int) -> void:
	diamonds += amount

# 获取当前钻石数量
func get_diamonds() -> int:
	return diamonds
