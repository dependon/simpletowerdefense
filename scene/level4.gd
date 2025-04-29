extends LevelBase

func _ready():

	# 波次设置
	total_waves = 20  # 总波次数
	wave_interval = 5.0 # 波次之间的间隔时间 (秒)
	enemy_spawn_interval = 0.35 # 波次内敌人生成间隔 (秒)
	wave_duration_limit = 60.0 # 每波持续时间限制 (秒)

	wave_config = {
		1: {"count": 8, "health_multiplier": 1.5, "speed_multiplier": 1.0, "path_type": PathType.PATH_1},
		2: {"count": 10, "health_multiplier": 1.7, "speed_multiplier": 1.1, "path_type": PathType.PATH_2},
		3: {"count": 12, "health_multiplier": 1.9, "speed_multiplier": 1.15, "path_type": PathType.BOTH_PATHS},
		4: {"count": 15, "health_multiplier": 2.1, "speed_multiplier": 1.2, "path_type": PathType.PATH_1},
		5: {"count": 18, "health_multiplier": 2.3, "speed_multiplier": 1.25, "path_type": PathType.PATH_2},
		6: {"count": 20, "health_multiplier": 2.5, "speed_multiplier": 1.3, "path_type": PathType.BOTH_PATHS},
		7: {"count": 22, "health_multiplier": 2.8, "speed_multiplier": 1.35, "path_type": PathType.PATH_1},
		8: {"count": 25, "health_multiplier": 3.0, "speed_multiplier": 1.4, "path_type": PathType.PATH_2},
		9: {"count": 28, "health_multiplier": 3.3, "speed_multiplier": 1.45, "path_type": PathType.BOTH_PATHS},
		10: {"count": 30, "health_multiplier": 3.5, "speed_multiplier": 1.5, "path_type": PathType.BOTH_PATHS},
		11: {"count": 32, "health_multiplier": 3.8, "speed_multiplier": 1.55, "path_type": PathType.PATH_1},
		12: {"count": 34, "health_multiplier": 4.0, "speed_multiplier": 1.6, "path_type": PathType.PATH_2},
		13: {"count": 36, "health_multiplier": 4.3, "speed_multiplier": 1.65, "path_type": PathType.BOTH_PATHS},
		14: {"count": 38, "health_multiplier": 4.5, "speed_multiplier": 1.7, "path_type": PathType.PATH_1},
		15: {"count": 40, "health_multiplier": 4.8, "speed_multiplier": 1.75, "path_type": PathType.PATH_2},
		16: {"count": 42, "health_multiplier": 5.0, "speed_multiplier": 1.8, "path_type": PathType.BOTH_PATHS},
		17: {"count": 45, "health_multiplier": 5.5, "speed_multiplier": 1.85, "path_type": PathType.BOTH_PATHS},
		18: {"count": 48, "health_multiplier": 6.0, "speed_multiplier": 1.9, "path_type": PathType.BOTH_PATHS},
		19: {"count": 50, "health_multiplier": 6.5, "speed_multiplier": 1.95, "path_type": PathType.BOTH_PATHS},
		20: {"count": 60, "health_multiplier": 7.0, "speed_multiplier": 2.0, "path_type": PathType.BOTH_PATHS},
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
				# 根据路径类型生成敌人
				if current_path_type == PathType.BOTH_PATHS:
					# 两条路径交替生成
					if path1_spawned <= path2_spawned:
						spawn_enemy(current_wave_data["health_multiplier"], current_wave_data["speed_multiplier"], path1)
						path1_spawned += 1
					else:
						spawn_enemy(current_wave_data["health_multiplier"], current_wave_data["speed_multiplier"], path2)
						path2_spawned += 1
				elif current_path_type == PathType.PATH_1:
					# 只从路径1生成
					spawn_enemy(current_wave_data["health_multiplier"], current_wave_data["speed_multiplier"], path1)
				elif current_path_type == PathType.PATH_2:
					# 只从路径2生成
					spawn_enemy(current_wave_data["health_multiplier"], current_wave_data["speed_multiplier"], path2)
				
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
		get_wave_info();
	else:
		# 尝试在所有波次完成后开始新波次，这不应该发生，由胜利逻辑处理
		print("尝试在总波次之外开始新波次。")
		wave_duration_timer = 0 # 重置波次持续时间计时器


func spawn_enemy(health_multiplier: float, speed_multiplier: float, target_path):
	var enemy = enemy_scene.instantiate()
	enemy.set_path(target_path.curve)
	# 假设 enemy.gd 中的 hp 是基础血量
	enemy.hp = enemy.hp * health_multiplier # 应用当前波次的血量倍率
	enemy.set_speed_multiplier(speed_multiplier) # 应用当前波次的速度倍率
	add_child(enemy)
	enemy.add_to_group("enemies")
