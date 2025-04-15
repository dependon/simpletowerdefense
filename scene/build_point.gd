extends Area2D

var is_occupied = false

func set_occupied(value: bool):
	is_occupied = value

func is_point_occupied() -> bool:
	return is_occupied
