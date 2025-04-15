extends Node2D

@export var max_enemies = 20  # 第一关的最大敌人数量
@export var enemy_speed = 100  # 敌人的移动速度
@export var spawn_interval = 2.0  # 敌人生成间隔
@export var min_spawn_interval = 0.1  # 最小生成间隔
@export var spawn_interval_decrease = 0.1  # 每生成一个敌人减少的间隔时间
@export var enemy_health : float = 1.01  # 怪物的初始血量倍率
