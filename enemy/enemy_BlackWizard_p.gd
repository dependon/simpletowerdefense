extends Enemy

@export var base_speed = 150  
@export var base_hp = 300  

func _ready() -> void:
	# 设置基本属性
	speed = base_speed
	hp = base_hp
	# 调用父类的_ready()函数来初始化基本功能
	super._ready()
