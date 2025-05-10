class_name LevelBase
extends Node2D

# 波次路径类型枚举
enum PathType {
	PATH_1,
	PATH_2,
	BOTH_PATHS
}

# 敌人类型枚举
enum EnemyType {
	NORMAL,
	THIEF,
	WIZARD,
	WARRIOR,
	WEREWOLF
}

# 新增：定义波次更新信号
signal wave_updated(current_wave, total_waves)

@onready var base = $Base # 基地仍然需要，用于扣血
@onready var enemy_scene = preload("res://scene/enemy.tscn")
@onready var thief_scene = preload("res://scene/enemy_thief.tscn") 
@onready var enemy_wizard = preload("res://scene/enemy_wizard.tscn") 
@onready var enemy_warrior = preload("res://scene/enemy_warrior.tscn") 
@onready var enemy_werewolf = preload("res://scene/enemy_werewolf.tscn")

@onready var path = $Path2D
@onready var path1 = $Path2D
@onready var path2 = $Path2D_2

# 波次配置字典: {wave_number: {"count": enemy_count, "health_multiplier": multiplier, "speed_multiplier": multiplier}}
# 怪物数量从少到多，血量和速度倍率逐渐增加
var wave_config = {
	1: {"count": 5, "health_multiplier": 1.0, "speed_multiplier": 1.0},
	2: {"count": 8, "health_multiplier": 1.1, "speed_multiplier": 1.0},
	3: {"count": 10, "health_multiplier": 1.2, "speed_multiplier": 1.05},
	4: {"count": 12, "health_multiplier": 1.3, "speed_multiplier": 1.05},
	5: {"count": 15, "health_multiplier": 1.5, "speed_multiplier": 1.1},
	6: {"count": 18, "health_multiplier": 1.7, "speed_multiplier": 1.1},
	7: {"count": 20, "health_multiplier": 1.9, "speed_multiplier": 1.15},
	8: {"count": 22, "health_multiplier": 2.1, "speed_multiplier": 1.15},
	9: {"count": 25, "health_multiplier": 2.3, "speed_multiplier": 1.2},
	10: {"count": 30, "health_multiplier": 2.5, "speed_multiplier": 1.2}
}

# 波次设置
@export var total_waves = 10  # 总波次数
@export var wave_interval = 5.0 # 波次之间的间隔时间 (秒)
@export var enemy_spawn_interval = 0.5 # 波次内敌人生成间隔 (秒)
@onready var wave_duration_limit = 60.0 # 每波持续时间限制 (秒)
@onready var wave_duration_timer = 60.0 # 波次持续时间计时器
# 状态变量
var current_wave = 0
var enemies_spawned_in_wave = 0
var wave_timer = 0.0 # 波次间隔计时器
var enemy_spawn_timer = 0.0 # 波次内生成计时器
var is_spawning_wave = false # 是否正在生成当前波次的敌人
var is_between_waves = true # 是否处于波次间隔 (初始为true，等待第一个间隔)
var is_victory = false #是否胜利
var current_path_type #当前路径

# 记录同时生成时两条路径分别生成的敌人数量
var path1_spawned = 0
var path2_spawned = 0

# 新增：获取当前波次信息的方法
func get_wave_info() -> Dictionary:
	emit_signal("wave_updated", current_wave , total_waves)
	return {"current": current_wave, "total": total_waves}

func _ready() -> void:
	pass

func startCurrentGame() -> void:
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

func trigger_victory() -> void:
	if is_victory: # 防止重复触发
		return
	print("Victory!")
	var victory_screen = preload("res://scene/victory_screen.tscn").instantiate()
	get_tree().root.add_child(victory_screen)
	is_victory = true

func _physics_process(delta):
	if is_victory:
		return

	# 检查胜利条件：所有波次完成且场上无敌人
	if current_wave >= total_waves and not is_spawning_wave and get_tree().get_nodes_in_group("enemies").size() == 0:
		trigger_victory();
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
	get_wave_info();
	
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
