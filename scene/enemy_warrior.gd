extends Enemy

# 战士特有属性
@export var base_speed = 50  #速度较慢
@export var base_hp = 600  # 基础生命值较高

func _ready() -> void:
	# 设置盗贼的基本属性
	speed = base_speed
	hp = base_hp
	# 调用父类的_ready()函数来初始化基本功能
	super._ready()
