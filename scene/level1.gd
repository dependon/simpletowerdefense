extends Node2D

@onready var base = $Base
@export var enemy_count = 0
@export var total_enemies = 10  # 第一关的敌人总数
@export var level_completed = false
@export var enemy_spawn_interval = 2.0  # 敌人生成间隔
@export var min_spawn_interval = 0.5  # 最小生成间隔
@export var spawn_interval_decrease = 0.1  # 每生成一个敌人减少的间隔时间
@export var enemies_spawned = 0  # 已生成的敌人数量
@export var enemy_health : float = 1.00  # 怪物的初始血量倍率

func _ready():
	# 设置Main场景中的敌人生成参数
	var main = get_tree().get_root().get_node("Main")
	main.enemy_spawn_timer = 0
	main.enemy_spawn_interval = enemy_spawn_interval
	main.min_spawn_interval = min_spawn_interval
	main.spawn_interval_decrease = spawn_interval_decrease
	main.max_enemies = total_enemies
	main.enemies_spawned = 0
	main.enemy_health = enemy_health

	# 设置敌人计数
	enemy_count = get_tree().get_nodes_in_group("enemies").size()
