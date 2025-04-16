extends Area2D

@export var speed = 300
var direction := Vector2.ZERO
var damage = 50  # 默认伤害值

func _physics_process(delta):
	position += direction * speed * delta

	# 超出屏幕范围后自动销毁
	if position.x < -100 or position.x > 1200 or position.y < -100 or position.y > 700:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		body.take_damage(damage)
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies"):
		area.take_damage(damage)
		queue_free()
