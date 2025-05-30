extends Bullet

func _ready():
	# 蓝色子弹：高速度，低伤害
	speed = 450
	damage = 35
	set_meta("type", "speed")
	super._ready()