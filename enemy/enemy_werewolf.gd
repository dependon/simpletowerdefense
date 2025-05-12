extends Enemy

# 狼人特有属性
@export var base_speed = 300  # 基础移动速度快
@export var base_hp = 120  # 基础生命值一般

func _ready() -> void:
	# 设置狼人的基本属性
	speed = base_speed
	hp = base_hp
	# 调用父类的_ready()函数来初始化基本功能
	super._ready()
