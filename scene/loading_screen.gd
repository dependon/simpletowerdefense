extends CanvasLayer

# 加载屏幕脚本

@onready var animation_player = $AnimationPlayer
@onready var progress_bar = $CenterContainer/VBoxContainer/ProgressBar
@onready var loading_text = $CenterContainer/VBoxContainer/LoadingText

# 目标场景路径
var target_scene_path = ""

# 加载状态
var is_loading = false
var dots_count = 0
var dots_timer = 0
var dots_update_interval = 0.5 # 更新间隔（秒）

# 异步加载相关变量
var loader = null
var time_max = 100 # 最大加载时间（毫秒）
var wait_frames = 1 # 等待帧数

func _ready():
	# 启动动画
	animation_player.play("loading_animation")
	
	# 初始化进度条
	progress_bar.value = 0

# 设置目标场景并开始异步加载
func set_target_scene(scene_path: String):
	print("开始异步加载场景: %s" % scene_path)
	target_scene_path = scene_path
	is_loading = true
	
	# 开始异步加载
	loader = ResourceLoader.load_threaded_request(target_scene_path)
	print("异步加载请求已发送")
	
	# 等待几帧再开始检查加载状态
	await get_tree().process_frame
	await get_tree().process_frame
	print("开始检查加载状态")

# 处理加载过程
func _process(delta):
	if is_loading:
		# 更新加载文本动画
		dots_timer += delta
		if dots_timer >= dots_update_interval:
			dots_timer = 0
			dots_count = (dots_count + 1) % 4
			var dots = ""
			for i in range(dots_count):
				dots += "."
			loading_text.text = tr("LOADING") + dots
		
		# 处理异步加载
		if loader != null:
			var status = ResourceLoader.load_threaded_get_status(target_scene_path)
			
			if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
				# 更新进度条
				var progress_array = []
				ResourceLoader.load_threaded_get_status(target_scene_path, progress_array)
				var progress = progress_array[0] if progress_array.size() > 0 else 0.0
				progress_bar.value = progress * 100
				print("加载进度: %s%%" % [progress * 100])
				
			elif status == ResourceLoader.THREAD_LOAD_LOADED:
				# 加载完成，获取场景资源
				print("场景加载完成，准备切换")
				var resource = ResourceLoader.load_threaded_get(target_scene_path)
				if resource != null:
					# 确保进度条显示100%
					progress_bar.value = 100
					
					# 实例化场景并切换
					call_deferred("_change_scene", resource)
				else:
					print("加载完成但资源为空，使用回退方法")
					call_deferred("_fallback_change_scene")
					
			elif status == ResourceLoader.THREAD_LOAD_FAILED:
				# 加载失败，回退到直接加载
				print("异步加载失败，使用直接加载方式")
				call_deferred("_fallback_change_scene")

# 切换到新场景
func _change_scene(resource):
	print("开始切换到新场景: %s" % target_scene_path)
	is_loading = false
	
	# 实例化新场景
	var new_scene = resource.instantiate()
	print("新场景实例化成功")
	
	# 获取当前场景树
	var tree = get_tree()
	
	# 获取根节点
	var root = tree.root
	
	# 获取当前场景
	var current_scene = tree.current_scene
	print("当前场景: %s" % current_scene.name)
	
	# 从场景树中移除当前场景
	root.remove_child(current_scene)
	current_scene.queue_free()
	print("已移除当前场景")
	
	# 添加新场景
	root.add_child(new_scene)
	tree.current_scene = new_scene
	print("新场景已添加并设置为当前场景: %s" % new_scene.name)
	
	# 移除加载屏幕
	print("移除加载屏幕")
	queue_free()

# 回退方法：直接加载场景
func _fallback_change_scene():
	print("使用回退方法直接加载场景: %s" % target_scene_path)
	is_loading = false
	get_tree().change_scene_to_file(target_scene_path)
	queue_free()

# 静态方法：显示加载屏幕并加载目标场景
static func load_scene(scene_path: String):
	var loading_screen = load("res://scene/loading_screen.tscn").instantiate()
	
	# 添加到场景树
	var root = Engine.get_main_loop().root
	root.add_child(loading_screen)
	
	# 设置目标场景并开始异步加载
	loading_screen.set_target_scene(scene_path)
