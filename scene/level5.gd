extends Node2D

@onready var base = $Base # 基地仍然需要，用于扣血
@onready var enemy_scene = preload("res://scene/enemy.tscn")
@onready var thief_scene = preload("res://scene/enemy_thief.tscn") 
@onready var enemy_wizard = preload("res://scene/enemy_wizard.tscn") 
@onready var enemy_warrior = preload("res://scene/enemy_warrior.tscn") 
@onready var enemy_werewolf  = preload("res://scene/enemy_werewolf.tscn")

@onready var path1 = $Path2D
@onready var path2 = $Path2D_2

# 波次设置 (Level 5)
@export var total_waves = 25  # 总波次数增加
@export var wave_interval = 4.5 # 波次之间的间隔时间 (秒)
@export var enemy_spawn_interval = 0.3 # 波次内敌人生成间隔 (秒)
@export var wave_duration_limit = 70.0 # 每波持续时间限制 (秒)

# 波次路径类型枚举
enum PathType {
	PATH_1,      # 路径1
	PATH_2,      # 路径2
	BOTH_PATHS   # 两条路径同时
}

# 敌人类型枚举 (新增)
enum EnemyType {
	NORMAL,
	THIEF,
	WIZARD,
	WARRIOR,
	WEREWOLF
}

# 波次配置字典 (Level 5): {wave_number: {"count": enemy_count, "health_multiplier": multiplier, "speed_multiplier": multiplier, "path_type": PathType, "enemy_mix": {EnemyType: percentage}}}
# 包含敌人类型混合比例
var wave_config = {
	1:  {"count": 15, "health_multiplier": 1.0, "speed_multiplier": 1.1, "path_type": PathType.PATH_1, "enemy_mix": {EnemyType.NORMAL: 1.0}},
	2:  {"count": 12, "health_multiplier": 2.2, "speed_multiplier": 1.15, "path_type": PathType.PATH_2, "enemy_mix": {EnemyType.NORMAL: 1.0}},
	3:  {"count": 15, "health_multiplier": 2.4, "speed_multiplier": 1.2, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.NORMAL: 0.8, EnemyType.THIEF: 0.2}}, # 开始出现盗贼
	4:  {"count": 18, "health_multiplier": 2.6, "speed_multiplier": 1.25, "path_type": PathType.PATH_1, "enemy_mix": {EnemyType.NORMAL: 0.7, EnemyType.THIEF: 0.3}},
	5:  {"count": 20, "health_multiplier": 2.8, "speed_multiplier": 1.3, "path_type": PathType.PATH_2, "enemy_mix": {EnemyType.NORMAL: 0.6, EnemyType.THIEF: 0.4}},
	6:  {"count": 24, "health_multiplier": 3.0, "speed_multiplier": 1.35, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.NORMAL: 0.5, EnemyType.THIEF: 0.5}}, # 盗贼比例增加
	7:  {"count": 26, "health_multiplier": 3.3, "speed_multiplier": 1.4, "path_type": PathType.PATH_1, "enemy_mix": {EnemyType.NORMAL: 0.4, EnemyType.THIEF: 0.6}},
	8:  {"count": 28, "health_multiplier": 3.6, "speed_multiplier": 1.45, "path_type": PathType.PATH_2, "enemy_mix": {EnemyType.NORMAL: 0.3, EnemyType.THIEF: 0.7}},
	9:  {"count": 30, "health_multiplier": 3.9, "speed_multiplier": 1.5, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.NORMAL: 0.2, EnemyType.THIEF: 0.8}},
	10: {"count": 35, "health_multiplier": 4.2, "speed_multiplier": 1.55, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.THIEF: 1.0}}, # 全是盗贼
	11: {"count": 38, "health_multiplier": 4.5, "speed_multiplier": 1.6, "path_type": PathType.PATH_1, "enemy_mix": {EnemyType.NORMAL: 0.8, EnemyType.THIEF: 0.2}},
	12: {"count": 40, "health_multiplier": 4.8, "speed_multiplier": 1.65, "path_type": PathType.PATH_2, "enemy_mix": {EnemyType.NORMAL: 0.7, EnemyType.THIEF: 0.3}},
	13: {"count": 42, "health_multiplier": 5.1, "speed_multiplier": 1.7, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.NORMAL: 0.6, EnemyType.THIEF: 0.4}},
	14: {"count": 45, "health_multiplier": 5.4, "speed_multiplier": 1.75, "path_type": PathType.PATH_1, "enemy_mix": {EnemyType.NORMAL: 0.5, EnemyType.THIEF: 0.5}},
	15: {"count": 48, "health_multiplier": 5.7, "speed_multiplier": 1.8, "path_type": PathType.PATH_2, "enemy_mix": {EnemyType.NORMAL: 0.4, EnemyType.THIEF: 0.6}},
	16: {"count": 50, "health_multiplier": 6.0, "speed_multiplier": 1.85, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.NORMAL: 0.3, EnemyType.THIEF: 0.7}},
	17: {"count": 52, "health_multiplier": 6.5, "speed_multiplier": 1.9, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.NORMAL: 0.2, EnemyType.THIEF: 0.8}},
	18: {"count": 55, "health_multiplier": 7.0, "speed_multiplier": 1.95, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.NORMAL: 0.1, EnemyType.THIEF: 0.9}},
	19: {"count": 60, "health_multiplier": 7.5, "speed_multiplier": 2.0, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.THIEF: 1.0}}, # 更多盗贼
	20: {"count": 65, "health_multiplier": 8.0, "speed_multiplier": 2.1, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.NORMAL: 0.5, EnemyType.THIEF: 0.5}},
	21: {"count": 70, "health_multiplier": 8.5, "speed_multiplier": 2.2, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.NORMAL: 0.4, EnemyType.THIEF: 0.6}},
	22: {"count": 75, "health_multiplier": 9.0, "speed_multiplier": 2.3, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.NORMAL: 0.3, EnemyType.THIEF: 0.7}},
	23: {"count": 80, "health_multiplier": 9.5, "speed_multiplier": 2.4, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.NORMAL: 0.2, EnemyType.THIEF: 0.8}},
	24: {"count": 85, "health_multiplier": 10.0, "speed_multiplier": 2.5, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.NORMAL: 0.1, EnemyType.THIEF: 0.9}},
	25: {"count": 100, "health_multiplier": 12.0, "speed_multiplier": 2.6, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.NORMAL: 0.5, EnemyType.THIEF: 0.5}} # 最终混合波
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
	if current_wave >= total_waves and get_tree().get_nodes_in_group("enemies").size() == 0:
		trigger_victory()
		return # 游戏胜利，停止处理

	# 处理波次间隔
	if is_between_waves:
		# 只有在还有下一波时才计时和开始
		if current_wave < total_waves:
			wave_timer += delta
			# 检查间隔时间是否足够
			if wave_timer >= wave_interval:
				start_next_wave()
		return # 在波次间隔期间，不执行后续生成逻辑

	# 处理波次内敌人生成
	if is_spawning_wave:
		# 检查是否还有未生成的敌人
		var current_wave_data = wave_config[current_wave]
		var enemies_this_wave = current_wave_data["count"]
		current_path_type = current_wave_data["path_type"]
		
		if enemies_spawned_in_wave < enemies_this_wave:
			enemy_spawn_timer += delta
			if enemy_spawn_timer >= enemy_spawn_interval:
				# 选择生成路径
				var target_path = path1 # 默认路径1
				if current_path_type == PathType.BOTH_PATHS:
					# 两条路径交替生成
					if path1_spawned <= path2_spawned:
						target_path = path1
						path1_spawned += 1
					else:
						target_path = path2
						path2_spawned += 1
				elif current_path_type == PathType.PATH_2:
					target_path = path2
				
				# 选择生成敌人类型 (新增逻辑)
				var enemy_type_to_spawn = choose_enemy_type(current_wave_data["enemy_mix"])
				
				# 生成敌人
				spawn_enemy(current_wave_data["health_multiplier"], current_wave_data["speed_multiplier"], target_path, enemy_type_to_spawn)
				
				enemy_spawn_timer = 0
				enemies_spawned_in_wave += 1
		else:
			# 当前波次敌人已全部生成
			is_spawning_wave = false
			print("波次 ", current_wave, " 生成完成。")
			# 注意：此时不立即开始下一波间隔，需要等待场上敌人清空

	# 检查是否可以开始下一波的间隔计时
	# 条件：当前波次敌人已生成完毕(!is_spawning_wave), 不在间隔中(!is_between_waves), 场上没有敌人了, 且不是最后一波之后
	if not is_spawning_wave and not is_between_waves:
		# 如果场上没有敌人，则正常进入下一波
		if get_tree().get_nodes_in_group("enemies").size() == 0:
			if current_wave < total_waves:
				print("波次 ", current_wave, " 清空。开始波次 ", current_wave + 1, " 的间隔")
				is_between_waves = true
				wave_timer = 0 # 重置波次间隔计时器
			# 如果已经是最后一波清空，则等待上面的胜利条件判断
		else:
			# 否则，开始计时
			wave_duration_timer += delta
			# 如果超过时间限制，则强制开始下一波
			if wave_duration_timer >= wave_duration_limit and current_wave < total_waves:
				print("波次 ", current_wave, " 超时。开始下一波。")
				start_next_wave()

		# 如果已经是最后一波清空，则等待上面的胜利条件判断

# --- 辅助函数 ---

# 新增：根据混合比例选择敌人类型
func choose_enemy_type(enemy_mix: Dictionary) -> EnemyType:
	var rand_val = randf() # 生成 0.0 到 1.0 之间的随机浮点数
	var cumulative_percentage = 0.0
	for type in enemy_mix:
		cumulative_percentage += enemy_mix[type]
		if rand_val < cumulative_percentage:
			return type
	# 作为后备，如果由于浮点精度问题没有返回，则返回第一个类型
	return enemy_mix.keys()[0]

func start_next_wave():
	# 增加波次计数器，确保在 total_waves 内
	if current_wave < total_waves:
		current_wave += 1
		print("开始波次: ", current_wave)
		if wave_config.has(current_wave):
			enemies_spawned_in_wave = 0
			path1_spawned = 0  # 重置路径1已生成敌人数量
			path2_spawned = 0  # 重置路径2已生成敌人数量
			enemy_spawn_timer = 0 # 重置波内生成计时器
			is_spawning_wave = true
			is_between_waves = false # 结束间隔，开始生成
			wave_timer = 0 # 重置间隔计时器以备后用
			wave_duration_timer = 0 # 重置波次持续时间计时器
		else:
			# 配置中缺少当前波次信息
			print("错误: 未找到波次 ", current_wave, " 的配置")
			get_tree().paused = true # 暂停游戏以示错误
	else:
		# 尝试在所有波次完成后开始新波次，这不应该发生，由胜利逻辑处理
		print("尝试在总波次之外开始新波次。")
		wave_duration_timer = 0 # 重置波次持续时间计时器

# 修改：spawn_enemy 函数接受敌人类型参数
func spawn_enemy(health_multiplier, speed_multiplier, target_path, enemy_type: EnemyType):
	var enemy_instance
	# 根据类型选择场景
	if enemy_type == EnemyType.THIEF:
		enemy_instance = thief_scene.instantiate()
	else: # 默认为普通敌人
		enemy_instance = enemy_scene.instantiate()
	
	# 设置敌人属性
	enemy_instance.set_health_multiplier(health_multiplier)
	enemy_instance.set_speed_multiplier(speed_multiplier)
	enemy_instance.set_path(target_path.curve) # 设置路径
	
	# 获取生成点位置 (PathFollow2D)
	var spawn_location = target_path.get_node("PathFollow2D")
	if spawn_location:
		# 确保敌人生成在路径起点
		spawn_location.progress = 0
		enemy_instance.global_position = spawn_location.global_position
	else:
		# 如果找不到 PathFollow2D，则使用路径的第一个点作为后备
		print("警告: 未在路径中找到 PathFollow2D 节点，使用路径起点生成敌人")
		enemy_instance.global_position = target_path.curve.get_point_position(0)
	
	# 将敌人添加到场景树和分组
	add_child(enemy_instance)
	enemy_instance.add_to_group("enemies")

func trigger_victory():
	if not is_victory:
		is_victory = true
		print("胜利！所有波次已完成！")
		# 这里可以添加胜利后的逻辑，例如显示胜利界面、返回主菜单等
		# 示例：简单地暂停游戏
		# get_tree().paused = true
		# 或者加载胜利场景
		# get_tree().change_scene_to_file("res://scene/victory_screen.tscn")

# 当敌人到达基地时由敌人脚本调用
func enemy_reached_base(enemy):
	base.take_damage(enemy.damage) # 假设敌人有 damage 属性
	print("敌人到达基地！基地剩余生命: ", base.health)
	if base.health <= 0:
		trigger_game_over()

func trigger_game_over():
	print("游戏结束！")
	# 这里可以添加游戏结束后的逻辑，例如显示失败界面、返回主菜单等
	get_tree().paused = true # 简单暂停
	# 或者加载失败场景
	# get_tree().change_scene_to_file("res://scene/game_over_screen.tscn")
