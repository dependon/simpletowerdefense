extends LevelBase


func _ready():

	# 波次设置
	wave_timer = 5
	total_waves = 10  # 总波次数
	wave_interval = 10.0 # 波次之间的间隔时间 (秒)
	enemy_spawn_interval = 0.4 # 波次内敌人生成间隔 (秒)
	wave_duration_limit = 60.0 # 每波持续时间限制 (秒)

	# 怪物数量从少到多，血量和速度倍率逐渐增加
	wave_config = {
		1: {"count": 5, "health_multiplier": 1.0, "speed_multiplier": 1.0, "path_type": PathType.PATH_1, "enemy_mix": {EnemyType.NORMAL: 1.0}},
		2: {"count": 8, "health_multiplier": 1.2, "speed_multiplier": 1.0, "path_type": PathType.PATH_1, "enemy_mix": {EnemyType.NORMAL: 1.0}},
		3: {"count": 10, "health_multiplier": 1.4, "speed_multiplier": 1.1, "path_type": PathType.PATH_1, "enemy_mix": {EnemyType.NORMAL: 1.0}},
		4: {"count": 12, "health_multiplier": 1.6, "speed_multiplier": 1.1, "path_type": PathType.PATH_1, "enemy_mix": {EnemyType.NORMAL: 1.0}},
		5: {"count": 15, "health_multiplier": 1.8, "speed_multiplier": 1.2, "path_type": PathType.PATH_1, "enemy_mix": {EnemyType.NORMAL: 1.0}},
		6: {"count": 18, "health_multiplier": 2.2, "speed_multiplier": 1.2, "path_type": PathType.PATH_1, "enemy_mix": {EnemyType.NORMAL: 1.0}},
		7: {"count": 20, "health_multiplier": 2.6, "speed_multiplier": 1.35, "path_type": PathType.PATH_1, "enemy_mix": {EnemyType.NORMAL: 1.0}},
		8: {"count": 22, "health_multiplier": 3.4, "speed_multiplier": 1.35, "path_type": PathType.PATH_1, "enemy_mix": {EnemyType.NORMAL: 1.0}},
		9: {"count": 25, "health_multiplier": 4, "speed_multiplier": 1.5, "path_type": PathType.PATH_1, "enemy_mix": {EnemyType.NORMAL: 1.0}},
		10: {"count": 40, "health_multiplier": 6, "speed_multiplier": 1.5, "path_type": PathType.PATH_1, "enemy_mix": {EnemyType.NORMAL: 1.0}}
	}
