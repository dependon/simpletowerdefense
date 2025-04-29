extends LevelBase


func _ready():

	# 波次设置
	total_waves = 10  # 总波次数
	wave_interval = 8.0 # 波次之间的间隔时间 (秒)
	enemy_spawn_interval = 0.4 # 波次内敌人生成间隔 (秒)
	wave_duration_limit = 60.0 # 每波持续时间限制 (秒)

	# 怪物数量从少到多，血量和速度倍率逐渐增加
	wave_config = {
		1: {"count": 5, "health_multiplier": 1.0, "speed_multiplier": 1.0},
		2: {"count": 8, "health_multiplier": 1.2, "speed_multiplier": 1.0},
		3: {"count": 10, "health_multiplier": 1.4, "speed_multiplier": 1.1},
		4: {"count": 12, "health_multiplier": 1.6, "speed_multiplier": 1.1},
		5: {"count": 15, "health_multiplier": 1.8, "speed_multiplier": 1.2},
		6: {"count": 18, "health_multiplier": 2.2, "speed_multiplier": 1.2},
		7: {"count": 20, "health_multiplier": 2.6, "speed_multiplier": 1.35},
		8: {"count": 22, "health_multiplier": 3.4, "speed_multiplier": 1.35},
		9: {"count": 25, "health_multiplier": 4, "speed_multiplier": 1.5},
		10: {"count": 40, "health_multiplier": 6, "speed_multiplier": 1.5}
	}


	# 设置敌人生成点位置
	var spawn_point = $SpawnPoint
	if spawn_point:
		path.curve.add_point(spawn_point.position)
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
		
		if enemies_spawned_in_wave < enemies_this_wave:
			enemy_spawn_timer += delta
			if enemy_spawn_timer >= enemy_spawn_interval:
				spawn_enemy(current_wave_data["health_multiplier"], current_wave_data["speed_multiplier"])
				enemy_spawn_timer = 0
				enemies_spawned_in_wave += 1
		else:
			# 当前波次敌人已全部生成
			is_spawning_wave = false
			print("Wave ", current_wave, " spawning complete.")
			# 注意：此时不立即开始下一波间隔，需要等待场上敌人清空

	# 检查是否可以开始下一波的间隔计时
	# 条件：当前波次敌人已生成完毕(!is_spawning_wave), 不在间隔中(!is_between_waves), 场上没有敌人了, 且不是最后一波之后
	if not is_spawning_wave and not is_between_waves:
		# 如果场上没有敌人，则正常进入下一波
		if get_tree().get_nodes_in_group("enemies").size() == 0:
			if current_wave < total_waves:
				print("Wave ", current_wave, " cleared. Starting interval for Wave ", current_wave + 1)
				is_between_waves = true
				wave_timer = 0 # 重置波次间隔计时器
			# 如果已经是最后一波清空，则等待上面的胜利条件判断
		else:
			# 否则，开始计时
			wave_duration_timer += delta
			# 如果超过时间限制，则强制开始下一波
			if wave_duration_timer >= wave_duration_limit and current_wave < total_waves:
				print("Wave ", current_wave, " timed out. Starting next wave.")
				start_next_wave()

		# 如果已经是最后一波清空，则等待上面的胜利条件判断

# --- Helper Functions ---

func start_next_wave():
	# 增加波次计数器，确保在 total_waves 内
	if current_wave < total_waves:
		current_wave += 1
		print("Starting Wave: ", current_wave)
		if wave_config.has(current_wave):
			enemies_spawned_in_wave = 0
			enemy_spawn_timer = 0 # 重置波内生成计时器
			is_spawning_wave = true
			is_between_waves = false # 结束间隔，开始生成
			wave_timer = 0 # 重置间隔计时器以备后用
			wave_duration_timer = 0 # 重置波次持续时间计时器
		else:
			# 配置中缺少当前波次信息
			print("Error: Wave config not found for wave ", current_wave)
			get_tree().paused = true # 暂停游戏以示错误
		get_wave_info();
	else:
		# 尝试在所有波次完成后开始新波次，这不应该发生，由胜利逻辑处理
		print("Attempted to start wave beyond total waves.")
		wave_duration_timer = 0 # 重置波次持续时间计时器


func spawn_enemy(health_multiplier: float, speed_multiplier: float, is_thief = false):
	var enemy
	if enemies_spawned_in_wave  == 5 :
		enemy = thief_scene.instantiate()
	else:
		enemy = enemy_scene.instantiate()
	enemy.set_path(path.curve)
	# 假设 enemy.gd 中的 hp 是基础血量
	enemy.hp = enemy.hp * health_multiplier # 应用当前波次的血量倍率
	enemy.set_speed_multiplier(speed_multiplier) # 应用当前波次的速度倍率
	add_child(enemy)
	enemy.add_to_group("enemies")
