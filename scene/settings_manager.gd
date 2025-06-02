extends Node

# 设置管理器 - 处理游戏设置的加载、保存和应用

# 背景音乐播放器
@onready var bgm_player: AudioStreamPlayer = null

# 默认设置
var default_settings = {
	"display": {
		"resolution_width": 1920,
		"resolution_height": 1080,
		"fullscreen": false
	},
	"audio": {
		"master_volume": 50.0,
		"bgm_enabled": true
	}
}

# 当前设置
var current_settings = {}

func _ready():
	# 添加背景音乐播放器到场景
	bgm_player = AudioStreamPlayer.new()
	add_child(bgm_player)
	# 设置背景音乐
	var bgm_resource = load("res://music/bgm1.mp3")
	bgm_player.stream = bgm_resource
	var stream = bgm_player.stream
	if stream:
		stream.loop = true  # 启用音频流的循环
	# 游戏启动时加载设置
	load_settings()
	apply_settings()

func load_settings():
	"""从配置文件加载设置"""
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	
	if err == OK:
		# 加载显示设置
		current_settings["display"] = {
			"resolution_width": config.get_value("display", "resolution_width", default_settings.display.resolution_width),
			"resolution_height": config.get_value("display", "resolution_height", default_settings.display.resolution_height),
			"fullscreen": config.get_value("display", "fullscreen", default_settings.display.fullscreen)
		}
		
		# 加载音频设置
		current_settings["audio"] = {
			"master_volume": config.get_value("audio", "master_volume", default_settings.audio.master_volume),
			"bgm_enabled": config.get_value("audio", "bgm_enabled", default_settings.audio.bgm_enabled)
		}
	else:
		# 如果没有配置文件，使用默认设置
		current_settings = default_settings.duplicate(true)
		save_settings()

func save_settings():
	"""保存设置到配置文件"""
	var config = ConfigFile.new()
	
	# 保存显示设置
	config.set_value("display", "resolution_width", current_settings.display.resolution_width)
	config.set_value("display", "resolution_height", current_settings.display.resolution_height)
	config.set_value("display", "fullscreen", current_settings.display.fullscreen)
	
	# 保存音频设置
	config.set_value("audio", "master_volume", current_settings.audio.master_volume)
	config.set_value("audio", "bgm_enabled", current_settings.audio.bgm_enabled)
	
	# 保存到文件
	config.save("user://settings.cfg")

func apply_settings():
	"""应用当前设置"""
	apply_display_settings()
	apply_audio_settings()

func apply_display_settings():
	"""应用显示设置"""
	var window = get_window()
	if not window:
		return
	
	# 设置全屏模式
	if current_settings.display.fullscreen:
		window.mode = Window.MODE_FULLSCREEN
	else:
		window.mode = Window.MODE_WINDOWED
		# 设置窗口大小
		var new_size = Vector2i(current_settings.display.resolution_width, current_settings.display.resolution_height)
		window.size = new_size
		
		# 居中窗口
		var screen_size = DisplayServer.screen_get_size()
		var window_pos = (screen_size - new_size) / 2
		window.position = window_pos
	
	# 更新视口缩放
	update_viewport_scaling()

func update_viewport_scaling():
	"""更新视口缩放以保持1920x1080的比例"""
	var window = get_window()
	if not window:
		return
	
	# 设置内容缩放模式以保持原始比例
	window.content_scale_mode = Window.CONTENT_SCALE_MODE_VIEWPORT
	window.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP
	window.content_scale_size = Vector2i(1920, 1080)

func apply_audio_settings():
	"""应用音频设置"""
	var master_bus_index = AudioServer.get_bus_index("Master")
	var volume_db = linear_to_db(current_settings.audio.master_volume / 100.0)
	AudioServer.set_bus_volume_db(master_bus_index, volume_db)
	
	# 应用背景音乐设置
	if current_settings.audio.bgm_enabled:
		if not bgm_player.playing:
			bgm_player.play()
	else:
		bgm_player.stop()

func update_resolution(width: int, height: int, fullscreen: bool):
	"""更新分辨率设置"""
	current_settings.display.resolution_width = width
	current_settings.display.resolution_height = height
	current_settings.display.fullscreen = fullscreen
	apply_display_settings()
	save_settings()

func update_volume(volume: float):
	"""更新音量设置"""
	current_settings.audio.master_volume = volume
	apply_audio_settings()
	save_settings()

func get_current_resolution() -> Vector2i:
	"""获取当前分辨率设置"""
	return Vector2i(current_settings.display.resolution_width, current_settings.display.resolution_height)

func is_fullscreen() -> bool:
	"""获取当前全屏状态"""
	return current_settings.display.fullscreen

func get_master_volume() -> float:
	"""获取当前主音量"""
	return current_settings.audio.master_volume

func update_bgm_enabled(enabled: bool):
	"""更新背景音乐开关设置"""
	current_settings.audio.bgm_enabled = enabled
	apply_audio_settings()
	save_settings()

func is_bgm_enabled() -> bool:
	"""获取当前背景音乐开关状态"""
	return current_settings.audio.bgm_enabled
