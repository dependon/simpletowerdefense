extends Enemy

# 巫师特有属性
@export var base_speed = 100  # 基础移动速度
@export var base_hp = 60  # 基础生命值较低

func _ready() -> void:
	# 设置巫师的基本属性
	speed = base_speed
	hp = base_hp
	# 调用父类的_ready()函数来初始化基本功能
	super._ready()
