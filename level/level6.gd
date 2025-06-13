extends LevelBase

func _ready():
	# 波次设置 (Level 6)
	total_waves = 20  # 总波次数
	wave_interval = 20 # 波次之间的间隔时间 (秒)
	enemy_spawn_interval = 0.3 # 波次内敌人生成间隔 (秒)
	wave_duration_limit = 70.0 # 每波持续时间限制 (秒)

# 包含敌人类型混合比例，引入巫师敌人
	wave_config = {
		1:  {"count": 12, "health_multiplier": 1.0, "speed_multiplier": 1.2, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 0.8, EnemyManager.EnemyType.THIEF: 0.2}},
		2:  {"count": 15, "health_multiplier": 1.2, "speed_multiplier": 1.25, "path_type": PathType.PATH_2, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 0.7, EnemyManager.EnemyType.THIEF: 0.3}},
		3:  {"count": 18, "health_multiplier": 2.4, "speed_multiplier": 1.3, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 0.6, EnemyManager.EnemyType.THIEF: 0.3, EnemyManager.EnemyType.WIZARD: 0.1}}, # 开始出现巫师
		4:  {"count": 20, "health_multiplier": 3.6, "speed_multiplier": 1.35, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 0.5, EnemyManager.EnemyType.THIEF: 0.3, EnemyManager.EnemyType.WIZARD: 0.2}},
		5:  {"count": 1, "health_multiplier": 3.8, "speed_multiplier": 1.4, "path_type": PathType.PATH_2, "enemy_mix": {EnemyManager.EnemyType.ORC: 1.0}},
		6:  {"count": 25, "health_multiplier": 4.0, "speed_multiplier": 1.45, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 0.3, EnemyManager.EnemyType.THIEF: 0.4, EnemyManager.EnemyType.WIZARD: 0.3}}, # 巫师比例增加
		7:  {"count": 28, "health_multiplier": 4.3, "speed_multiplier": 1.5, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 0.3, EnemyManager.EnemyType.THIEF: 0.3, EnemyManager.EnemyType.WIZARD: 0.4}},
		8:  {"count": 30, "health_multiplier": 4.6, "speed_multiplier": 1.55, "path_type": PathType.PATH_2, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 0.2, EnemyManager.EnemyType.THIEF: 0.3, EnemyManager.EnemyType.WIZARD: 0.5}},
		9:  {"count": 32, "health_multiplier": 4.9, "speed_multiplier": 1.6, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 0.1, EnemyManager.EnemyType.THIEF: 0.3, EnemyManager.EnemyType.WIZARD: 0.6}},
		10: {"count": 1, "health_multiplier": 5.2, "speed_multiplier": 1.65, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.CRAZYONE: 1.0}},
		11: {"count": 38, "health_multiplier": 5.5, "speed_multiplier": 1.7, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 0.3, EnemyManager.EnemyType.THIEF: 0.3, EnemyManager.EnemyType.WIZARD: 0.3, EnemyManager.EnemyType.WARRIOR: 0.1}}, # 引入战士
		12: {"count": 40, "health_multiplier": 5.8, "speed_multiplier": 1.75, "path_type": PathType.PATH_2, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 0.3, EnemyManager.EnemyType.THIEF: 0.3, EnemyManager.EnemyType.WIZARD: 0.3, EnemyManager.EnemyType.WARRIOR: 0.1}},
		13: {"count": 42, "health_multiplier": 6.1, "speed_multiplier": 1.8, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 0.2, EnemyManager.EnemyType.THIEF: 0.3, EnemyManager.EnemyType.WIZARD: 0.3, EnemyManager.EnemyType.WARRIOR: 0.2}},
		14: {"count": 45, "health_multiplier": 6.4, "speed_multiplier": 1.85, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 0.2, EnemyManager.EnemyType.THIEF: 0.2, EnemyManager.EnemyType.WIZARD: 0.3, EnemyManager.EnemyType.WARRIOR: 0.3}},
		15: {"count": 1, "health_multiplier": 6.7, "speed_multiplier": 1.9, "path_type": PathType.PATH_2, "enemy_mix": {EnemyManager.EnemyType.ORC: 1.0}},
		16: {"count": 50, "health_multiplier": 7.0, "speed_multiplier": 1.95, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.THIEF: 0.2, EnemyManager.EnemyType.WIZARD: 0.3, EnemyManager.EnemyType.WARRIOR: 0.5}},
		17: {"count": 55, "health_multiplier": 7.5, "speed_multiplier": 2.0, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.THIEF: 0.3, EnemyManager.EnemyType.WIZARD: 0.3, EnemyManager.EnemyType.WARRIOR: 0.4}},
		18: {"count": 60, "health_multiplier": 8.0, "speed_multiplier": 2.1, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.THIEF: 0.2, EnemyManager.EnemyType.WIZARD: 0.3, EnemyManager.EnemyType.WARRIOR: 0.5}},
		19: {"count": 65, "health_multiplier": 8.5, "speed_multiplier": 2.2, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.THIEF: 0.1, EnemyManager.EnemyType.WIZARD: 0.3, EnemyManager.EnemyType.WARRIOR: 0.6}},
		20: {"count": 1, "health_multiplier": 9.0, "speed_multiplier": 2.3, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.CRAZYONE: 1.0}}
	}
