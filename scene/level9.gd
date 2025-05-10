extends LevelBase

func _ready():
	# 波次设置 (Level 9) - 难度提升
	total_waves = 30  # 总波次数增加
	wave_interval = 20 # 波次间隔缩短
	enemy_spawn_interval = 0.2 # 生成间隔缩短
	wave_duration_limit = 85.0 # 持续时间限制略微增加以容纳更多敌人

	wave_config = {
		# 前期: 混合多种类型，战士和狼人比例逐渐增加
		1:  {"count": 20, "health_multiplier": 6.0, "speed_multiplier": 1.5, "path_type": PathType.PATH_1, "enemy_mix": {EnemyType.NORMAL: 0.4, EnemyType.THIEF: 0.3, EnemyType.WIZARD: 0.3}},
		2:  {"count": 22, "health_multiplier": 6.2, "speed_multiplier": 1.55, "path_type": PathType.PATH_2, "enemy_mix": {EnemyType.NORMAL: 0.3, EnemyType.THIEF: 0.3, EnemyType.WIZARD: 0.2, EnemyType.WARRIOR: 0.2}},
		3:  {"count": 25, "health_multiplier": 6.4, "speed_multiplier": 1.6, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.NORMAL: 0.2, EnemyType.THIEF: 0.2, EnemyType.WIZARD: 0.3, EnemyType.WARRIOR: 0.3}},
		4:  {"count": 28, "health_multiplier": 6.6, "speed_multiplier": 1.65, "path_type": PathType.PATH_1, "enemy_mix": {EnemyType.THIEF: 0.3, EnemyType.WIZARD: 0.3, EnemyType.WARRIOR: 0.3, EnemyType.WEREWOLF: 0.1}},
		5:  {"count": 30, "health_multiplier": 6.8, "speed_multiplier": 1.7, "path_type": PathType.PATH_2, "enemy_mix": {EnemyType.THIEF: 0.2, EnemyType.WIZARD: 0.2, EnemyType.WARRIOR: 0.4, EnemyType.WEREWOLF: 0.2}},
		# 中期: 狼人成为主力，配合巫师和战士
		6:  {"count": 33, "health_multiplier": 7.0, "speed_multiplier": 1.75, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.WIZARD: 0.3, EnemyType.WARRIOR: 0.3, EnemyType.WEREWOLF: 0.4}},
		7:  {"count": 36, "health_multiplier": 7.3, "speed_multiplier": 1.8, "path_type": PathType.PATH_1, "enemy_mix": {EnemyType.WIZARD: 0.2, EnemyType.WARRIOR: 0.3, EnemyType.WEREWOLF: 0.5}},
		8:  {"count": 39, "health_multiplier": 7.6, "speed_multiplier": 1.85, "path_type": PathType.PATH_2, "enemy_mix": {EnemyType.WIZARD: 0.2, EnemyType.WARRIOR: 0.2, EnemyType.WEREWOLF: 0.6}},
		9:  {"count": 42, "health_multiplier": 7.9, "speed_multiplier": 1.9, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.WARRIOR: 0.3, EnemyType.WEREWOLF: 0.7}},
		10: {"count": 45, "health_multiplier": 8.2, "speed_multiplier": 1.95, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.WARRIOR: 0.2, EnemyType.WEREWOLF: 0.8}},
		11: {"count": 47, "health_multiplier": 8.4, "speed_multiplier": 1.98, "path_type": PathType.PATH_1, "enemy_mix": {EnemyType.WARRIOR: 0.15, EnemyType.WEREWOLF: 0.85}},
		12: {"count": 50, "health_multiplier": 8.7, "speed_multiplier": 2.02, "path_type": PathType.PATH_2, "enemy_mix": {EnemyType.WIZARD: 0.15, EnemyType.WEREWOLF: 0.85}},
		13: {"count": 53, "health_multiplier": 9.0, "speed_multiplier": 2.06, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.WEREWOLF: 0.9, EnemyType.WARRIOR: 0.1}},
		14: {"count": 56, "health_multiplier": 9.3, "speed_multiplier": 2.1, "path_type": PathType.PATH_1, "enemy_mix": {EnemyType.WARRIOR: 0.25, EnemyType.WEREWOLF: 0.75}},
		15: {"count": 59, "health_multiplier": 9.6, "speed_multiplier": 2.14, "path_type": PathType.PATH_2, "enemy_mix": {EnemyType.WIZARD: 0.25, EnemyType.WEREWOLF: 0.75}},
		16: {"count": 62, "health_multiplier": 9.9, "speed_multiplier": 2.18, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.WARRIOR: 0.15, EnemyType.WIZARD: 0.15, EnemyType.WEREWOLF: 0.7}},
		17: {"count": 65, "health_multiplier": 10.3, "speed_multiplier": 2.25, "path_type": PathType.PATH_1, "enemy_mix": {EnemyType.WEREWOLF: 0.95, EnemyType.THIEF: 0.05}},
		18: {"count": 67, "health_multiplier": 10.8, "speed_multiplier": 2.35, "path_type": PathType.PATH_2, "enemy_mix": {EnemyType.WARRIOR: 0.45, EnemyType.WEREWOLF: 0.55}},
		19: {"count": 68, "health_multiplier": 11.3, "speed_multiplier": 2.45, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.WIZARD: 0.45, EnemyType.WEREWOLF: 0.55}},
		20: {"count": 69, "health_multiplier": 11.8, "speed_multiplier": 2.55, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.WIZARD: 0.35, EnemyType.WARRIOR: 0.35, EnemyType.WEREWOLF: 0.3}},
		21: {"count": 70, "health_multiplier": 12.0, "speed_multiplier": 2.6, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.WIZARD: 0.3, EnemyType.WARRIOR: 0.3, EnemyType.WEREWOLF: 0.4}},
		22: {"count": 75, "health_multiplier": 12.5, "speed_multiplier": 2.7, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.WIZARD: 0.2, EnemyType.WARRIOR: 0.2, EnemyType.WEREWOLF: 0.6}},
		23: {"count": 80, "health_multiplier": 13.0, "speed_multiplier": 2.8, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.WARRIOR: 0.3, EnemyType.WEREWOLF: 0.7}},
		24: {"count": 85, "health_multiplier": 13.5, "speed_multiplier": 2.9, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.WARRIOR: 0.2, EnemyType.WEREWOLF: 0.8}},
		25: {"count": 90, "health_multiplier": 14.0, "speed_multiplier": 3.0, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.WEREWOLF: 1.0}}, # 纯狼人波
		26: {"count": 95, "health_multiplier": 14.5, "speed_multiplier": 3.1, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.WIZARD: 0.5, EnemyType.WEREWOLF: 0.5}}, # 巫师+狼人
		27: {"count": 100, "health_multiplier": 15.0, "speed_multiplier": 3.2, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.WARRIOR: 0.5, EnemyType.WEREWOLF: 0.5}}, # 战士+狼人
		28: {"count": 105, "health_multiplier": 15.5, "speed_multiplier": 3.3, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.THIEF: 0.3, EnemyType.WARRIOR: 0.3, EnemyType.WEREWOLF: 0.4}},
		29: {"count": 110, "health_multiplier": 16.0, "speed_multiplier": 3.4, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.WIZARD: 0.2, EnemyType.WARRIOR: 0.3, EnemyType.WEREWOLF: 0.5}},
		30: {"count": 130, "health_multiplier": 17.0, "speed_multiplier": 3.5, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyType.NORMAL: 0.1, EnemyType.THIEF: 0.1, EnemyType.WIZARD: 0.2, EnemyType.WARRIOR: 0.3, EnemyType.WEREWOLF: 0.3}} # 最终大混合
	}

	startCurrentGame();
