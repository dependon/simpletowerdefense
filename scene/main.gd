extends Node2D

@onready var enemy_scene: PackedScene = preload("res://scene/enemy.tscn")
@onready var tower_scene: PackedScene = preload("res://scene/tower.tscn")
@onready var fast_tower_scene: PackedScene = preload("res://scene/fast_tower.tscn")

var current_tower_type = "normal"  # 可以是 "normal" 或 "fast"

var enemy_spawn_timer = 0
@export var enemy_spawn_interval = 2

func _physics_process(delta):
	enemy_spawn_timer += delta
	if enemy_spawn_timer >= enemy_spawn_interval:
		var enemy = enemy_scene.instantiate()
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
