extends Node2D

@onready var base = $Base
var enemy_count = 0
var total_enemies = 20  # 第一关的敌人总数
var level_completed = false

func _ready():
	# 监听敌人被销毁的信号
	get_tree().get_root().get_node("Main").enemy_spawn_timer = 0

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
		victory_label.text = "第一关通关！"
		victory_label.position = Vector2(500, 300)
		add_child(victory_label)
		
		# 3秒后加载下一关
		await get_tree().create_timer(3.0).timeout
		get_tree().get_root().get_node("Main").load_level(2)
