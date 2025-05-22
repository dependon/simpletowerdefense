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
	
	# 检查关卡4是否解锁
	$HBoxContainer/Level4Container/Level4Button.disabled = !GameManager.is_level_unlocked(4)
	
	# 检查关卡5是否解锁
	$HBoxContainer/Level5Container/Level5Button.disabled = !GameManager.is_level_unlocked(5)
	
	# 检查关卡6是否解锁
	$HBoxContainer/Level6Container/Level6Button.disabled = !GameManager.is_level_unlocked(6)
	
	# 检查关卡7是否解锁
	$HBoxContainer/Level7Container/Level7Button.disabled = !GameManager.is_level_unlocked(7)
	
	# 检查关卡8是否解锁
	$HBoxContainer/Level8Container/Level8Button.disabled = !GameManager.is_level_unlocked(8)
	
	# 检查关卡9是否解锁
	$HBoxContainer/Level9Container/Level9Button.disabled = !GameManager.is_level_unlocked(9)
	
	# 检查关卡10是否解锁
	$HBoxContainer/Level10Container/Level10Button.disabled = !GameManager.is_level_unlocked(10)
	
	# 检查关卡11是否解锁
	$HBoxContainer/Level11Container/Level11Button.disabled = !GameManager.is_level_unlocked(11)

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
	
	# 更新关卡4的星级
	var stars4 = GameManager.get_level_stars(4)
	for i in range(1, 4):
		$HBoxContainer/Level4Container/Level4Stars.get_node("Star" + str(i)).modulate = Color(1, 1, 1, 1) if i <= stars4 else Color(0.5, 0.5, 0.5, 0.5)
	
	# 更新关卡5的星级
	var stars5 = GameManager.get_level_stars(5)
	for i in range(1, 4):
		$HBoxContainer/Level5Container/Level5Stars.get_node("Star" + str(i)).modulate = Color(1, 1, 1, 1) if i <= stars5 else Color(0.5, 0.5, 0.5, 0.5)
	
	# 更新关卡6的星级
	var stars6 = GameManager.get_level_stars(6)
	for i in range(1, 4):
		$HBoxContainer/Level6Container/Level6Stars.get_node("Star" + str(i)).modulate = Color(1, 1, 1, 1) if i <= stars6 else Color(0.5, 0.5, 0.5, 0.5)
	
	# 更新关卡7的星级
	var stars7 = GameManager.get_level_stars(7)
	for i in range(1, 4):
		$HBoxContainer/Level7Container/Level7Stars.get_node("Star" + str(i)).modulate = Color(1, 1, 1, 1) if i <= stars7 else Color(0.5, 0.5, 0.5, 0.5)
	
	# 更新关卡8的星级
	var stars8 = GameManager.get_level_stars(8)
	for i in range(1, 4):
		$HBoxContainer/Level8Container/Level8Stars.get_node("Star" + str(i)).modulate = Color(1, 1, 1, 1) if i <= stars8 else Color(0.5, 0.5, 0.5, 0.5)
	
	# 更新关卡9的星级
	var stars9 = GameManager.get_level_stars(9)
	for i in range(1, 4):
		$HBoxContainer/Level9Container/Level9Stars.get_node("Star" + str(i)).modulate = Color(1, 1, 1, 1) if i <= stars9 else Color(0.5, 0.5, 0.5, 0.5)
	
	# 更新关卡10的星级
	var stars10 = GameManager.get_level_stars(10)
	for i in range(1, 4):
		$HBoxContainer/Level10Container/Level10Stars.get_node("Star" + str(i)).modulate = Color(1, 1, 1, 1) if i <= stars10 else Color(0.5, 0.5, 0.5, 0.5)

	# 更新关卡11的星级
	var stars11 = GameManager.get_level_stars(11)
	for i in range(1, 4):
		$HBoxContainer/Level11Container/Level11Stars.get_node("Star" + str(i)).modulate = Color(1, 1, 1, 1) if i <= stars11 else Color(0.5, 0.5, 0.5, 0.5)

func _on_level1_button_pressed():
	GameManager.select_level(1)

func _on_level2_button_pressed():
	GameManager.select_level(2)

func _on_level_3_button_pressed() -> void:
	GameManager.select_level(3)

func _on_level4_button_pressed():
	GameManager.select_level(4)

func _on_level5_button_pressed():
	GameManager.select_level(5)

func _on_level6_button_pressed():
	GameManager.select_level(6)

func _on_level7_button_pressed():
	GameManager.select_level(7)

func _on_level8_button_pressed():
	GameManager.select_level(8)

func _on_level9_button_pressed():
	GameManager.select_level(9)

func _on_level10_button_pressed():
	GameManager.select_level(10)

func _on_level11_button_pressed():
	GameManager.select_level(11)

func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://scene/start_menu.tscn")
