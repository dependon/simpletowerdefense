extends LevelBase

func _ready():

	# 波次设置
	total_waves = 20  # 总波次数
	wave_interval = 20.0 # 波次之间的间隔时间 (秒)
	enemy_spawn_interval = 0.35 # 波次内敌人生成间隔 (秒)
	wave_duration_limit = 60.0 # 每波持续时间限制 (秒)

	wave_config = {
		1: {"count": 8, "health_multiplier": 1.5, "speed_multiplier": 1.0, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}},
		2: {"count": 10, "health_multiplier": 1.7, "speed_multiplier": 1.1, "path_type": PathType.PATH_2, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}},
		3: {"count": 12, "health_multiplier": 1.9, "speed_multiplier": 1.15, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}},
		4: {"count": 15, "health_multiplier": 2.1, "speed_multiplier": 1.2, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}},
		5: {"count": 18, "health_multiplier": 2.3, "speed_multiplier": 1.25, "path_type": PathType.PATH_2, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}},
		6: {"count": 20, "health_multiplier": 2.5, "speed_multiplier": 1.3, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}},
		7: {"count": 22, "health_multiplier": 2.8, "speed_multiplier": 1.35, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}},
		8: {"count": 25, "health_multiplier": 3.0, "speed_multiplier": 1.4, "path_type": PathType.PATH_2, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}},
		9: {"count": 28, "health_multiplier": 3.3, "speed_multiplier": 1.45, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}},
		10: {"count": 30, "health_multiplier": 3.5, "speed_multiplier": 1.5, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}},
		11: {"count": 32, "health_multiplier": 3.8, "speed_multiplier": 1.55, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}},
		12: {"count": 34, "health_multiplier": 4.0, "speed_multiplier": 1.6, "path_type": PathType.PATH_2, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}},
		13: {"count": 36, "health_multiplier": 4.3, "speed_multiplier": 1.65, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}},
		14: {"count": 38, "health_multiplier": 4.5, "speed_multiplier": 1.7, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}},
		15: {"count": 40, "health_multiplier": 4.8, "speed_multiplier": 1.75, "path_type": PathType.PATH_2, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}},
		16: {"count": 42, "health_multiplier": 5.0, "speed_multiplier": 1.8, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}},
		17: {"count": 45, "health_multiplier": 5.5, "speed_multiplier": 1.85, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}},
		18: {"count": 48, "health_multiplier": 6.0, "speed_multiplier": 1.9, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}},
		19: {"count": 50, "health_multiplier": 6.5, "speed_multiplier": 1.95, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}},
		20: {"count": 60, "health_multiplier": 7.0, "speed_multiplier": 2.0, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 1.0}},
	}
