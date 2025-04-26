extends "res://scene/enemy.gd"

# 盗贼特有属性
@export var base_speed = 150  # 基础移动速度比普通敌人快50%
@export var base_hp = 60  # 基础生命值较低

func _ready() -> void:
	# 设置盗贼的基本属性
	speed = base_speed
	hp = base_hp
	# 调用父类的_ready()函数来初始化基本功能
	super._ready()
	# 设置血条颜色为深红色，表示这是精英怪
	health_bar.modulate = Color(0.8, 0.2, 0.2, 0.8)
