extends Node2D

@onready var base = $Base # 基地仍然需要，用于扣血
@onready var enemy_scene = preload("res://scene/enemy.tscn")
@onready var path = $Path2D

# 波次设置 (Level 2)
@export var total_waves = 12  # 总波次数
@export var wave_interval = 4.0 # 波次之间的间隔时间 (秒) - 稍短
@export var enemy_spawn_interval = 0.4 # 波次内敌人生成间隔 (秒) - 稍快

# 波次配置字典 (Level 2)
var wave_config = {
	1: {"count": 8, "health_multiplier": 1.1, "speed_multiplier": 1.0},
	2: {"count": 10, "health_multiplier": 1.2, "speed_multiplier": 1.05},
	3: {"count": 12, "health_multiplier": 1.3, "speed_multiplier": 1.05},
	4: {"count": 15, "health_multiplier": 1.4, "speed_multiplier": 1.1},
	5: {"count": 18, "health_multiplier": 1.6, "speed_multiplier": 1.1},
	6: {"count": 20, "health_multiplier": 1.8, "speed_multiplier": 1.15},
	7: {"count": 22, "health_multiplier": 2.0, "speed_multiplier": 1.15},
	8: {"count": 25, "health_multiplier": 2.2, "speed_multiplier": 1.2},
	9: {"count": 28, "health_multiplier": 2.4, "speed_multiplier": 1.2},
	10: {"count": 32, "health_multiplier": 2.6, "speed_multiplier": 1.25},
	11: {"count": 35, "health_multiplier": 2.8, "speed_multiplier": 1.25},
	12: {"count": 40, "health_multiplier": 3.0, "speed_multiplier": 1.3}
}

# 状态变量
var current_wave = 0
var enemies_spawned_in_wave = 0
var wave_timer = 0.0 # 波次间隔计时器
var enemy_spawn_timer = 0.0 # 波次内生成计时器
var is_spawning_wave = false # 是否正在生成当前波次的敌人
var is_between_waves = true # 是否处于波次间隔 (初始为true，等待第一个间隔)
var is_victory = false

func _ready():
	# 设置敌人生成点位置
	var spawn_point = $SpawnPoint
	if spawn_point:
		# 确保路径曲线存在
		if path and path.curve:
			# 检查是否已经有点，避免重复添加
			if path.curve.point_count == 0 or path.curve.get_point_position(0) != spawn_point.position:
				# 如果没有点，或者第一个点不是生成点，则添加
				# 注意：如果路径设计为闭合或有其他点，此逻辑可能需要调整
				# 简单起见，这里假设路径初始为空或只需要设置起点
				# 如果路径已有其他点，可能需要插入或替换第一个点
				# 为了安全，我们先清空再添加（如果确定路径只由生成点开始）
				# path.curve.clear_points() # 如果确定要清空
				path.curve.add_point(spawn_point.position, Vector2.ZERO, Vector2.ZERO, 0) # 添加点，索引为0
		else:
			print("Error: Path or Path.curve not found in Level 2 _ready.")
	else:
		print("Error: SpawnPoint node not found in Level 2.")
	
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
		if not wave_config.has(current_wave):
			print("Error: Wave config missing for wave ", current_wave, " in Level 2.")
			get_tree().paused = true
			return

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
			print("Level 2 - Wave ", current_wave, " spawning complete.")
			# 注意：此时不立即开始下一波间隔，需要等待场上敌人清空

	# 检查是否可以开始下一波的间隔计时
	# 条件：当前波次敌人已生成完毕(!is_spawning_wave), 不在间隔中(!is_between_waves), 场上没有敌人了, 且不是最后一波之后
	if not is_spawning_wave and not is_between_waves and get_tree().get_nodes_in_group("enemies").size() == 0:
		if current_wave < total_waves:
			print("Level 2 - Wave ", current_wave, " cleared. Starting interval for Wave ", current_wave + 1)
			is_between_waves = true
			wave_timer = 0 # 重置波次间隔计时器
		# 如果已经是最后一波清空，则等待上面的胜利条件判断

# --- Helper Functions ---

func start_next_wave():
	# 增加波次计数器，确保在 total_waves 内
	if current_wave < total_waves:
		current_wave += 1
		print("Level 2 - Starting Wave: ", current_wave)
		if wave_config.has(current_wave):
			enemies_spawned_in_wave = 0
			enemy_spawn_timer = 0 # 重置波内生成计时器
			is_spawning_wave = true
			is_between_waves = false # 结束间隔，开始生成
			wave_timer = 0 # 重置间隔计时器以备后用
		else:
			# 配置中缺少当前波次信息
			print("Error: Wave config not found for wave ", current_wave, " in Level 2.")
			get_tree().paused = true # 暂停游戏以示错误
	else:
		# 尝试在所有波次完成后开始新波次，这不应该发生，由胜利逻辑处理
		print("Level 2 - Attempted to start wave beyond total waves.")


func spawn_enemy(health_multiplier: float, speed_multiplier: float):
	var enemy = enemy_scene.instantiate()
	if not enemy:
		print("Error: Failed to instantiate enemy scene in Level 2.")
		return
	
	if not path or not path.curve:
		print("Error: Path or curve is invalid in Level 2 spawn_enemy.")
		return
		
	enemy.set_path(path.curve)
	
	# 应用血量倍率 - 假设 enemy.gd 有一个基础 hp 值
	# 如果 enemy.gd 的 hp 是 @export var hp : float = 100
	# 那么实例化时 enemy.hp 就是 100 (基础值)
	if enemy.has_method("set_health_multiplier"): # 优先使用专用方法
		enemy.set_health_multiplier(health_multiplier)
	elif enemy.has_signal("health_changed"): # 或者通过修改hp触发信号更新（如果血条等依赖信号）
		var base_hp = 100 # 需要确认 enemy.gd 中的基础值
		# 尝试获取基础值，如果 enemy 有类似 get_base_hp() 的方法
		# if enemy.has_method("get_base_hp"): base_hp = enemy.get_base_hp()
		enemy.hp = base_hp * health_multiplier
	else: # 直接修改 hp 变量
		# 假设 enemy.hp 在实例化时就是基础值
		enemy.hp = enemy.hp * health_multiplier
		# 如果 enemy 内部在 _ready 中修改了 hp，这里可能需要先获取基础值
		# print("Warning: Directly setting enemy HP. Ensure base HP is handled correctly.")

	enemy.set_speed_multiplier(speed_multiplier) # 应用当前波次的速度倍率
	add_child(enemy)
	enemy.add_to_group("enemies")

func trigger_victory():
	if is_victory: # 防止重复触发
		return
	print("Level 2 Victory!")
	var victory_screen = preload("res://scene/victory_screen.tscn").instantiate()
	get_tree().root.add_child(victory_screen)
	is_victory = true
	# 可以选择暂停游戏或进行其他胜利处理
	# get_tree().paused = true
