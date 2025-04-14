extends Area2D

@onready var path_follow: PathFollow2D = $Path2D/PathFollow2D
@export var speed = 100
func _ready() -> void:
	add_to_group("enemies")
	
func _physics_process(delta):
	path_follow.progress += speed * delta
	position = path_follow.position
	if path_follow.progress >= $Path2D.curve.get_baked_length():
		queue_free()
