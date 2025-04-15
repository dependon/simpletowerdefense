extends Node2D

@onready var enemy_scene: PackedScene = preload("res://scene/enemy.tscn")
@onready var tower_scene: PackedScene = preload("res://scene/tower.tscn")
@onready var fast_tower_scene: PackedScene = preload("res://scene/fast_tower.tscn")
@onready var level1_scene: PackedScene = preload("res://scene/level1.tscn")
@onready var level2_scene: PackedScene = preload("res://scene/level2.tscn")

var current_tower_type = "normal"  # 可以是 "normal" 或 "fast"
var current_level: Node2D = null
var current_level_path: Path2D = null

var enemy_spawn_timer = 0
@export var enemy_spawn_interval = 2
@export var min_spawn_interval = 0.3  # 最小生成间隔
@export var spawn_interval_decrease = 0.05  # 每生成一个敌人减少的间隔时间
var enemies_spawned = 0  # 已生成的敌人数量
var max_enemies = 10  # 每关的最大敌人数量

var isvictory = false

# 金币系统
var coins = 100  # 初始金币
const NORMAL_TOWER_COST = 50  # 普通塔消耗
const FAST_TOWER_COST = 100   # 快速塔消耗

# 金币UI

func update_coins_display():
	$UI/Coins.text = "金币: " + str(coins)

func _ready():
	enemy_spawn_interval = 2
	
	# 设置金币显示
	update_coins_display()
	
	# 连接GameManager的level_selected信号
	GameManager.level_selected.connect(load_level)
	
	load_level(GameManager.current_level)

func load_level(level_number: int):
	isvictory = false;
	if current_level:
		current_level.queue_free()
	
	# 重置金币
	coins = 100
	update_coins_display()
	
	var level_scene = level1_scene if level_number == 1 else level2_scene
	current_level = level_scene.instantiate()
	add_child(current_level)
	current_level_path = current_level.get_node("Path2D")

	# 设置敌人生成点位置
	var spawn_point = current_level.get_node("SpawnPoint")
	if spawn_point:
		current_level_path.curve.add_point(spawn_point.position)

func _physics_process(delta):
	enemy_spawn_timer += delta
	if current_level_path and enemy_spawn_timer >= enemy_spawn_interval and enemies_spawned < max_enemies:
		var enemy = enemy_scene.instantiate()
		enemy.set_path(current_level_path.curve)
		add_child(enemy)
		enemy.add_to_group("enemies")
		enemy_spawn_timer = 0
		enemies_spawned += 1
		# 减少生成间隔，但不低于最小间隔
		enemy_spawn_interval = max(min_spawn_interval, enemy_spawn_interval - spawn_interval_decrease)
	
	# 检查胜利条件
	if current_level:
		var base = current_level.get_node("Base")
		if !isvictory and base and base.check_victory(enemies_spawned, max_enemies):
			var victory = preload("res://scene/victory_screen.tscn").instantiate()
			get_tree().root.add_child(victory)
			isvictory = true;

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos = get_local_mouse_position()
		var build_points = get_tree().get_nodes_in_group("build_points")
		for point in build_points:
			if point.position.distance_to(mouse_pos) < 32:
				# 检查建造点是否已被占用
				if point.is_point_occupied():
					break
				
				var cost = NORMAL_TOWER_COST if current_tower_type == "normal" else FAST_TOWER_COST
				if coins >= cost:
					var tower
					if current_tower_type == "normal":
						tower = tower_scene.instantiate()
					else:
						tower = fast_tower_scene.instantiate()
					tower.position = point.position
					add_child(tower)
					point.set_occupied(true)
					coins -= cost
					update_coins_display()
				break

func _on_normal_tower_button_pressed():
	current_tower_type = "normal"

func _on_fast_tower_button_pressed():
	current_tower_type = "fast"

func switch_to_level(level_number: int):
	load_level(level_number)
