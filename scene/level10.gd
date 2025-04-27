extends Node2D

@onready var base = $Base # 基地
@onready var enemy_scene = preload("res://scene/enemy.tscn")
@onready var thief_scene = preload("res://scene/enemy_thief.tscn") 
@onready var enemy_wizard = preload("res://scene/enemy_wizard.tscn") 
@onready var enemy_warrior = preload("res://scene/enemy_warrior.tscn") 
@onready var enemy_werewolf = preload("res://scene/enemy_werewolf.tscn")

@onready var path1 = $Path2D
@onready var path2 = $Path2D_2 # 假设关卡10也有两条路径

# 波次设置 (Level 10 - Final Challenge)
@export var total_waves = 35  # 最终关卡波数
@export var wave_interval = 3.0 # 波次间隔更短
@export var enemy_spawn_interval = 0.18 # 生成间隔更短
@export var wave_duration_limit = 90.0 # 持续时间限制更长

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

# 波次配置字典 (Level 10) - 极高难度
var wave_config = {
	# 前期 (示例)
	1:  {"count": 25, "health_multiplier": 7.0, "speed_multiplier": 1.6, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.NORMAL: 0.4, EnemyType.THIEF: 0.3, EnemyType.WIZARD: 0.3}},
	# ...
	# 中期 (示例)
	15: {"count": 70, "health_multiplier": 12.0, "speed_multiplier": 2.4, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.WIZARD: 0.3, EnemyType.WARRIOR: 0.3, EnemyType.WEREWOLF: 0.4}},
	# ...
	# 后期 (示例)
	25: {"count": 120, "health_multiplier": 16.0, "speed_multiplier": 3.0, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.WARRIOR: 0.5, EnemyType.WEREWOLF: 0.5}},
	30: {"count": 150, "health_multiplier": 18.0, "speed_multiplier": 3.3, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.WIZARD: 0.2, EnemyType.WARRIOR: 0.4, EnemyType.WEREWOLF: 0.4}},
	# 最终波次 (示例)
	35: {"count": 200, "health_multiplier": 20.0, "speed_multiplier": 3.5, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.THIEF: 0.1, EnemyType.WIZARD: 0.2, EnemyType.WARRIOR: 0.3, EnemyType.WEREWOLF: 0.4}} 
}

# --- 状态变量和函数 (与 level9.gd 结构相同) ---
var current_wave = 0
var enemies_spawned_in_wave = 0
var wave_timer = 0.0
var enemy_spawn_timer = 0.0
var is_spawning_wave = false
var is_between_waves = true
var wave_duration_timer = 0.0
var is_victory = false
var current_path_type = PathType.PATH_1
var path1_spawned = 0
var path2_spawned = 0

func _ready():
	var spawn_point1 = $SpawnPoint
	var spawn_point2 = $SpawnPoint2
	if spawn_point1 and spawn_point2 and path1 and path2:
		spawn_point1.position = path1.curve.get_point_position(0)
		spawn_point2.position = path2.curve.get_point_position(0)
	is_between_waves = false
	start_next_wave()

func _physics_process(delta):
	if is_victory:
		return

	# 胜利条件
	if current_wave >= total_waves and not is_spawning_wave and get_tree().get_nodes_in_group("enemies").size() == 0:
		is_victory = true
		print("Level 10 Victory! Congratulations!")
		# 游戏通关处理
		return

	# 波次间隔
	if is_between_waves:
		wave_timer += delta
		if wave_timer >= wave_interval and current_wave < total_waves:
			wave_timer = 0.0
			is_between_waves = false
			start_next_wave()
		return

	# 波次生成
	if is_spawning_wave:
		# 波次时间限制
		wave_duration_timer += delta
		if wave_duration_timer >= wave_duration_limit:
			print("Wave ", current_wave, " timed out. Starting next wave interval.")
			is_spawning_wave = false
			if current_wave < total_waves:
				is_between_waves = true
				wave_timer = 0.0
			wave_duration_timer = 0.0
			return

		# 敌人生成间隔
		enemy_spawn_timer += delta
		if enemy_spawn_timer >= enemy_spawn_interval:
			enemy_spawn_timer = 0.0
			
			var config = wave_config[current_wave]
			var enemies_this_wave = config["count"]

			if enemies_spawned_in_wave < enemies_this_wave:
				var target_path = path1
				if current_path_type == PathType.BOTH_PATHS:
					if path1_spawned <= path2_spawned:
						target_path = path1
						path1_spawned += 1
					else:
						target_path = path2
						path2_spawned += 1
				elif current_path_type == PathType.PATH_2:
					target_path = path2
				
				spawn_enemy(target_path, config)
				enemies_spawned_in_wave += 1
			
			# 检查当前波次是否生成完毕
			if enemies_spawned_in_wave >= enemies_this_wave:
				print("Wave ", current_wave, " spawning complete.")
				is_spawning_wave = false
				wave_duration_timer = 0.0
				
	# 检查是否可以进入下一波间隔
	if not is_spawning_wave and not is_between_waves:
		if current_wave < total_waves:
			if get_tree().get_nodes_in_group("enemies").size() == 0:
				print("Wave ", current_wave, " cleared. Starting next wave interval.")
				is_between_waves = true
				wave_timer = 0.0


func start_next_wave():
	if current_wave < total_waves:
		current_wave += 1
		print("Starting Wave ", current_wave)
		
		if wave_config.has(current_wave):
			enemies_spawned_in_wave = 0
			is_spawning_wave = true
			is_between_waves = false
			enemy_spawn_timer = 0.0
			wave_duration_timer = 0.0
			path1_spawned = 0
			path2_spawned = 0
			current_path_type = wave_config[current_wave]["path_type"]
		else:
			print("Error: Wave config missing for wave ", current_wave)
	else:
		print("All waves completed.")


func spawn_enemy(path_node, config):
	var enemy_type = select_random_enemy_type(config["enemy_mix"])
	var enemy = null

	match enemy_type:
		EnemyType.NORMAL:
			enemy = enemy_scene.instantiate()
		EnemyType.THIEF:
			enemy = thief_scene.instantiate()
		EnemyType.WIZARD:
			enemy = enemy_wizard.instantiate()
		EnemyType.WARRIOR:
			enemy = enemy_warrior.instantiate()
		EnemyType.WEREWOLF:
			enemy = enemy_werewolf.instantiate()
		_:
			print("Error: Unknown enemy type selected!")
			enemy = enemy_scene.instantiate()

	if enemy:
		# 设置属性 (简化处理，假设 Enemy 脚本内部处理基础值)
		if enemy.has("hp"):
			enemy.hp *= config["health_multiplier"]
		if enemy.has("speed"):
			enemy.speed *= config["speed_multiplier"] # 注意：Enemy 基类或子类可能需要调整速度逻辑

		# 设置路径
		if enemy.has_method("set_path"):
			enemy.set_path(path_node.curve)
		
		# 添加到场景和分组
		add_child(enemy)
		enemy.add_to_group("enemies")


# 根据概率分布随机选择敌人类型
func select_random_enemy_type(enemy_mix: Dictionary) -> EnemyType:
	var rand = randf()
	var cumulative_prob = 0.0
	
	if enemy_mix.is_empty():
		return EnemyType.NORMAL

	for enemy_type in enemy_mix:
		if not EnemyType.has(enemy_type):
			continue 
		cumulative_prob += enemy_mix[enemy_type]
		if rand <= cumulative_prob:
			return enemy_type
	
	var keys = enemy_mix.keys()
	if not keys.is_empty():
		var last_key = keys[-1]
		if EnemyType.has(last_key):
			return last_key
			
	return EnemyType.NORMAL