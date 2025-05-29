extends Area2D
class_name Bullet
@export var speed = 300
@export var max_range = 800  # 子弹最大射程
var direction := Vector2.ZERO
var damage = 50  # 默认伤害值
var initial_position := Vector2.ZERO  # 记录初始位置
var freeze_duration = 5.0 #减速时间
var slow_multiplier = 2 #减速倍率
var critical_chance = 0.01 #暴击概率
var critical_ratio = 1.5 #暴击伤害倍率
var penetration_count = 1 #子弹碰撞敌人消失次数(用于配置允许穿透敌人个数)

@onready var timer: Timer = $Timer # 获取timer节点

func _ready():
	#连接槽函数
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	timer.start(5.0)
	area_entered.connect(_on_area_entered)
	initial_position = position  # 记录发射时的位置

func _physics_process(delta):
	position += direction * speed * delta


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies"):
		var final_damage = damage
		# 判断是否暴击
		if randf() < critical_chance:
			final_damage *= critical_ratio
			print("暴击！伤害: ", final_damage) # 打印暴击信息
		area.take_damage(final_damage)
		# 如果是冰霜子弹，则减速敌人
		if has_meta("type") and get_meta("type") == "frost":
			area.set_speed_multiplier(slow_multiplier,freeze_duration)
		penetration_count-=1
		if penetration_count <= 0: 
			queue_free()

func _on_timer_timeout():
	queue_free()
