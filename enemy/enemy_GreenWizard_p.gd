extends Enemy

# 绿巫师特有属性
@export var base_speed: float = 120.0  # 基础移动速度
@export var base_hp: int = 200       # 基础生命值

func _ready() -> void:
	speed = base_speed
	hp = base_hp

	super._ready()
