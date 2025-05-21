extends Area2D
class_name Bullet
@export var speed = 300
@export var max_range = 800  # 子弹最大射程
var direction := Vector2.ZERO
var damage = 50  # 默认伤害值
var initial_position := Vector2.ZERO  # 记录初始位置
@onready var timer: Timer = $Timer # 获取timer节点

func _ready():
	#连接槽函数
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	timer.start(5.0)
	area_entered.connect(_on_area_entered)
	initial_position = position  # 记录发射时的位置

func _physics_process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		body.take_damage(damage)
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies"):
		area.take_damage(damage)
		# 如果是冰霜子弹，则减速敌人
		if has_meta("type") and get_meta("type") == "frost":
			area.set_speed_multiplier(0.5,5)
		queue_free()

func _on_timer_timeout():
	queue_free()
