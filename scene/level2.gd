extends Node2D

@onready var base = $Base
@export var enemy_count = 0
@export var total_enemies = 15  # 第二关的敌人总数
@export var level_completed = false
@export var enemy_spawn_interval = 1.5  # 敌人生成间隔
@export var min_spawn_interval = 0.3  # 最小生成间隔
@export var spawn_interval_decrease = 0.15  # 每生成一个敌人减少的间隔时间
@export var enemies_spawned = 0  # 已生成的敌人数量
@export var enemy_health : float = 1.05  # 怪物的初始血量倍率

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

	# 每秒检查胜利条件
	var timer = Timer.new()
	timer.wait_time = 1.0
	timer.timeout.connect(_check_victory_condition)
	add_child(timer)
	timer.start()

func _check_victory_condition():
	if level_completed:
		return
	
	# 获取当前存活的敌人数量
	enemy_count = get_tree().get_nodes_in_group("enemies").size()
	
	# 检查是否所有敌人都被消灭且基地存活
	if enemy_count == 0 and base.current_health > 0:
		level_completed = true
		# 显示胜利消息
		var victory_label = Label.new()
		victory_label.text = "第二关通关！"
		victory_label.position = Vector2(500, 300)
		add_child(victory_label)
		
		# 3秒后加载下一关
		await get_tree().create_timer(3.0).timeout
		get_tree().get_root().get_node("Main").load_level(3)