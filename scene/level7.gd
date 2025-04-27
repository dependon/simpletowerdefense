extends Node2D

@onready var base = $Base # 基地仍然需要，用于扣血
@onready var enemy_scene = preload("res://scene/enemy.tscn")
@onready var thief_scene = preload("res://scene/enemy_thief.tscn") 
@onready var enemy_wizard = preload("res://scene/enemy_wizard.tscn") 
@onready var enemy_warrior = preload("res://scene/enemy_warrior.tscn") 
@onready var enemy_werewolf = preload("res://scene/enemy_werewolf.tscn")

@onready var path1 = $Path2D
@onready var path2 = $Path2D_2

# 波次设置 (Level 7)
@export var total_waves = 22  # 总波次数
@export var wave_interval = 3.8 # 波次之间的间隔时间 (秒)
@export var enemy_spawn_interval = 0.25 # 波次内敌人生成间隔 (秒)
@export var wave_duration_limit = 75.0 # 每波持续时间限制 (秒)

# 波次路径类型枚举
enum PathType {
	PATH_1,      # 路径1
	PATH_2,      # 路径2
	BOTH_PATHS   # 两条路径同时
}

# 敌人类型枚举
enum EnemyType {
	NORMAL,
	THIEF,
	WIZARD,
	WARRIOR,
	WEREWOLF
}

# 波次配置字典 (Level 7): {wave_number: {"count": enemy_count, "health_multiplier": multiplier, "speed_multiplier": multiplier, "path_type": PathType, "enemy_mix": {EnemyType: percentage}}}
# 包含敌人类型混合比例，引入狼人敌人
var wave_config = {
	1:  {"count": 15, "health_multiplier": 4.0, "speed_multiplier": 1.3, "path_type": PathType.PATH_1, "enemy_mix": {EnemyType.NORMAL: 0.7, EnemyType.THIEF: 0.2, EnemyType.WIZARD: 0.1}},
	2:  {"count": 18, "health_multiplier": 4.2, "speed_multiplier": 1.35, "path_type": PathType.PATH_2, "enemy_mix": {EnemyType.NORMAL: 0.6, EnemyType.THIEF: 0.3, EnemyType.WIZARD: 0.1}},
	3:  {"count": 20, "health_multiplier": 4.4, "speed_multiplier": 1.4, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.NORMAL: 0.5, EnemyType.THIEF: 0.3, EnemyType.WIZARD: 0.2}},
	4:  {"count": 22, "health_multiplier": 4.6, "speed_multiplier": 1.45, "path_type": PathType.PATH_1, "enemy_mix": {EnemyType.NORMAL: 0.4, EnemyType.THIEF: 0.3, EnemyType.WIZARD: 0.2, EnemyType.WARRIOR: 0.1}},
	5:  {"count": 25, "health_multiplier": 4.8, "speed_multiplier": 1.5, "path_type": PathType.PATH_2, "enemy_mix": {EnemyType.NORMAL: 0.3, EnemyType.THIEF: 0.3, EnemyType.WIZARD: 0.2, EnemyType.WARRIOR: 0.2}},
	6:  {"count": 28, "health_multiplier": 5.0, "speed_multiplier": 1.55, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.NORMAL: 0.2, EnemyType.THIEF: 0.3, EnemyType.WIZARD: 0.3, EnemyType.WARRIOR: 0.2}},
	7:  {"count": 30, "health_multiplier": 5.3, "speed_multiplier": 1.6, "path_type": PathType.PATH_1, "enemy_mix": {EnemyType.NORMAL: 0.2, EnemyType.THIEF: 0.2, EnemyType.WIZARD: 0.3, EnemyType.WARRIOR: 0.3}},
	8:  {"count": 32, "health_multiplier": 5.6, "speed_multiplier": 1.65, "path_type": PathType.PATH_2, "enemy_mix": {EnemyType.NORMAL: 0.1, EnemyType.THIEF: 0.2, EnemyType.WIZARD: 0.3, EnemyType.WARRIOR: 0.4}},
	9:  {"count": 35, "health_multiplier": 5.9, "speed_multiplier": 1.7, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.THIEF: 0.2, EnemyType.WIZARD: 0.3, EnemyType.WARRIOR: 0.5}},
	10: {"count": 38, "health_multiplier": 6.2, "speed_multiplier": 1.75, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.THIEF: 0.2, EnemyType.WIZARD: 0.3, EnemyType.WARRIOR: 0.4, EnemyType.WEREWOLF: 0.1}}, # 引入狼人
	11: {"count": 40, "health_multiplier": 6.5, "speed_multiplier": 1.8, "path_type": PathType.PATH_1, "enemy_mix": {EnemyType.THIEF: 0.2, EnemyType.WIZARD: 0.3, EnemyType.WARRIOR: 0.3, EnemyType.WEREWOLF: 0.2}},
	12: {"count": 42, "health_multiplier": 6.8, "speed_multiplier": 1.85, "path_type": PathType.PATH_2, "enemy_mix": {EnemyType.THIEF: 0.2, EnemyType.WIZARD: 0.2, EnemyType.WARRIOR: 0.3, EnemyType.WEREWOLF: 0.3}},
	13: {"count": 45, "health_multiplier": 7.1, "speed_multiplier": 1.9, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.THIEF: 0.1, EnemyType.WIZARD: 0.2, EnemyType.WARRIOR: 0.3, EnemyType.WEREWOLF: 0.4}},
	14: {"count": 48, "health_multiplier": 7.4, "speed_multiplier": 1.95, "path_type": PathType.PATH_1, "enemy_mix": {EnemyType.WIZARD: 0.2, EnemyType.WARRIOR: 0.3, EnemyType.WEREWOLF: 0.5}},
	15: {"count": 50, "health_multiplier": 7.7, "speed_multiplier": 2.0, "path_type": PathType.PATH_2, "enemy_mix": {EnemyType.WIZARD: 0.3, EnemyType.WARRIOR: 0.2, EnemyType.WEREWOLF: 0.5}},
	16: {"count": 55, "health_multiplier": 8.0, "speed_multiplier": 2.05, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.WIZARD: 0.2, EnemyType.WARRIOR: 0.3, EnemyType.WEREWOLF: 0.5}},
	17: {"count": 60, "health_multiplier": 8.5, "speed_multiplier": 2.1, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.WIZARD: 0.2, EnemyType.WARRIOR: 0.2, EnemyType.WEREWOLF: 0.6}},
	18: {"count": 65, "health_multiplier": 9.0, "speed_multiplier": 2.2, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.WIZARD: 0.1, EnemyType.WARRIOR: 0.2, EnemyType.WEREWOLF: 0.7}},
	19: {"count": 70, "health_multiplier": 9.5, "speed_multiplier": 2.3, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.WARRIOR: 0.2, EnemyType.WEREWOLF: 0.8}},
	20: {"count": 75, "health_multiplier": 10.0, "speed_multiplier": 2.4, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.WEREWOLF: 1.0}}, # 全是狼人
	21: {"count": 80, "health_multiplier": 10.5, "speed_multiplier": 2.5, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.THIEF: 0.2, EnemyType.WIZARD: 0.2, EnemyType.WARRIOR: 0.3, EnemyType.WEREWOLF: 0.3}},
	22: {"count": 90, "health_multiplier": 11.0, "speed_multiplier": 2.6, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.NORMAL: 0.1, EnemyType.THIEF: 0.2, EnemyType.WIZARD: 0.2, EnemyType.WARRIOR: 0.2, EnemyType.WEREWOLF: 0.3}} # 最终混合波
}

# 状态变量
var current_wave = 0
var enemies_spawned_in_wave = 0
var wave_timer = 0.0 # 波次间隔计时器
var enemy_spawn_timer = 0.0 # 波次内生成计时器
var is_spawning_wave = false # 是否正在生成当前波次的敌人
var is_between_waves = true # 是否处于波次间隔 (初始为true，等待第一个间隔)
var wave_duration_timer = 0.0 # 波次持续时间计时器
var is_victory = false

# 当前波次路径类型
var current_path_type = PathType.PATH_1
# 记录同时生成时两条路径分别生成的敌人数量
var path1_spawned = 0
var path2_spawned = 0

func _ready():
	# 设置敌人生成点位置
	var spawn_point1 = $SpawnPoint
	var spawn_point2 = $SpawnPoint2
	
	if spawn_point1 and spawn_point2:
		# 确保生成点在路径开始位置
		spawn_point1.position = path1.curve.get_point_position(0)
		spawn_point2.position = path2.curve.get_point_position(0)
	
	# 游戏开始时，立即开始第一波
	is_between_waves = false # 不处于间隔状态
	start_next_wave() # 调用函数开始第一波


func _physics_process(delta):
	if is_victory:
		return

	# 检查胜利条件：所有波次完成且场上无敌人
	if current_wave >= total_waves and not is_spawning_wave and get_tree().get_nodes_in_group("enemies").size() == 0:
		is_victory = true
		print("Victory!")
		return

	# 波次间隔处理
	if is_between_waves:
		wave_timer += delta
		if wave_timer >= wave_interval:
			wave_timer = 0.0
			is_between_waves = false
			start_next_wave()
		return

	# 波次内敌人生成处理
	if is_spawning_wave:
		# 检查波次持续时间限制
		wave_duration_timer += delta
		if wave_duration_timer >= wave_duration_limit:
			# 强制结束当前波次
			is_spawning_wave = false
			is_between_waves = true
			wave_timer = 0.0
			wave_duration_timer = 0.0
			return

		# 敌人生成间隔计时
		enemy_spawn_timer += delta
		if enemy_spawn_timer >= enemy_spawn_interval:
			enemy_spawn_timer = 0.0
			
			# 获取当前波次配置
			var config = wave_config[current_wave]
			
			# 根据路径类型生成敌人
			if current_path_type == PathType.PATH_1:
				spawn_enemy(path1, config)
				enemies_spawned_in_wave += 1
			elif current_path_type == PathType.PATH_2:
				spawn_enemy(path2, config)
				enemies_spawned_in_wave += 1
			elif current_path_type == PathType.BOTH_PATHS:
				# 交替在两条路径上生成敌人
				if path1_spawned <= path2_spawned:
					spawn_enemy(path1, config)
					path1_spawned += 1
				else:
					spawn_enemy(path2, config)
					path2_spawned += 1
				enemies_spawned_in_wave += 1
			
			# 检查是否已生成完当前波次的所有敌人
			if enemies_spawned_in_wave >= config["count"]:
				is_spawning_wave = false
				is_between_waves = true
				wave_timer = 0.0
				wave_duration_timer = 0.0


func start_next_wave():
	current_wave += 1
	if current_wave > total_waves:
		return
	
	print("Starting Wave ", current_wave)
	
	# 重置波次状态
	enemies_spawned_in_wave = 0
	is_spawning_wave = true
	enemy_spawn_timer = 0.0
	wave_duration_timer = 0.0
	path1_spawned = 0
	path2_spawned = 0
	
	# 设置当前波次的路径类型
	current_path_type = wave_config[current_wave]["path_type"]


func spawn_enemy(path_node, config):
	# 随机选择敌人类型
	var enemy_type = select_random_enemy_type(config["enemy_mix"])
	
	# 根据敌人类型创建相应的敌人实例
	var enemy
	if enemy_type == EnemyType.NORMAL:
		enemy = enemy_scene.instantiate()
	elif enemy_type == EnemyType.THIEF:
		enemy = thief_scene.instantiate()
	elif enemy_type == EnemyType.WIZARD:
		enemy = enemy_wizard.instantiate()
	elif enemy_type == EnemyType.WARRIOR:
		enemy = enemy_warrior.instantiate()
	elif enemy_type == EnemyType.WEREWOLF:
		enemy = enemy_werewolf.instantiate()
	
	# 设置敌人属性
	enemy.hp *= config["health_multiplier"]
	enemy.speed_multiplier = config["speed_multiplier"]
	
	# 设置敌人路径
	enemy.set_path(path_node.curve)
	
	# 将敌人添加到场景
	add_child(enemy)


# 根据概率分布随机选择敌人类型
func select_random_enemy_type(enemy_mix):
	var rand = randf()
	var cumulative_prob = 0.0
	
	for enemy_type in enemy_mix:
		cumulative_prob += enemy_mix[enemy_type]
		if rand <= cumulative_prob:
			return enemy_type
	
	# 默认返回普通敌人
	return EnemyType.NORMAL
