extends LevelBase


func _ready():

	total_waves = 30  # 最终关卡波数
	wave_interval = 20 # 波次间隔缩短
	enemy_spawn_interval = 0.18 # 生成间隔更短
	wave_duration_limit = 90.0 # 持续时间限制更长

	# 失败条件：场上怪物数量上100
	MAX_ENEMIES_ON_FIELD = 100
	#level 10极高难度
	wave_config = {
	# 前期: 混合多种类型，战士和狼人比例逐渐增加
		1:  {"count": 20, "health_multiplier": 1.0, "speed_multiplier": 1.2, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 0.4, EnemyManager.EnemyType.THIEF: 0.3, EnemyManager.EnemyType.WIZARD: 0.3}},
		2:  {"count": 22, "health_multiplier": 1.5, "speed_multiplier": 1.3, "path_type": PathType.PATH_2, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 0.3, EnemyManager.EnemyType.THIEF: 0.3, EnemyManager.EnemyType.WIZARD: 0.2, EnemyManager.EnemyType.WARRIOR: 0.2}},
		3:  {"count": 25, "health_multiplier": 3.0, "speed_multiplier": 1.4, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.NORMAL: 0.2, EnemyManager.EnemyType.THIEF: 0.2, EnemyManager.EnemyType.WIZARD: 0.3, EnemyManager.EnemyType.WARRIOR: 0.3}},
		4:  {"count": 28, "health_multiplier": 4.0, "speed_multiplier": 1.5, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.THIEF: 0.3, EnemyManager.EnemyType.WIZARD: 0.3, EnemyManager.EnemyType.WARRIOR: 0.3, EnemyManager.EnemyType.WEREWOLF: 0.1}},
		5:  {"count": 1, "health_multiplier": 5.0, "speed_multiplier": 1.7, "path_type": PathType.PATH_2, "enemy_mix": {EnemyManager.EnemyType.ORC: 1.0}},
		# 中期: 狼人成为主力，配合巫师和战士
		6:  {"count": 33, "health_multiplier": 6.0, "speed_multiplier": 1.75, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.WIZARD: 0.3, EnemyManager.EnemyType.WARRIOR: 0.3, EnemyManager.EnemyType.WEREWOLF: 0.4}},
		7:  {"count": 36, "health_multiplier": 7.3, "speed_multiplier": 1.8, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.WIZARD: 0.2, EnemyManager.EnemyType.WARRIOR: 0.3, EnemyManager.EnemyType.WEREWOLF: 0.5}},
		8:  {"count": 39, "health_multiplier": 7.6, "speed_multiplier": 1.85, "path_type": PathType.PATH_2, "enemy_mix": {EnemyManager.EnemyType.WIZARD: 0.2, EnemyManager.EnemyType.WARRIOR: 0.2, EnemyManager.EnemyType.WEREWOLF: 0.6}},
		9:  {"count": 42, "health_multiplier": 7.9, "speed_multiplier": 1.9, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.WARRIOR: 0.3, EnemyManager.EnemyType.WEREWOLF: 0.7}},
		10: {"count": 1, "health_multiplier": 8.2, "speed_multiplier": 1.95, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.CRAZYONE: 1.0}},
		11: {"count": 48, "health_multiplier": 8.5, "speed_multiplier": 2.0, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.WARRIOR: 0.1, EnemyManager.EnemyType.WEREWOLF: 0.9}},
		12: {"count": 51, "health_multiplier": 8.8, "speed_multiplier": 2.05, "path_type": PathType.PATH_2, "enemy_mix": {EnemyManager.EnemyType.WIZARD: 0.1, EnemyManager.EnemyType.WEREWOLF: 0.9}},
		13: {"count": 54, "health_multiplier": 9.1, "speed_multiplier": 2.1, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.WEREWOLF: 1.0}}, # 纯狼人波
		14: {"count": 57, "health_multiplier": 9.4, "speed_multiplier": 2.15, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.WARRIOR: 0.2, EnemyManager.EnemyType.WEREWOLF: 0.8}},
		15: {"count": 1, "health_multiplier": 9.7, "speed_multiplier": 2.2, "path_type": PathType.PATH_2, "enemy_mix": {EnemyManager.EnemyType.ORC: 1.0}},
		16: {"count": 63, "health_multiplier": 10.0, "speed_multiplier": 2.25, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.WARRIOR: 0.1, EnemyManager.EnemyType.WIZARD: 0.1, EnemyManager.EnemyType.WEREWOLF: 0.8}},
		17: {"count": 66, "health_multiplier": 10.5, "speed_multiplier": 2.35, "path_type": PathType.PATH_1, "enemy_mix": {EnemyManager.EnemyType.WEREWOLF: 1.0}}, # 纯狼人波
		18: {"count": 68, "health_multiplier": 11.0, "speed_multiplier": 2.45, "path_type": PathType.PATH_2, "enemy_mix": {EnemyManager.EnemyType.WARRIOR: 0.4, EnemyManager.EnemyType.WEREWOLF: 0.6}},
		19: {"count": 69, "health_multiplier": 11.5, "speed_multiplier": 2.55, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.WIZARD: 0.4, EnemyManager.EnemyType.WEREWOLF: 0.6}},
		20: {"count": 1, "health_multiplier": 12.0, "speed_multiplier": 2.6, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.CRAZYONE: 1.0}},
		21: {"count": 70, "health_multiplier": 12.0, "speed_multiplier": 2.6, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.WIZARD: 0.3, EnemyManager.EnemyType.WARRIOR: 0.3, EnemyManager.EnemyType.WEREWOLF: 0.4}},
		22: {"count": 75, "health_multiplier": 12.5, "speed_multiplier": 2.7, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.WIZARD: 0.2, EnemyManager.EnemyType.WARRIOR: 0.2, EnemyManager.EnemyType.WEREWOLF: 0.6}},
		23: {"count": 80, "health_multiplier": 13.0, "speed_multiplier": 2.8, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.WARRIOR: 0.3, EnemyManager.EnemyType.WEREWOLF: 0.7}},
		24: {"count": 85, "health_multiplier": 13.5, "speed_multiplier": 2.9, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.WARRIOR: 0.2, EnemyManager.EnemyType.WEREWOLF: 0.8}},
		25: {"count": 1, "health_multiplier": 14.0, "speed_multiplier": 3.0, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.ORC: 1.0}},
		26: {"count": 95, "health_multiplier": 14.5, "speed_multiplier": 3.1, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.WIZARD: 0.5, EnemyManager.EnemyType.WEREWOLF: 0.5}}, # 巫师+狼人
		27: {"count": 100, "health_multiplier": 15.0, "speed_multiplier": 3.2, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.WARRIOR: 0.5, EnemyManager.EnemyType.WEREWOLF: 0.5}}, # 战士+狼人
		28: {"count": 105, "health_multiplier": 15.5, "speed_multiplier": 3.3, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.THIEF: 0.3, EnemyManager.EnemyType.WARRIOR: 0.3, EnemyManager.EnemyType.WEREWOLF: 0.4}},
		29: {"count": 110, "health_multiplier": 16.0, "speed_multiplier": 3.4, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.WIZARD: 0.2, EnemyManager.EnemyType.WARRIOR: 0.3, EnemyManager.EnemyType.WEREWOLF: 0.5}},
		30: {"count": 1, "health_multiplier": 17.0, "speed_multiplier": 3.5, "path_type": PathType.BOTH_PATHS, "enemy_mix": {EnemyManager.EnemyType.CRAZYONE: 1.0}}
	}
