extends Node2D

@onready var setting_menu = $UI/SettingMenu

func _on_setting_button_pressed():
	get_tree().paused = true
	setting_menu.show()
	
	setting_menu.resume_game.connect(resume_game)
	setting_menu.return_to_level_select.connect(return_to_level_select)
	setting_menu.return_to_start_menu.connect(return_to_start_menu)

func resume_game():
	get_tree().paused = false
	setting_menu.hide()

func return_to_level_select():
	setting_menu.hide()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scene/level_select.tscn")

func return_to_start_menu():
	setting_menu.hide()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scene/start_menu.tscn")

@onready var enemy_scene: PackedScene = preload("res://scene/enemy.tscn")
@onready var tower_scene: PackedScene = preload("res://scene/tower.tscn")
@onready var fast_tower_scene: PackedScene = preload("res://scene/fast_tower.tscn")
@onready var area_tower_scene: PackedScene = preload("res://scene/area_tower.tscn")
@onready var frost_tower_scene: PackedScene = preload("res://scene/frost_tower.tscn")
@onready var level1_scene: PackedScene = preload("res://scene/level1.tscn")
@onready var level2_scene: PackedScene = preload("res://scene/level2.tscn")
@onready var level3_scene: PackedScene = preload("res://scene/level3.tscn")

var current_tower_type = "normal"  # 可以是 "normal"、"fast"、"area" 或 "frost"
var current_level: Node2D = null
var current_level_path: Path2D = null



# 金币系统
var coins = 100  # 初始金币
const NORMAL_TOWER_COST = 50  # 普通塔消耗
const FAST_TOWER_COST = 100   # 快速塔消耗
const AREA_TOWER_COST = 150   # 群体塔消耗
const FROST_TOWER_COST = 100  # 冰霜塔消耗

# 金币UI和钻石UI
func update_coins_display():
	$UI/Coins.text = "金币: " + str(coins)

func update_diamonds_display():
	$UI/Diamonds.text = "钻石: " + str(GameManager.get_diamonds())

func _ready():
	# 设置金币和钻石显示
	update_coins_display()
	update_diamonds_display()
	
	# 连接GameManager的level_selected信号
	GameManager.level_selected.connect(load_level)
	
	load_level(GameManager.current_level)
	

func load_level(level_number: int):
	if current_level:
		current_level.queue_free()
	
	# 重置金币
	coins = 100
	update_coins_display()
	
	var level_scene
	if level_number == 1:
		level_scene = level1_scene
	elif level_number == 2:
		level_scene = level2_scene
	elif level_number == 3:
		level_scene = level3_scene
	current_level = level_scene.instantiate()
	
	add_child(current_level)
	current_level_path = current_level.get_node("Path2D")


func _physics_process(delta):
	pass

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos = get_local_mouse_position()
		var build_points = get_tree().get_nodes_in_group("build_points")
		for point in build_points:
			if point.position.distance_to(mouse_pos) < 32:
				# 检查建造点是否已被占用
				if point.is_point_occupied():
					break
				var cost
				match current_tower_type:
					"normal": 
						cost = NORMAL_TOWER_COST
					"fast": 
						cost = FAST_TOWER_COST
					"frost": 
						cost = FROST_TOWER_COST
					_: 
						cost = AREA_TOWER_COST

				if coins >= cost:
					var tower
					match current_tower_type:
						"normal": 
							tower = tower_scene.instantiate()
						"fast": 
							tower = fast_tower_scene.instantiate()
						"frost": 
							tower = frost_tower_scene.instantiate()
						_: 
							tower = area_tower_scene.instantiate()
					
					tower.position = point.position
					tower.set_z_index(3)

					add_child(tower)
					point.set_occupied(true)
					coins -= cost
					update_coins_display()
				break

func _on_normal_tower_button_pressed():
	current_tower_type = "normal"

func _on_fast_tower_button_pressed():
	current_tower_type = "fast"

func _on_area_tower_button_pressed():
	current_tower_type = "area"

func switch_to_level(level_number: int):
	load_level(level_number)


func _on_frost_tower_button_2_pressed() -> void:
	current_tower_type = "frost"
