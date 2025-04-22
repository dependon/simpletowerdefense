extends Control

# 在准备好时调用，初始化UI状态
func _ready():
	update_level_buttons()
	update_stars_display()

# 更新关卡按钮状态
func update_level_buttons():
	# 关卡1始终可用
	$HBoxContainer/Level1Container/Level1Button.disabled = false
	
	# 检查关卡2是否解锁
	$HBoxContainer/Level2Container/Level2Button.disabled = !GameManager.is_level_unlocked(2)
	
	# 检查关卡3是否解锁
	$HBoxContainer/Level3Container/Level3Button.disabled = !GameManager.is_level_unlocked(3)

# 更新星级显示
func update_stars_display():
	# 更新关卡1的星级
	var stars1 = GameManager.get_level_stars(1)
	for i in range(1, 4):
		$HBoxContainer/Level1Container/Level1Stars.get_node("Star" + str(i)).modulate = Color(1, 1, 1, 1) if i <= stars1 else Color(0.5, 0.5, 0.5, 0.5)
	
	# 更新关卡2的星级
	var stars2 = GameManager.get_level_stars(2)
	for i in range(1, 4):
		$HBoxContainer/Level2Container/Level2Stars.get_node("Star" + str(i)).modulate = Color(1, 1, 1, 1) if i <= stars2 else Color(0.5, 0.5, 0.5, 0.5)
	
	# 更新关卡3的星级
	var stars3 = GameManager.get_level_stars(3)
	for i in range(1, 4):
		$HBoxContainer/Level3Container/Level3Stars.get_node("Star" + str(i)).modulate = Color(1, 1, 1, 1) if i <= stars3 else Color(0.5, 0.5, 0.5, 0.5)

func _on_level1_button_pressed():
	GameManager.select_level(1)

func _on_level2_button_pressed():
	GameManager.select_level(2)

func _on_level_3_button_pressed() -> void:
	GameManager.select_level(3)
