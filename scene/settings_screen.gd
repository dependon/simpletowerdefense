extends Control

# 分辨率选项
var resolution_options = [
	{"name": "2560x1440", "width": 2560, "height": 1440},
	{"name": "1920x1080", "width": 1920, "height": 1080},
	{"name": "1600x900", "width": 1600, "height": 900},
	{"name": "1366x768", "width": 1366, "height": 768},
	{"name": "1280x720", "width": 1280, "height": 720},
	{"name": "1024x576", "width": 1024, "height": 576}
]

# UI节点引用
@onready var resolution_option_button = $MainContainer/ResolutionContainer/ResolutionOptionButton
@onready var fullscreen_checkbox = $MainContainer/FullscreenContainer/FullscreenCheckBox
@onready var language_option_button = $MainContainer/LanguageContainer/LanguageOptionButton
@onready var master_volume_slider = $MainContainer/VolumeContainer/MasterVolumeContainer/MasterVolumeSlider
@onready var master_volume_label = $MainContainer/VolumeContainer/MasterVolumeContainer/MasterVolumeLabel
@onready var bgm_checkbox = $MainContainer/VolumeContainer/BGMContainer/BGMCheckBox

# 当前设置
var current_resolution_index = 0
var current_fullscreen = false
var current_language = "zh_CN"
var current_volume = 50.0
var current_bgm_enabled = true

func _ready():
	# 设置UI元素国际化文本
	_update_ui_texts()
	
	# 连接语言改变信号
	SettingsManager.language_changed.connect(_on_language_changed)
	
	# 初始化选项
	_setup_resolution_options()
	_setup_language_options()
	
	# 加载当前设置
	_load_current_settings()
	
	# 更新UI显示
	_update_ui()

func _update_ui_texts():
	"""更新UI文本"""
	$MainContainer/TitleLabel.text = tr("GAME_SETTINGS")
	$MainContainer/ResolutionContainer/ResolutionLabel.text = tr("RESOLUTION_SETTINGS")
	$MainContainer/FullscreenContainer/FullscreenLabel.text = tr("FULLSCREEN_MODE")
	$MainContainer/LanguageContainer/LanguageLabel.text = tr("LANGUAGE_SETTINGS")
	$MainContainer/VolumeContainer/VolumeLabel.text = tr("VOLUME_SETTINGS")
	$MainContainer/VolumeContainer/BGMContainer/BGMLabel.text = tr("BACKGROUND_MUSIC")
	$MainContainer/ButtonContainer/ApplyButton.text = tr("APPLY")
	$MainContainer/ButtonContainer/BackButton.text = tr("BACK")

func _setup_resolution_options():
	"""设置分辨率选项"""
	resolution_option_button.clear()
	for option in resolution_options:
		resolution_option_button.add_item(option.name)

func _setup_language_options():
	"""设置语言选项"""
	language_option_button.clear()
	var supported_languages = SettingsManager.get_supported_languages()
	for locale in supported_languages.keys():
		language_option_button.add_item(supported_languages[locale])

func _load_current_settings():
	"""加载当前设置"""
	# 从设置管理器获取当前设置
	var current_resolution = SettingsManager.get_current_resolution()
	
	# 查找匹配的分辨率选项
	for i in range(resolution_options.size()):
		var option = resolution_options[i]
		if option.width == current_resolution.x and option.height == current_resolution.y:
			current_resolution_index = i
			break
	
	# 获取全屏状态
	current_fullscreen = SettingsManager.is_fullscreen()
	
	# 获取语言设置
	current_language = SettingsManager.get_current_language()
	
	# 获取音量设置
	current_volume = SettingsManager.get_master_volume()
	
	# 获取背景音乐设置
	current_bgm_enabled = SettingsManager.is_bgm_enabled()

func _update_ui():
	"""更新UI显示"""
	resolution_option_button.selected = current_resolution_index
	fullscreen_checkbox.button_pressed = current_fullscreen
	
	# 设置语言选择
	var supported_languages = SettingsManager.get_supported_languages()
	var language_keys = supported_languages.keys()
	for i in range(language_keys.size()):
		if language_keys[i] == current_language:
			language_option_button.selected = i
			break
	
	master_volume_slider.value = current_volume
	bgm_checkbox.button_pressed = current_bgm_enabled
	_update_volume_label(current_volume)

func _update_volume_label(volume: float):
	"""更新音量标签显示"""
	master_volume_label.text = tr("MASTER_VOLUME") + ": %d%%" % int(volume)

func _on_resolution_option_button_item_selected(index: int):
	"""分辨率选项改变"""
	current_resolution_index = index

func _on_fullscreen_check_box_toggled(toggled_on: bool):
	"""全屏模式切换"""
	current_fullscreen = toggled_on

func _on_language_option_button_item_selected(index: int):
	"""语言选项改变"""
	var supported_languages = SettingsManager.get_supported_languages()
	var language_keys = supported_languages.keys()
	current_language = language_keys[index]

func _on_master_volume_slider_value_changed(value: float):
	"""音量滑块改变"""
	current_volume = value
	_update_volume_label(value)
	
	# 实时更新音量
	var master_bus_index = AudioServer.get_bus_index("Master")
	var volume_db = linear_to_db(value / 100.0)
	AudioServer.set_bus_volume_db(master_bus_index, volume_db)

func _on_bgm_check_box_toggled(toggled_on: bool):
	"""背景音乐开关切换"""
	current_bgm_enabled = toggled_on

func _on_apply_button_pressed():
	"""应用设置"""
	var selected_resolution = resolution_options[current_resolution_index]
	
	# 通过设置管理器更新设置
	SettingsManager.update_resolution(selected_resolution.width, selected_resolution.height, current_fullscreen)
	SettingsManager.update_language(current_language)
	SettingsManager.update_volume(current_volume)
	SettingsManager.update_bgm_enabled(current_bgm_enabled)
	
	# 更新UI文本（语言可能已改变）
	_update_ui_texts()
	_update_volume_label(current_volume)
	
	# 显示应用成功提示
	print("设置已应用")

func _on_back_button_pressed():
	"""返回主菜单"""
	hide()

# 这些函数已经由SettingsManager处理，不再需要

func show_settings():
	"""显示设置界面"""
	_load_current_settings()
	_update_ui()
	_update_ui_texts()  # 确保文本是最新的
	show()

func _on_language_changed(_new_language: String):
	"""语言改变时更新UI文本"""
	_update_ui_texts()
	_update_volume_label(current_volume)
