extends Level6Base

func _ready():

	# 波次设置 (Level 8)
	total_waves = 25  # 总波次数
	wave_interval = 3.5 # 波次之间的间隔时间 (秒)
	enemy_spawn_interval = 0.22 # 波次内敌人生成间隔 (秒)
	wave_duration_limit = 80.0 # 每波持续时间限制 (秒)

	# 波次配置字典 (Level 8): {wave_number: {"count": enemy_count, "health_multiplier": multiplier, "speed_multiplier": multiplier, "path_type": PathType, "enemy_mix": {EnemyType: percentage}}}
	# 包含敌人类型混合比例，更复杂的敌人组合
	wave_config = {
		1:  {"count": 18, "health_multiplier": 5.0, "speed_multiplier": 1.4, "path_type": PathType.PATH_1, "enemy_mix": {EnemyType.NORMAL: 0.6, EnemyType.THIEF: 0.2, EnemyType.WIZARD: 0.2}},
		2:  {"count": 20, "health_multiplier": 5.2, "speed_multiplier": 1.45, "path_type": PathType.PATH_2, "enemy_mix": {EnemyType.NORMAL: 0.5, EnemyType.THIEF: 0.3, EnemyType.WIZARD: 0.2}},
		3:  {"count": 22, "health_multiplier": 5.4, "speed_multiplier": 1.5, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.NORMAL: 0.4, EnemyType.THIEF: 0.3, EnemyType.WIZARD: 0.3}},
		4:  {"count": 25, "health_multiplier": 5.6, "speed_multiplier": 1.55, "path_type": PathType.PATH_1, "enemy_mix": {EnemyType.NORMAL: 0.3, EnemyType.THIEF: 0.3, EnemyType.WIZARD: 0.3, EnemyType.WARRIOR: 0.1}},
		5:  {"count": 28, "health_multiplier": 5.8, "speed_multiplier": 1.6, "path_type": PathType.PATH_2, "enemy_mix": {EnemyType.NORMAL: 0.2, EnemyType.THIEF: 0.3, EnemyType.WIZARD: 0.3, EnemyType.WARRIOR: 0.2}},
		6:  {"count": 30, "health_multiplier": 6.0, "speed_multiplier": 1.65, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.NORMAL: 0.1, EnemyType.THIEF: 0.3, EnemyType.WIZARD: 0.3, EnemyType.WARRIOR: 0.3}},
		7:  {"count": 32, "health_multiplier": 6.3, "speed_multiplier": 1.7, "path_type": PathType.PATH_1, "enemy_mix": {EnemyType.THIEF: 0.3, EnemyType.WIZARD: 0.3, EnemyType.WARRIOR: 0.3, EnemyType.WEREWOLF: 0.1}},
		8:  {"count": 35, "health_multiplier": 6.6, "speed_multiplier": 1.75, "path_type": PathType.PATH_2, "enemy_mix": {EnemyType.THIEF: 0.2, EnemyType.WIZARD: 0.3, EnemyType.WARRIOR: 0.3, EnemyType.WEREWOLF: 0.2}},
		9:  {"count": 38, "health_multiplier": 6.9, "speed_multiplier": 1.8, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.THIEF: 0.2, EnemyType.WIZARD: 0.2, EnemyType.WARRIOR: 0.3, EnemyType.WEREWOLF: 0.3}},
		10: {"count": 40, "health_multiplier": 7.2, "speed_multiplier": 1.85, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.THIEF: 0.1, EnemyType.WIZARD: 0.2, EnemyType.WARRIOR: 0.3, EnemyType.WEREWOLF: 0.4}},
		11: {"count": 42, "health_multiplier": 7.5, "speed_multiplier": 1.9, "path_type": PathType.PATH_1, "enemy_mix": {EnemyType.WIZARD: 0.2, EnemyType.WARRIOR: 0.3, EnemyType.WEREWOLF: 0.5}},
		12: {"count": 45, "health_multiplier": 7.8, "speed_multiplier": 1.95, "path_type": PathType.PATH_2, "enemy_mix": {EnemyType.WIZARD: 0.3, EnemyType.WARRIOR: 0.2, EnemyType.WEREWOLF: 0.5}},
		13: {"count": 48, "health_multiplier": 8.1, "speed_multiplier": 2.0, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.WIZARD: 0.2, EnemyType.WARRIOR: 0.3, EnemyType.WEREWOLF: 0.5}},
		14: {"count": 50, "health_multiplier": 8.4, "speed_multiplier": 2.05, "path_type": PathType.PATH_1, "enemy_mix": {EnemyType.WIZARD: 0.2, EnemyType.WARRIOR: 0.2, EnemyType.WEREWOLF: 0.6}},
		15: {"count": 55, "health_multiplier": 8.7, "speed_multiplier": 2.1, "path_type": PathType.PATH_2, "enemy_mix": {EnemyType.WIZARD: 0.1, EnemyType.WARRIOR: 0.2, EnemyType.WEREWOLF: 0.7}},
		16: {"count": 60, "health_multiplier": 9.0, "speed_multiplier": 2.15, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.WARRIOR: 0.3, EnemyType.WEREWOLF: 0.7}},
		17: {"count": 65, "health_multiplier": 9.5, "speed_multiplier": 2.2, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.WARRIOR: 0.2, EnemyType.WEREWOLF: 0.8}},
		18: {"count": 70, "health_multiplier": 10.0, "speed_multiplier": 2.3, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.WEREWOLF: 1.0}}, # 全是狼人
		19: {"count": 75, "health_multiplier": 10.5, "speed_multiplier": 2.4, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.WIZARD: 0.5, EnemyType.WEREWOLF: 0.5}}, # 巫师和狼人组合
		20: {"count": 80, "health_multiplier": 11.0, "speed_multiplier": 2.5, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.WARRIOR: 0.5, EnemyType.WEREWOLF: 0.5}}, # 战士和狼人组合
		21: {"count": 85, "health_multiplier": 11.5, "speed_multiplier": 2.6, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.THIEF: 0.5, EnemyType.WEREWOLF: 0.5}}, # 盗贼和狼人组合
		22: {"count": 90, "health_multiplier": 12.0, "speed_multiplier": 2.7, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.THIEF: 0.2, EnemyType.WIZARD: 0.2, EnemyType.WARRIOR: 0.3, EnemyType.WEREWOLF: 0.3}},
		23: {"count": 95, "health_multiplier": 12.5, "speed_multiplier": 2.8, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.THIEF: 0.2, EnemyType.WIZARD: 0.3, EnemyType.WARRIOR: 0.2, EnemyType.WEREWOLF: 0.3}},
		24: {"count": 100, "health_multiplier": 13.0, "speed_multiplier": 2.9, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.NORMAL: 0.1, EnemyType.THIEF: 0.2, EnemyType.WIZARD: 0.2, EnemyType.WARRIOR: 0.2, EnemyType.WEREWOLF: 0.3}},
		25: {"count": 120, "health_multiplier": 14.0, "speed_multiplier": 3.0, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.NORMAL: 0.1, EnemyType.THIEF: 0.2, EnemyType.WIZARD: 0.2, EnemyType.WARRIOR: 0.2, EnemyType.WEREWOLF: 0.3}} # 最终混合波
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
