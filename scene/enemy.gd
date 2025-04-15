extends Area2D

var path_follow: PathFollow2D
var path: Path2D
#移动速度
@export var speed = 100
#生命值 
@export var hp : float = 100
#生命条
var health_bar: ProgressBar

func _ready() -> void:
	add_to_group("enemies")
	# 创建血条
	health_bar = ProgressBar.new()
	health_bar.max_value = hp
	health_bar.value = hp
	health_bar.show_percentage = false
	health_bar.custom_minimum_size = Vector2(40, 8)
	health_bar.position = Vector2(-20, 30)
	add_child(health_bar)

# 设置敌人移动路径
func set_path(curve: Curve2D) -> void:
	path = Path2D.new()
	path.curve = curve
	add_child(path)
	
	path_follow = PathFollow2D.new()
	path.add_child(path_follow)
	
	# 设置初始位置为路径起点
	position = curve.get_point_position(0)
	
func _physics_process(delta):
	if path_follow and path:
		path_follow.progress += speed * delta
		position = path_follow.position
		if path_follow.progress >= path.curve.get_baked_length():
			queue_free()

func take_damage(damage: int) -> void:
	hp -= damage
	# 更新血条显示
	health_bar.value = hp
	if hp <= 0:
		# 击杀奖励
		var main = get_tree().get_root().get_node("Main")
		if main:
			main.coins += 20  # 每击杀一个敌人奖励20金币
			main.update_coins_display()
		queue_free()
