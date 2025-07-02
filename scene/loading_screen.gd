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

func _ready():
	# 启动动画
	animation_player.play("loading_animation")
	
	# 初始化进度条
	progress_bar.value = 0

# 设置目标场景
func set_target_scene(scene_path: String):
	target_scene_path = scene_path
	is_loading = true

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
			loading_text.text = "加载中" + dots
		
		# 模拟加载进度
		if progress_bar.value < 100:
			progress_bar.value += delta * 25 # 调整速度
		else:
			# 加载完成，切换到目标场景
			is_loading = false
			get_tree().change_scene_to_file(target_scene_path)
			queue_free() # 移除加载屏幕

# 静态方法：显示加载屏幕并加载目标场景
static func load_scene(scene_path: String):
	var loading_screen = load("res://scene/loading_screen.tscn").instantiate()
	loading_screen.set_target_scene(scene_path)
	
	# 添加到场景树
	var root = Engine.get_main_loop().root
	root.add_child(loading_screen)