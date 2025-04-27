extends Node2D

@onready var base = $Base # 基地
@onready var enemy_scene = preload("res://scene/enemy.tscn")
@onready var thief_scene = preload("res://scene/enemy_thief.tscn")
@onready var enemy_wizard = preload("res://scene/enemy_wizard.tscn")
@onready var enemy_warrior = preload("res://scene/enemy_warrior.tscn")
@onready var enemy_werewolf = preload("res://scene/enemy_werewolf.tscn")

@onready var path1 = $Path2D
@onready var path2 = $Path2D_2 # 假设关卡9也有两条路径

# 波次设置 (Level 9) - 难度提升
@export var total_waves = 30  # 总波次数增加
@export var wave_interval = 3.2 # 波次间隔缩短
@export var enemy_spawn_interval = 0.2 # 生成间隔缩短
@export var wave_duration_limit = 85.0 # 持续时间限制略微增加以容纳更多敌人

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

# 波次配置字典 (Level 9) - 更高的数值和更复杂的组合
var wave_config = {
	# 前期: 混合多种类型，战士和狼人比例逐渐增加
	1:  {"count": 20, "health_multiplier": 6.0, "speed_multiplier": 1.5, "path_type": PathType.PATH_1, "enemy_mix": {EnemyType.NORMAL: 0.4, EnemyType.THIEF: 0.3, EnemyType.WIZARD: 0.3}},
	2:  {"count": 22, "health_multiplier": 6.2, "speed_multiplier": 1.55, "path_type": PathType.PATH_2, "enemy_mix": {EnemyType.NORMAL: 0.3, EnemyType.THIEF: 0.3, EnemyType.WIZARD: 0.2, EnemyType.WARRIOR: 0.2}},
	3:  {"count": 25, "health_multiplier": 6.4, "speed_multiplier": 1.6, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.NORMAL: 0.2, EnemyType.THIEF: 0.2, EnemyType.WIZARD: 0.3, EnemyType.WARRIOR: 0.3}},
	4:  {"count": 28, "health_multiplier": 6.6, "speed_multiplier": 1.65, "path_type": PathType.PATH_1, "enemy_mix": {EnemyType.THIEF: 0.3, EnemyType.WIZARD: 0.3, EnemyType.WARRIOR: 0.3, EnemyType.WEREWOLF: 0.1}},
	5:  {"count": 30, "health_multiplier": 6.8, "speed_multiplier": 1.7, "path_type": PathType.PATH_2, "enemy_mix": {EnemyType.THIEF: 0.2, EnemyType.WIZARD: 0.2, EnemyType.WARRIOR: 0.4, EnemyType.WEREWOLF: 0.2}},
	# 中期: 狼人成为主力，配合巫师和战士
	6:  {"count": 33, "health_multiplier": 7.0, "speed_multiplier": 1.75, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.WIZARD: 0.3, EnemyType.WARRIOR: 0.3, EnemyType.WEREWOLF: 0.4}},
	7:  {"count": 36, "health_multiplier": 7.3, "speed_multiplier": 1.8, "path_type": PathType.PATH_1, "enemy_mix": {EnemyType.WIZARD: 0.2, EnemyType.WARRIOR: 0.3, EnemyType.WEREWOLF: 0.5}},
	8:  {"count": 39, "health_multiplier": 7.6, "speed_multiplier": 1.85, "path_type": PathType.PATH_2, "enemy_mix": {EnemyType.WIZARD: 0.2, EnemyType.WARRIOR: 0.2, EnemyType.WEREWOLF: 0.6}},
	9:  {"count": 42, "health_multiplier": 7.9, "speed_multiplier": 1.9, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.WARRIOR: 0.3, EnemyType.WEREWOLF: 0.7}},
	10: {"count": 45, "health_multiplier": 8.2, "speed_multiplier": 1.95, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.WARRIOR: 0.2, EnemyType.WEREWOLF: 0.8}},
	# ... (为简洁起见，省略11-20波，请根据需要填充，逐步增加难度和狼人比例)
	21: {"count": 70, "health_multiplier": 12.0, "speed_multiplier": 2.6, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.WIZARD: 0.3, EnemyType.WARRIOR: 0.3, EnemyType.WEREWOLF: 0.4}},
	22: {"count": 75, "health_multiplier": 12.5, "speed_multiplier": 2.7, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.WIZARD: 0.2, EnemyType.WARRIOR: 0.2, EnemyType.WEREWOLF: 0.6}},
	23: {"count": 80, "health_multiplier": 13.0, "speed_multiplier": 2.8, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.WARRIOR: 0.3, EnemyType.WEREWOLF: 0.7}},
	24: {"count": 85, "health_multiplier": 13.5, "speed_multiplier": 2.9, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.WARRIOR: 0.2, EnemyType.WEREWOLF: 0.8}},
	25: {"count": 90, "health_multiplier": 14.0, "speed_multiplier": 3.0, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.WEREWOLF: 1.0}}, # 纯狼人波
	26: {"count": 95, "health_multiplier": 14.5, "speed_multiplier": 3.1, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.WIZARD: 0.5, EnemyType.WEREWOLF: 0.5}}, # 巫师+狼人
	27: {"count": 100, "health_multiplier": 15.0, "speed_multiplier": 3.2, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.WARRIOR: 0.5, EnemyType.WEREWOLF: 0.5}}, # 战士+狼人
	28: {"count": 105, "health_multiplier": 15.5, "speed_multiplier": 3.3, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.THIEF: 0.3, EnemyType.WARRIOR: 0.3, EnemyType.WEREWOLF: 0.4}},
	29: {"count": 110, "health_multiplier": 16.0, "speed_multiplier": 3.4, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.WIZARD: 0.2, EnemyType.WARRIOR: 0.3, EnemyType.WEREWOLF: 0.5}},
	30: {"count": 130, "health_multiplier": 17.0, "speed_multiplier": 3.5, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.NORMAL: 0.1, EnemyType.THIEF: 0.1, EnemyType.WIZARD: 0.2, EnemyType.WARRIOR: 0.3, EnemyType.WEREWOLF: 0.3}} # 最终大混合
}

# --- 状态变量 (与Level 8类似) ---
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
	# 设置生成点位置 (与Level 8类似)
	var spawn_point1 = $SpawnPoint
	var spawn_point2 = $SpawnPoint2
	if spawn_point1 and spawn_point2 and path1 and path2:
		spawn_point1.position = path1.curve.get_point_position(0)
		spawn_point2.position = path2.curve.get_point_position(0)
	else:
		print("错误: 关卡9缺少生成点或路径节点！")

	is_between_waves = false
	start_next_wave()

func _physics_process(delta):
	if is_victory:
		return

	# 胜利条件 (与Level 8类似)
	if current_wave >= total_waves and not is_spawning_wave and get_tree().get_nodes_in_group("enemies").size() == 0:
		is_victory = true
		print("Level 9 Victory!")
		# 这里可以添加胜利后的处理，例如加载下一关或显示胜利界面
		return

	# 波次间隔处理 (与Level 8类似)
	if is_between_waves:
		wave_timer += delta
		if wave_timer >= wave_interval and current_wave < total_waves: # 确保还有下一波
			wave_timer = 0.0
			is_between_waves = false
			start_next_wave()
		return

	# 波次内敌人生成处理 (与Level 8类似)
	if is_spawning_wave:
		# 波次持续时间限制 (与Level 8类似)
		wave_duration_timer += delta
		if wave_duration_timer >= wave_duration_limit:
			print("波次 ", current_wave, " 超时，强制进入间隔。")
			is_spawning_wave = false
			is_between_waves = true # 进入间隔
			wave_timer = 0.0 # 重置间隔计时器
			wave_duration_timer = 0.0
			# 如果场上还有敌人，他们会继续前进
			return

		# 敌人生成间隔计时 (与Level 8类似)
		enemy_spawn_timer += delta
		if enemy_spawn_timer >= enemy_spawn_interval:
			enemy_spawn_timer = 0.0

			var config = wave_config[current_wave]
			var enemies_this_wave = config["count"]

			if enemies_spawned_in_wave < enemies_this_wave:
				# 选择路径 (与Level 8类似)
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

				# 生成敌人 (与Level 8类似)
				spawn_enemy(target_path, config)
				enemies_spawned_in_wave += 1
			else:
				# 当前波次敌人已全部生成 (与Level 8类似)
				is_spawning_wave = false
				print("波次 ", current_wave, " 生成完成。")
				# 等待敌人清空或超时才进入下一波间隔

	# 检查是否可以开始下一波的间隔计时 (与Level 8类似)
	if not is_spawning_wave and not is_between_waves:
		if get_tree().get_nodes_in_group("enemies").size() == 0:
			if current_wave < total_waves:
				print("波次 ", current_wave, " 清空。开始波次 ", current_wave + 1, " 的间隔")
				is_between_waves = true
				wave_timer = 0 # 重置波次间隔计时器
		# 超时逻辑已在 is_spawning_wave 分支中处理

func start_next_wave():
	# 增加波次计数器 (与Level 8类似)
	if current_wave < total_waves:
		current_wave += 1
		print("开始波次: ", current_wave)
		if wave_config.has(current_wave):
			# 重置状态 (与Level 8类似)
			enemies_spawned_in_wave = 0
			path1_spawned = 0
			path2_spawned = 0
			enemy_spawn_timer = 0
			is_spawning_wave = true
			is_between_waves = false
			wave_timer = 0
			wave_duration_timer = 0
			current_path_type = wave_config[current_wave]["path_type"]
		else:
			print("错误: 未找到波次 ", current_wave, " 的配置")
			get_tree().paused = true
	else:
		# 所有波次已完成，由 _physics_process 中的胜利逻辑处理
		pass


func spawn_enemy(path_node, config):
	# 选择敌人类型 (与Level 8类似)
	var enemy_type = select_random_enemy_type(config["enemy_mix"])
	var enemy_instance = null

	match enemy_type:
		EnemyType.NORMAL:
			enemy_instance = enemy_scene.instantiate()
		EnemyType.THIEF:
			enemy_instance = thief_scene.instantiate()
		EnemyType.WIZARD:
			enemy_instance = enemy_wizard.instantiate()
		EnemyType.WARRIOR:
			enemy_instance = enemy_warrior.instantiate()
		EnemyType.WEREWOLF:
			enemy_instance = enemy_werewolf.instantiate()
		_: # 默认情况或错误处理
			print("错误：未知的敌人类型！生成普通敌人作为后备。")
			enemy_instance = enemy_scene.instantiate()

	if enemy_instance:
		# 设置属性 (检查方法是否存在以提高兼容性)
		if enemy_instance.has_method("set_health_multiplier"):
			enemy_instance.set_health_multiplier(config["health_multiplier"])
		elif enemy_instance.has_property("hp"): # 兼容旧版或不同敌人基类
			# 注意：这里假设基础hp为100，如果不同敌人基础hp不同，需要更复杂的逻辑
			enemy_instance.hp = 100 * config["health_multiplier"]
		else:
			print("警告：无法设置敌人 ", enemy_instance.name, " 的生命值倍率。")

		if enemy_instance.has_method("set_speed_multiplier"):
			enemy_instance.set_speed_multiplier(config["speed_multiplier"])
		elif enemy_instance.has_property("speed_multiplier"): # 兼容旧版或不同敌人基类
			enemy_instance.speed_multiplier = config["speed_multiplier"]
		else:
			print("警告：无法设置敌人 ", enemy_instance.name, " 的速度倍率。")

		# 设置路径 (检查方法是否存在)
		if enemy_instance.has_method("set_path"):
			enemy_instance.set_path(path_node.curve)
		else:
			print("错误：敌人 ", enemy_instance.name, " 没有 set_path 方法！")
			enemy_instance.queue_free() # 无法设置路径，移除实例
			return

		# 添加到场景并分组 (与Level 8类似)
		add_child(enemy_instance)
		enemy_instance.add_to_group("enemies") # 确保敌人被添加到组中
	else:
		print("错误：无法实例化敌人类型 ", enemy_type)


# 根据概率分布随机选择敌人类型 (与Level 8类似)
func select_random_enemy_type(enemy_mix: Dictionary) -> EnemyType:
	var rand = randf()
	var cumulative_prob = 0.0

	for type in enemy_mix:
		cumulative_prob += enemy_mix[type]
		if rand <= cumulative_prob:
			# 确保返回的是枚举值，而不是字符串键
			if type is EnemyType:
				return type
			else:
				# 尝试从字符串转换（如果配置是用字符串写的）
				var enum_val = EnemyType.get(str(type).to_upper())
				if enum_val != null:
					return enum_val
				else:
					print("错误：无效的敌人类型键在 enemy_mix 中: ", type)
					return EnemyType.NORMAL # 返回默认值

	# 如果因为浮点精度问题或其他原因没有返回，返回默认值
	print("警告：select_random_enemy_type 未能根据概率选择，返回默认值。")
	# 查找字典中的第一个有效枚举类型作为后备
	for type in enemy_mix:
		if type is EnemyType: return type
		var enum_val = EnemyType.get(str(type).to_upper())
		if enum_val != null: return enum_val
	return EnemyType.NORMAL # 最终后备
