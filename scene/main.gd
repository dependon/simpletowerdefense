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

func _ready():
	enemy_spawn_interval = 2
	load_level(1)

func load_level(level_number: int):
	if current_level:
		current_level.queue_free()
	
	var level_scene = level1_scene if level_number == 1 else level2_scene
	current_level = level_scene.instantiate()
	add_child(current_level)
	current_level_path = current_level.get_node("Path2D")

	# 设置敌人生成点位置
	var spawn_point = current_level.get_node("SpawnPoint")
	if spawn_point:
		current_level_path.curve.add_point(spawn_point.position)

	# 根据关卡设置不同的路径点
	if level_number == 1:
		current_level_path.curve.add_point(Vector2(300, 300))
		current_level_path.curve.add_point(Vector2(500, 300))
		current_level_path.curve.add_point(Vector2(700, 300))
		current_level_path.curve.add_point(Vector2(900, 300))
	else:
		current_level_path.curve.add_point(Vector2(200, 100))
		current_level_path.curve.add_point(Vector2(200, 300))
		current_level_path.curve.add_point(Vector2(400, 300))
		current_level_path.curve.add_point(Vector2(400, 500))
		current_level_path.curve.add_point(Vector2(800, 500))

func _physics_process(delta):
	enemy_spawn_timer += delta
	if enemy_spawn_timer >= enemy_spawn_interval:
		var enemy = enemy_scene.instantiate()
		enemy.set_path(current_level_path.curve)
		add_child(enemy)
		enemy.add_to_group("enemies")
		enemy_spawn_timer = 0

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var tower
		if current_tower_type == "normal":
			tower = tower_scene.instantiate()
		else:
			tower = fast_tower_scene.instantiate()
		tower.position = get_local_mouse_position()
		add_child(tower)

func _on_normal_tower_button_pressed():
	current_tower_type = "normal"

func _on_fast_tower_button_pressed():
	current_tower_type = "fast"

func switch_to_level(level_number: int):
	load_level(level_number)
