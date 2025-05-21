extends LevelBase

func _ready():

	# 波次设置 (Level 2)
	total_waves = 12  # 总波次数
	wave_interval = 10.0 # 波次之间的间隔时间 (秒) - 稍短
	enemy_spawn_interval = 0.4 # 波次内敌人生成间隔 (秒) - 稍快
	wave_duration_limit = 60.0 # 每波持续时间限制 (秒)
	# 波次配置字典 (Level 2)
	wave_config = {
		1: {"count": 8, "health_multiplier": 1.1, "speed_multiplier": 1.0, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}},
		2: {"count": 10, "health_multiplier": 1.2, "speed_multiplier": 1.05, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}},
		3: {"count": 12, "health_multiplier": 1.3, "speed_multiplier": 1.05, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}},
		4: {"count": 15, "health_multiplier": 1.4, "speed_multiplier": 1.1, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}},
		5: {"count": 18, "health_multiplier": 1.6, "speed_multiplier": 1.1, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}},
		6: {"count": 20, "health_multiplier": 1.8, "speed_multiplier": 1.15, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}},
		7: {"count": 22, "health_multiplier": 2.0, "speed_multiplier": 1.15, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}},
		8: {"count": 25, "health_multiplier": 2.2, "speed_multiplier": 1.2, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}},
		9: {"count": 28, "health_multiplier": 2.4, "speed_multiplier": 1.2, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}},
		10: {"count": 32, "health_multiplier": 5.6, "speed_multiplier": 1.4, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}},
		11: {"count": 35, "health_multiplier": 7.8, "speed_multiplier": 1.6, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}},
		12: {"count": 40, "health_multiplier": 10.0, "speed_multiplier": 1.8, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}}
	}
