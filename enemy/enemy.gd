extends Area2D
class_name Enemy
var path_follow: PathFollow2D
var path: Path2D
#移动速度
@export var speed = 100
var speed_multiplier = 1.0  # 速度修改器
var is_slowed = false # 是否被减速
var slow_duration = 5.0 # 减速持续时间
var original_speed_multiplier = 1.0 # 减速前的速度
#生命值 
@export var hp : float = 100
#生命条
var health_bar: ProgressBar
var slow_timer: Timer # 减速计时器
var _previous_position: Vector2 # 用于存储上一帧的位置

func _ready() -> void:
	add_to_group("enemies")
	# 创建血条
	health_bar = ProgressBar.new()
	health_bar.max_value = hp
	health_bar.value = hp
	health_bar.show_percentage = false
	health_bar.custom_minimum_size = Vector2(40, 8)
	health_bar.position = Vector2(-20, 30)
	# 设置血条颜色为淡红色
	health_bar.modulate = Color(1, 0.5, 0.5, 0.8)
	add_child(health_bar)
	
	# 创建减速计时器
	slow_timer = Timer.new()
	slow_timer.one_shot = true # 只运行一次
	slow_timer.connect("timeout", Callable(self, "_on_slow_timer_timeout"))
	add_child(slow_timer)
	
	_previous_position = position # 初始化上一帧位置

# 设置敌人移动路径
func set_path(curve: Curve2D) -> void:
	path = Path2D.new()
	path.curve = curve
	add_child(path)
	
	path_follow = PathFollow2D.new()
	path.add_child(path_follow)
	
	# 设置初始位置为路径起点
	position = curve.get_point_position(0)
	_previous_position = position # 初始化上一帧位置

func _physics_process(delta):
	if path_follow and path:
		path_follow.progress += speed * speed_multiplier * delta
		position = path_follow.position
		
		# 获取精灵节点
		var sprite = get_node("AnimatedSprite2D") as AnimatedSprite2D # 假设精灵节点名为Sprite2D
		if sprite:
			# 判断移动方向并水平翻转精灵
			if position.x >= _previous_position.x:
				# 向左移动，不翻转
				sprite.flip_h = false
			elif position.x < _previous_position.x:
				# 向右移动，水平翻转
				sprite.flip_h = true
		
		_previous_position = position # 更新上一帧位置
		
		if path_follow.progress >= path.curve.get_baked_length():
			queue_free()
	# 每帧逐渐恢复速度，只在没有被减速时恢复
	if speed_multiplier < 1.0 and not is_slowed:
		speed_multiplier = min(speed_multiplier + delta * 0.1, 1.0)

func set_speed_multiplier(multiplier: float, duration: float = 5.0) -> void:
	if !is_slowed:
		original_speed_multiplier = speed_multiplier # 记录减速前的速度
		speed_multiplier = speed_multiplier / multiplier 
		is_slowed = true # 设置减速状态
	
	# 复用计时器，更新时间并启动
	slow_timer.wait_time = max(slow_timer.time_left, duration) # 取剩余时间和新持续时间的最大值
	slow_timer.start()
	
func set_health_multiplier(health_multiplier: float) -> void:
	hp = hp * health_multiplier
	
func take_damage(damage: int) -> void:
	hp -= damage
	# 更新血条显示
	health_bar.value = hp
	if hp <= 0:
		# 击杀奖励
		var BattleScene = get_tree().get_root().get_node("BattleScene")
		if BattleScene:
			BattleScene.coins += 20  # 每击杀一个敌人奖励20金币
			BattleScene.update_coins_display()
			# 随机获得1-3个钻石
			var diamond_reward = randi() % 3 + 1
			var game_manager = get_node("/root/GameManager")
			if game_manager:
				game_manager.add_diamonds(diamond_reward)
		queue_free()

func _on_slow_timer_timeout():
	speed_multiplier = original_speed_multiplier # 恢复速度
	is_slowed = false # 移除减速状态
