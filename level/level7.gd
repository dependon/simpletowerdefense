extends LevelBase


func _ready():

	# 波次设置 (Level 7)
	total_waves = 22  # 总波次数
	wave_interval = 20 # 波次之间的间隔时间 (秒)
	enemy_spawn_interval = 0.25 # 波次内敌人生成间隔 (秒)
	wave_duration_limit = 75.0 # 每波持续时间限制 (秒)

	wave_config = {
		1:  {"count": 15, "health_multiplier": 1.0, "speed_multiplier": 0.5, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 0.7, EnemyManager.EnemyType.THIEF: 0.2, EnemyManager.EnemyType.WIZARD: 0.1}},
		2:  {"count": 18, "health_multiplier": 1.2, "speed_multiplier": 0.6, "path_type": PathType.PATH_2, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 0.6, EnemyManager.EnemyType.THIEF: 0.3, EnemyManager.EnemyType.WIZARD: 0.1}},
		3:  {"count": 20, "health_multiplier": 1.4, "speed_multiplier": 0.7, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 0.5, EnemyManager.EnemyType.THIEF: 0.3, EnemyManager.EnemyType.WIZARD: 0.2}},
		4:  {"count": 22, "health_multiplier": 1.6, "speed_multiplier": 0.8, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 0.4, EnemyManager.EnemyType.THIEF: 0.3, EnemyManager.EnemyType.WIZARD: 0.2, EnemyManager.EnemyType.WARRIOR: 0.1}},
		5:  {"count": 1, "health_multiplier": 2.8, "speed_multiplier": 1.5, "path_type": PathType.PATH_2, "enemy_mix": {EnemyManager.EnemyType.ORC: 1.0}},
		6:  {"count": 28, "health_multiplier": 4.0, "speed_multiplier": 1.55, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 0.2, EnemyManager.EnemyType.THIEF: 0.3, EnemyManager.EnemyType.WIZARD: 0.3, EnemyManager.EnemyType.WARRIOR: 0.2}},
		7:  {"count": 30, "health_multiplier": 5.3, "speed_multiplier": 1.6, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 0.2, EnemyManager.EnemyType.THIEF: 0.2, EnemyManager.EnemyType.WIZARD: 0.3, EnemyManager.EnemyType.WARRIOR: 0.3}},
		8:  {"count": 32, "health_multiplier": 5.6, "speed_multiplier": 1.65, "path_type": PathType.PATH_2, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 0.1, EnemyManager.EnemyType.THIEF: 0.2, EnemyManager.EnemyType.WIZARD: 0.3, EnemyManager.EnemyType.WARRIOR: 0.4}},
		9:  {"count": 35, "health_multiplier": 5.9, "speed_multiplier": 1.7, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.THIEF: 0.2, EnemyManager.EnemyType.WIZARD: 0.3, EnemyManager.EnemyType.WARRIOR: 0.5}},
		10: {"count": 1, "health_multiplier": 15.2, "speed_multiplier": 1.75, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.CRAZYONE: 1.0}},
		11: {"count": 40, "health_multiplier": 6.5, "speed_multiplier": 1.8, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.THIEF: 0.2, EnemyManager.EnemyType.WIZARD: 0.3, EnemyManager.EnemyType.WARRIOR: 0.3, EnemyManager.EnemyType.WEREWOLF: 0.2}},
		12: {"count": 42, "health_multiplier": 6.8, "speed_multiplier": 1.85, "path_type": PathType.PATH_2, "enemy_mix": {EnemyManager.EnemyType.THIEF: 0.2, EnemyManager.EnemyType.WIZARD: 0.2, EnemyManager.EnemyType.WARRIOR: 0.3, EnemyManager.EnemyType.WEREWOLF: 0.3}},
		13: {"count": 45, "health_multiplier": 7.1, "speed_multiplier": 1.9, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.THIEF: 0.1, EnemyManager.EnemyType.WIZARD: 0.2, EnemyManager.EnemyType.WARRIOR: 0.3, EnemyManager.EnemyType.WEREWOLF: 0.4}},
		14: {"count": 48, "health_multiplier": 7.4, "speed_multiplier": 1.95, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.WIZARD: 0.2, EnemyManager.EnemyType.WARRIOR: 0.3, EnemyManager.EnemyType.WEREWOLF: 0.5}},
		15: {"count": 1, "health_multiplier": 40.7, "speed_multiplier": 2.0, "path_type": PathType.PATH_2, "enemy_mix": {EnemyManager.EnemyType.ORC: 1.0}},
		16: {"count": 55, "health_multiplier": 8.0, "speed_multiplier": 2.05, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.WIZARD: 0.2, EnemyManager.EnemyType.WARRIOR: 0.3, EnemyManager.EnemyType.WEREWOLF: 0.5}},
		17: {"count": 60, "health_multiplier": 8.5, "speed_multiplier": 2.1, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.WIZARD: 0.2, EnemyManager.EnemyType.WARRIOR: 0.2, EnemyManager.EnemyType.WEREWOLF: 0.6}},
		18: {"count": 65, "health_multiplier": 9.0, "speed_multiplier": 2.2, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.WIZARD: 0.1, EnemyManager.EnemyType.WARRIOR: 0.2, EnemyManager.EnemyType.WEREWOLF: 0.7}},
		19: {"count": 70, "health_multiplier": 9.5, "speed_multiplier": 2.3, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.WARRIOR: 0.2, EnemyManager.EnemyType.WEREWOLF: 0.8}},
		20: {"count": 1, "health_multiplier": 60.0, "speed_multiplier": 2.4, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.CRAZYONE: 1.0}},
		21: {"count": 80, "health_multiplier": 10.5, "speed_multiplier": 2.5, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.THIEF: 0.2, EnemyManager.EnemyType.WIZARD: 0.2, EnemyManager.EnemyType.WARRIOR: 0.3, EnemyManager.EnemyType.WEREWOLF: 0.3}},
		22: {"count": 90, "health_multiplier": 11.0, "speed_multiplier": 2.6, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 0.1, EnemyManager.EnemyType.THIEF: 0.2, EnemyManager.EnemyType.WIZARD: 0.2, EnemyManager.EnemyType.WARRIOR: 0.2, EnemyManager.EnemyType.WEREWOLF: 0.3}} # 最终混合波
	}
