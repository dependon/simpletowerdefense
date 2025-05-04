extends LevelBase
class_name Level6Base

func _ready():
	# 波次设置 (Level 6)
	total_waves = 20  # 总波次数
	wave_interval = 4.0 # 波次之间的间隔时间 (秒)
	enemy_spawn_interval = 0.3 # 波次内敌人生成间隔 (秒)
	wave_duration_limit = 70.0 # 每波持续时间限制 (秒)

# 包含敌人类型混合比例，引入巫师敌人
	wave_config = {
		1:  {"count": 12, "health_multiplier": 1.0, "speed_multiplier": 1.2, "path_type": PathType.PATH_1, "enemy_mix": {EnemyType.NORMAL: 0.8, EnemyType.THIEF: 0.2}},
		2:  {"count": 15, "health_multiplier": 1.2, "speed_multiplier": 1.25, "path_type": PathType.PATH_2, "enemy_mix": {EnemyType.NORMAL: 0.7, EnemyType.THIEF: 0.3}},
		3:  {"count": 18, "health_multiplier": 2.4, "speed_multiplier": 1.3, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.NORMAL: 0.6, EnemyType.THIEF: 0.3, EnemyType.WIZARD: 0.1}}, # 开始出现巫师
		4:  {"count": 20, "health_multiplier": 3.6, "speed_multiplier": 1.35, "path_type": PathType.PATH_1, "enemy_mix": {EnemyType.NORMAL: 0.5, EnemyType.THIEF: 0.3, EnemyType.WIZARD: 0.2}},
		5:  {"count": 22, "health_multiplier": 3.8, "speed_multiplier": 1.4, "path_type": PathType.PATH_2, "enemy_mix": {EnemyType.NORMAL: 0.4, EnemyType.THIEF: 0.4, EnemyType.WIZARD: 0.2}},
		6:  {"count": 25, "health_multiplier": 4.0, "speed_multiplier": 1.45, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.NORMAL: 0.3, EnemyType.THIEF: 0.4, EnemyType.WIZARD: 0.3}}, # 巫师比例增加
		7:  {"count": 28, "health_multiplier": 4.3, "speed_multiplier": 1.5, "path_type": PathType.PATH_1, "enemy_mix": {EnemyType.NORMAL: 0.3, EnemyType.THIEF: 0.3, EnemyType.WIZARD: 0.4}},
		8:  {"count": 30, "health_multiplier": 4.6, "speed_multiplier": 1.55, "path_type": PathType.PATH_2, "enemy_mix": {EnemyType.NORMAL: 0.2, EnemyType.THIEF: 0.3, EnemyType.WIZARD: 0.5}},
		9:  {"count": 32, "health_multiplier": 4.9, "speed_multiplier": 1.6, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.NORMAL: 0.1, EnemyType.THIEF: 0.3, EnemyType.WIZARD: 0.6}},
		10: {"count": 35, "health_multiplier": 5.2, "speed_multiplier": 1.65, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.THIEF: 0.4, EnemyType.WIZARD: 0.6}}, # 巫师和盗贼混合
		11: {"count": 38, "health_multiplier": 5.5, "speed_multiplier": 1.7, "path_type": PathType.PATH_1, "enemy_mix": {EnemyType.NORMAL: 0.3, EnemyType.THIEF: 0.3, EnemyType.WIZARD: 0.3, EnemyType.WARRIOR: 0.1}}, # 引入战士
		12: {"count": 40, "health_multiplier": 5.8, "speed_multiplier": 1.75, "path_type": PathType.PATH_2, "enemy_mix": {EnemyType.NORMAL: 0.3, EnemyType.THIEF: 0.3, EnemyType.WIZARD: 0.3, EnemyType.WARRIOR: 0.1}},
		13: {"count": 42, "health_multiplier": 6.1, "speed_multiplier": 1.8, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.NORMAL: 0.2, EnemyType.THIEF: 0.3, EnemyType.WIZARD: 0.3, EnemyType.WARRIOR: 0.2}},
		14: {"count": 45, "health_multiplier": 6.4, "speed_multiplier": 1.85, "path_type": PathType.PATH_1, "enemy_mix": {EnemyType.NORMAL: 0.2, EnemyType.THIEF: 0.2, EnemyType.WIZARD: 0.3, EnemyType.WARRIOR: 0.3}},
		15: {"count": 48, "health_multiplier": 6.7, "speed_multiplier": 1.9, "path_type": PathType.PATH_2, "enemy_mix": {EnemyType.NORMAL: 0.1, EnemyType.THIEF: 0.2, EnemyType.WIZARD: 0.3, EnemyType.WARRIOR: 0.4}},
		16: {"count": 50, "health_multiplier": 7.0, "speed_multiplier": 1.95, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.THIEF: 0.2, EnemyType.WIZARD: 0.3, EnemyType.WARRIOR: 0.5}},
		17: {"count": 55, "health_multiplier": 7.5, "speed_multiplier": 2.0, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.THIEF: 0.3, EnemyType.WIZARD: 0.3, EnemyType.WARRIOR: 0.4}},
		18: {"count": 60, "health_multiplier": 8.0, "speed_multiplier": 2.1, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.THIEF: 0.2, EnemyType.WIZARD: 0.3, EnemyType.WARRIOR: 0.5}},
		19: {"count": 65, "health_multiplier": 8.5, "speed_multiplier": 2.2, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.THIEF: 0.1, EnemyType.WIZARD: 0.3, EnemyType.WARRIOR: 0.6}},
		20: {"count": 70, "health_multiplier": 9.0, "speed_multiplier": 2.3, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.NORMAL: 0.1, EnemyType.THIEF: 0.2, EnemyType.WIZARD: 0.3, EnemyType.WARRIOR: 0.4}} # 最终混合波
	}
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
