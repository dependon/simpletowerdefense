extends Area2D

var path_follow: PathFollow2D
var path: Path2D
@export var speed = 100
@export var hp = 100

func _ready() -> void:
	add_to_group("enemies")

# 设置敌人移动路径
func set_path(curve: Curve2D) -> void:
	path = Path2D.new()
	path.curve = curve
	add_child(path)
	
	path_follow = PathFollow2D.new()
	path.add_child(path_follow)
	
func _physics_process(delta):
	if path_follow and path:
		path_follow.progress += speed * delta
		position = path_follow.position
		if path_follow.progress >= path.curve.get_baked_length():
			queue_free()

func take_damage(damage: int) -> void:
	hp -= damage
	if hp <= 0:
		queue_free()
