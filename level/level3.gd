extends LevelBase

func _ready():

	# 波次设置 (Level 3)
	total_waves = 15  # 总波次数
	wave_interval = 15.0 # 波次之间的间隔时间 (秒) - 更短
	enemy_spawn_interval = 0.3 # 波次内敌人生成间隔 (秒) - 更快
	wave_duration_limit = 60.0 # 每波持续时间限制 (秒)

	# 波次配置字典 (Level 3)
	wave_config = {
		1: {"count": 10, "health_multiplier": 1.2, "speed_multiplier": 1.05, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}},
		2: {"count": 12, "health_multiplier": 1.3, "speed_multiplier": 1.1, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}},
		3: {"count": 15, "health_multiplier": 1.4, "speed_multiplier": 1.15, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}},
		4: {"count": 18, "health_multiplier": 1.6, "speed_multiplier": 1.2, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}},
		5: {"count": 20, "health_multiplier": 1.8, "speed_multiplier": 1.25, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}},
		6: {"count": 22, "health_multiplier": 2.0, "speed_multiplier": 1.3, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}},
		7: {"count": 25, "health_multiplier": 2.2, "speed_multiplier": 1.35, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}},
		8: {"count": 28, "health_multiplier": 2.4, "speed_multiplier": 1.4, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}},
		9: {"count": 32, "health_multiplier": 2.6, "speed_multiplier": 1.45, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}},
		10: {"count": 35, "health_multiplier": 2.8, "speed_multiplier": 1.5, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}},
		11: {"count": 38, "health_multiplier": 3.0, "speed_multiplier": 1.55, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}},
		12: {"count": 40, "health_multiplier": 3.2, "speed_multiplier": 1.6, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}},
		13: {"count": 42, "health_multiplier": 3.4, "speed_multiplier": 1.65, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}},
		14: {"count": 45, "health_multiplier": 3.6, "speed_multiplier": 1.7, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}},
		15: {"count": 50, "health_multiplier": 4.0, "speed_multiplier": 1.8, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}}
	}
