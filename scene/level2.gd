extends Node2D

@export var max_enemies = 30  # 第二关的最大敌人数量
@export var enemy_speed = 150  # 敌人的移动速度
@export var spawn_interval = 2.0  # 敌人生成间隔
@export var min_spawn_interval = 0.3  # 最小生成间隔
@export var spawn_interval_decrease = 0.05  # 每生成一个敌人减少的间隔时间
@export var enemy_health : float = 1.05  # 怪物的初始血量倍率
