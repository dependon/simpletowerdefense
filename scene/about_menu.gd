extends Control

# 关于界面脚本

func _ready() -> void:
	# 初始化界面
	pass

func _on_back_button_pressed() -> void:
	# 返回主菜单
	get_tree().change_scene_to_file("res://scene/start_menu.tscn")

func _on_link_clicked(meta: Variant) -> void:
	# 处理链接点击事件
	if meta is String:
		var url = meta as String
		print("打开链接: ", url)
		# 在不同平台打开链接
		if OS.get_name() == "Windows":
			OS.shell_open(url)
		elif OS.get_name() == "Linux":
			OS.shell_open(url)
		elif OS.get_name() == "macOS":
			OS.shell_open(url)
		else:
			# 对于其他平台（如移动设备），也尝试打开
			OS.shell_open(url)