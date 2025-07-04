extends Control

# 关于界面脚本

func _ready() -> void:
	# 设置UI元素国际化文本
	_update_ui_texts()
	
	# 连接语言改变信号
	SettingsManager.language_changed.connect(_on_language_changed)

func _update_ui_texts():
	"""更新UI文本"""
	$BackgroundPanel/MainContainer/TitleLabel.text = tr("ABOUT_GAME")
	$BackgroundPanel/MainContainer/ScrollContainer/ContentContainer/AuthorLabel.text = tr("AUTHOR")
	$BackgroundPanel/MainContainer/ScrollContainer/ContentContainer/GithubLabel.text = tr("GITHUB_PAGE") + ":[url=https://github.com/dependon/simpletowerdefense]https://github.com/dependon/simpletowerdefense[/url]"
	$BackgroundPanel/MainContainer/ScrollContainer/ContentContainer/BilibiliLabel.text = tr("BILIBILI_ADDRESS") + ": [url=https://space.bilibili.com/144159485]https://space.bilibili.com/144159485[/url]"
	$BackgroundPanel/MainContainer/ScrollContainer/ContentContainer/DouyinLabel.text = tr("DOUYIN_ID")
	$BackgroundPanel/MainContainer/ScrollContainer/ContentContainer/EmailLabel.text = tr("EMAIL") + ":[url=mailto:liuminghang0821@gmail.com]liuminghang0821@gmail.com[/url]"
	$BackgroundPanel/MainContainer/ScrollContainer/ContentContainer/ProjectInfoLabel.text = tr("PROJECT_INFO")
	$BackgroundPanel/MainContainer/ScrollContainer/ContentContainer/ThanksLabel.text = tr("THANKS_MESSAGE")
	$BackgroundPanel/MainContainer/BackButton.text = tr("BACK_TO_MAIN_MENU")

func _on_language_changed(_new_language: String):
	"""语言改变时更新UI文本"""
	_update_ui_texts()

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
