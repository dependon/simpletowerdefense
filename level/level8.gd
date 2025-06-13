extends LevelBase

func _ready():

	# 波次设置 (Level 8)
	total_waves = 25  # 总波次数
	wave_interval = 20 # 波次之间的间隔时间 (秒)
	enemy_spawn_interval = 0.22 # 波次内敌人生成间隔 (秒)
	wave_duration_limit = 80.0 # 每波持续时间限制 (秒)

	# 波次配置字典 (Level 8): {wave_number: {"count": enemy_count, "health_multiplier": multiplier, "speed_multiplier": multiplier, "path_type": PathType, "enemy_mix": {EnemyType: percentage}}}
	# 包含敌人类型混合比例，更复杂的敌人组合
	wave_config = {
		1:  {"count": 18, "health_multiplier": 1.0, "speed_multiplier": 1.4, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 0.6, EnemyManager.EnemyType.THIEF: 0.2, EnemyManager.EnemyType.WIZARD: 0.2}},
		2:  {"count": 20, "health_multiplier": 1.5, "speed_multiplier": 1.45, "path_type": PathType.PATH_2, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 0.5, EnemyManager.EnemyType.THIEF: 0.3, EnemyManager.EnemyType.WIZARD: 0.2}},
		3:  {"count": 22, "health_multiplier": 2.5, "speed_multiplier": 1.5, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 0.4, EnemyManager.EnemyType.THIEF: 0.3, EnemyManager.EnemyType.WIZARD: 0.3}},
		4:  {"count": 25, "health_multiplier": 4.0, "speed_multiplier": 1.55, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 0.3, EnemyManager.EnemyType.THIEF: 0.3, EnemyManager.EnemyType.WIZARD: 0.3, EnemyManager.EnemyType.WARRIOR: 0.1}},
		5:  {"count": 1, "health_multiplier": 5.0, "speed_multiplier": 1.6, "path_type": PathType.PATH_2, "enemy_mix": {EnemyManager.EnemyType.ORC: 1.0}},
		6:  {"count": 30, "health_multiplier": 6.0, "speed_multiplier": 1.65, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 0.1, EnemyManager.EnemyType.THIEF: 0.3, EnemyManager.EnemyType.WIZARD: 0.3, EnemyManager.EnemyType.WARRIOR: 0.3}},
		7:  {"count": 32, "health_multiplier": 6.3, "speed_multiplier": 1.7, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.THIEF: 0.3, EnemyManager.EnemyType.WIZARD: 0.3, EnemyManager.EnemyType.WARRIOR: 0.3, EnemyManager.EnemyType.WEREWOLF: 0.1}},
		8:  {"count": 35, "health_multiplier": 6.6, "speed_multiplier": 1.75, "path_type": PathType.PATH_2, "enemy_mix": {EnemyManager.EnemyType.THIEF: 0.2, EnemyManager.EnemyType.WIZARD: 0.3, EnemyManager.EnemyType.WARRIOR: 0.3, EnemyManager.EnemyType.WEREWOLF: 0.2}},
		9:  {"count": 38, "health_multiplier": 6.9, "speed_multiplier": 1.8, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.THIEF: 0.2, EnemyManager.EnemyType.WIZARD: 0.2, EnemyManager.EnemyType.WARRIOR: 0.3, EnemyManager.EnemyType.WEREWOLF: 0.3}},
		10: {"count": 1, "health_multiplier": 15.0, "speed_multiplier": 1.85, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.CRAZYONE: 1.0}},
		11: {"count": 42, "health_multiplier": 7.5, "speed_multiplier": 1.9, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.WIZARD: 0.2, EnemyManager.EnemyType.WARRIOR: 0.3, EnemyManager.EnemyType.WEREWOLF: 0.5}},
		12: {"count": 45, "health_multiplier": 7.8, "speed_multiplier": 1.95, "path_type": PathType.PATH_2, "enemy_mix": {EnemyManager.EnemyType.WIZARD: 0.3, EnemyManager.EnemyType.WARRIOR: 0.2, EnemyManager.EnemyType.WEREWOLF: 0.5}},
		13: {"count": 48, "health_multiplier": 8.1, "speed_multiplier": 2.0, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.WIZARD: 0.2, EnemyManager.EnemyType.WARRIOR: 0.3, EnemyManager.EnemyType.WEREWOLF: 0.5}},
		14: {"count": 50, "health_multiplier": 8.4, "speed_multiplier": 2.05, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.WIZARD: 0.2, EnemyManager.EnemyType.WARRIOR: 0.2, EnemyManager.EnemyType.WEREWOLF: 0.6}},
		15: {"count": 1, "health_multiplier": 20.0, "speed_multiplier": 2.1, "path_type": PathType.PATH_2, "enemy_mix": {EnemyManager.EnemyType.ORC: 1.0}},
		16: {"count": 60, "health_multiplier": 9.0, "speed_multiplier": 2.15, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.WARRIOR: 0.3, EnemyManager.EnemyType.WEREWOLF: 0.7}},
		17: {"count": 65, "health_multiplier": 9.5, "speed_multiplier": 2.2, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.WARRIOR: 0.2, EnemyManager.EnemyType.WEREWOLF: 0.8}},
		18: {"count": 70, "health_multiplier": 10.0, "speed_multiplier": 2.3, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.WEREWOLF: 1.0}}, # 全是狼人
		19: {"count": 75, "health_multiplier": 10.5, "speed_multiplier": 2.4, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.WIZARD: 0.5, EnemyManager.EnemyType.WEREWOLF: 0.5}}, # 巫师和狼人组合
		20: {"count": 1, "health_multiplier": 40.0, "speed_multiplier": 2.5, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.CRAZYONE: 1.0}},
		21: {"count": 85, "health_multiplier": 11.5, "speed_multiplier": 2.6, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.THIEF: 0.5, EnemyManager.EnemyType.WEREWOLF: 0.5}}, # 盗贼和狼人组合
		22: {"count": 90, "health_multiplier": 12.0, "speed_multiplier": 2.7, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.THIEF: 0.2, EnemyManager.EnemyType.WIZARD: 0.2, EnemyManager.EnemyType.WARRIOR: 0.3, EnemyManager.EnemyType.WEREWOLF: 0.3}},
		23: {"count": 95, "health_multiplier": 12.5, "speed_multiplier": 2.8, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.THIEF: 0.2, EnemyManager.EnemyType.WIZARD: 0.3, EnemyManager.EnemyType.WARRIOR: 0.2, EnemyManager.EnemyType.WEREWOLF: 0.3}},
		24: {"count": 100, "health_multiplier": 13.0, "speed_multiplier": 2.9, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 0.1, EnemyManager.EnemyType.THIEF: 0.2, EnemyManager.EnemyType.WIZARD: 0.2, EnemyManager.EnemyType.WARRIOR: 0.2, EnemyManager.EnemyType.WEREWOLF: 0.3}},
		25: {"count": 1, "health_multiplier": 100.0, "speed_multiplier": 3.0, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.ORC: 1.0}}
	}
