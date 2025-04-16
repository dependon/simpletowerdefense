extends Node2D

@onready var base = $Base
@onready var enemy_scene = preload("res://scene/enemy.tscn")
@onready var path = $Path2D

@export var total_enemies = 20  # 第一关的敌人总数
@export var enemy_spawn_interval = 2.0  # 敌人生成间隔
@export var min_spawn_interval = 0.3  # 最小生成间隔
@export var spawn_interval_decrease = 0.1  # 每生成一个敌人减少的间隔时间
@export var enemy_health : float = 1.00  # 怪物的初始血量倍率

var enemy_spawn_timer = 0
var enemies_spawned = 0  # 已生成的敌人数量
var is_victory = false

func _ready():
	# 设置敌人生成点位置
	var spawn_point = $SpawnPoint
	if spawn_point:
		path.curve.add_point(spawn_point.position)


func _physics_process(delta):
	enemy_spawn_timer += delta
	if enemy_spawn_timer >= enemy_spawn_interval and enemies_spawned < total_enemies:
		var enemy = enemy_scene.instantiate()
		enemy.set_path(path.curve)
		enemy.hp = enemy.hp * enemy_health  # 设置怪物的血量
		add_child(enemy)
		enemy.add_to_group("enemies")
		enemy_spawn_timer = 0
		enemies_spawned += 1
		# 减少生成间隔，但不低于最小间隔
		enemy_spawn_interval = max(min_spawn_interval, enemy_spawn_interval - spawn_interval_decrease)
	
	# 检查胜利条件
	if !is_victory and base and base.check_victory(enemies_spawned, total_enemies):
		var victory = preload("res://scene/victory_screen.tscn").instantiate()
		get_tree().root.add_child(victory)
		is_victory = true
