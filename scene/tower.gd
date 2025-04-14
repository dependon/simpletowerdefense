extends Sprite2D

@onready var tower_area: Area2D = $Area2D
@export var range = 200
@export var fire_rate = 1
var time_since_last_fire = 0

func _physics_process(delta):
	time_since_last_fire += delta
	if time_since_last_fire >= 1 / fire_rate:
		var enemies = tower_area.get_overlapping_areas()
		for enemy in enemies:
			if enemy.is_in_group("enemies"):
				var bullet_scene = preload("res://scene/bullet.tscn")
				var bullet = bullet_scene.instantiate()
				bullet.direction = (enemy.global_position - position).normalized()
				get_parent().add_child(bullet)
				bullet.position = position
				time_since_last_fire = 0
				break
