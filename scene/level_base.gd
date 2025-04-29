class_name LevelBase
extends Node2D

# 波次路径类型枚举
enum PathType {
	PATH_1,
	PATH_2,
	BOTH_PATHS
}

# 敌人类型枚举
enum EnemyType {
	NORMAL,
	THIEF,
	WIZARD,
	WARRIOR,
	WEREWOLF
}

# 新增：定义波次更新信号
signal wave_updated(current_wave, total_waves)

@onready var base = $Base # 基地仍然需要，用于扣血
@onready var enemy_scene = preload("res://scene/enemy.tscn")
@onready var thief_scene = preload("res://scene/enemy_thief.tscn") 
@onready var enemy_wizard = preload("res://scene/enemy_wizard.tscn") 
@onready var enemy_warrior = preload("res://scene/enemy_warrior.tscn") 
@onready var enemy_werewolf = preload("res://scene/enemy_werewolf.tscn")

@onready var path = $Path2D
@onready var path1 = $Path2D
@onready var path2 = $Path2D_2

# 波次配置字典: {wave_number: {"count": enemy_count, "health_multiplier": multiplier, "speed_multiplier": multiplier}}
# 怪物数量从少到多，血量和速度倍率逐渐增加
var wave_config = {
	1: {"count": 5, "health_multiplier": 1.0, "speed_multiplier": 1.0},
	2: {"count": 8, "health_multiplier": 1.1, "speed_multiplier": 1.0},
	3: {"count": 10, "health_multiplier": 1.2, "speed_multiplier": 1.05},
	4: {"count": 12, "health_multiplier": 1.3, "speed_multiplier": 1.05},
	5: {"count": 15, "health_multiplier": 1.5, "speed_multiplier": 1.1},
	6: {"count": 18, "health_multiplier": 1.7, "speed_multiplier": 1.1},
	7: {"count": 20, "health_multiplier": 1.9, "speed_multiplier": 1.15},
	8: {"count": 22, "health_multiplier": 2.1, "speed_multiplier": 1.15},
	9: {"count": 25, "health_multiplier": 2.3, "speed_multiplier": 1.2},
	10: {"count": 30, "health_multiplier": 2.5, "speed_multiplier": 1.2}
}

# 波次设置
@export var total_waves = 10  # 总波次数
@export var wave_interval = 5.0 # 波次之间的间隔时间 (秒)
@export var enemy_spawn_interval = 0.5 # 波次内敌人生成间隔 (秒)
@onready var wave_duration_limit = 60.0 # 每波持续时间限制 (秒)
@onready var wave_duration_timer = 0.0 # 波次持续时间计时器
# 状态变量
var current_wave = 0
var enemies_spawned_in_wave = 0
var wave_timer = 0.0 # 波次间隔计时器
var enemy_spawn_timer = 0.0 # 波次内生成计时器
var is_spawning_wave = false # 是否正在生成当前波次的敌人
var is_between_waves = true # 是否处于波次间隔 (初始为true，等待第一个间隔)
var is_victory = false #是否胜利
var current_path_type #当前路径

# 记录同时生成时两条路径分别生成的敌人数量
var path1_spawned = 0
var path2_spawned = 0

# 新增：获取当前波次信息的方法
func get_wave_info() -> Dictionary:
	emit_signal("wave_updated", current_wave , total_waves)
	return {"current": current_wave, "total": total_waves}

func _ready() -> void:
	# 设置敌人生成点位置
	var spawn_point = $SpawnPoint
	if spawn_point:
		path.curve.add_point(spawn_point.position)
	# 游戏开始时，立即开始第一波
	is_between_waves = false # 不处于间隔状态

func trigger_victory() -> void:
	if is_victory: # 防止重复触发
		return
	print("Victory!")
	var victory_screen = preload("res://scene/victory_screen.tscn").instantiate()
	get_tree().root.add_child(victory_screen)
	is_victory = true
	# 可以选择暂停游戏或进行其他胜利处理
	# get_tree().paused = true
