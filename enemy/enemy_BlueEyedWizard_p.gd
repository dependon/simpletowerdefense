extends Enemy

# 蓝眼巫师特有属性
@export var base_speed: float = 120.0  # 基础移动速度
@export var base_hp: int = 200       # 基础生命值

func _ready() -> void:
	# 设置蓝眼巫师的基本属性
	speed = base_speed
	hp = base_hp
	# 调用父类的_ready()函数来初始化基本功能
	super._ready()
	# 你可以在这里添加蓝眼巫师特有的初始化代码
	# 例如，设置一个不同的血条颜色
	# health_bar.modulate = Color(0.2, 0.2, 0.8, 0.8) # 示例：蓝色血条
