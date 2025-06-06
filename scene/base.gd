extends Area2D

var max_health = 10
var current_health = max_health
var victory_screen = preload("res://scene/victory_screen.tscn")
var game_over_screen = preload("res://scene/game_over_screen.tscn") # 预加载失败界面

func _ready():
	$HealthBar.max_value = max_health
	$HealthBar.value = current_health
	# 设置血条颜色为淡红色
	$HealthBar.modulate = Color(1, 0.5, 0.5, 0.8)
	area_entered.connect(_on_area_entered)
	
	# 将基地添加到'base'组中，以便在其他脚本中能够获取
	add_to_group("base")

func _on_area_entered(area):
	if area.is_in_group("enemies"):
		take_damage(1)
		area.queue_free()

func take_damage(amount):
	current_health -= amount
	$HealthBar.value = current_health
	if current_health <= 0:
		# get_tree().reload_current_scene() # 不再重新加载场景
		var game_over_instance = game_over_screen.instantiate()
		get_tree().get_root().add_child(game_over_instance) # 显示失败界面
		get_tree().paused = true # 暂停游戏


signal victory_achieved

# 检查是否达到胜利条件
func check_victory(enemies_spawned: int, max_enemies: int) -> bool:
	if get_tree().get_nodes_in_group("enemies").size() == 0 and enemies_spawned >= max_enemies:
		victory_achieved.emit()
		return true
	return false
