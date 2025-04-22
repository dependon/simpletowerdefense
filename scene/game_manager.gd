extends Node

var stars : int = 0 # 玩家星星数量

func add_stars(amount : int):
	stars += amount
	print("获得星星！当前星星数量：" + str(stars))
	

signal level_selected(level_number: int)

var current_level: int = 0
var diamonds: int = 0  # 玩家拥有的钻石数量
var unlocked_levels: Array = [1]  # 默认只解锁第一关
var level_stars: Dictionary = {1: 0, 2: 0, 3: 0}  # 每个关卡的星级评分，默认为0星

func select_level(level: int) -> void:
	# 检查关卡是否已解锁
	if level in unlocked_levels:
		current_level = level
		level_selected.emit(level)
		get_tree().change_scene_to_file("res://scene/battle_scene.tscn")

# 解锁下一关卡
func unlock_next_level() -> void:
	var next_level = current_level + 1
	if next_level <= 3 and not next_level in unlocked_levels:  # 假设总共有3个关卡
		unlocked_levels.append(next_level)

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
