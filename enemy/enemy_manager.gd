# enemy_manager.gd
extends Node

# 敌人类型枚举
enum EnemyType {
	NORMAL,
	THIEF,
	WIZARD,
	WARRIOR,
	WEREWOLF
}

# 预加载敌人场景
var enemy_scenes = {
	EnemyType.NORMAL: preload("res://enemy/enemy.tscn"),
	EnemyType.THIEF: preload("res://enemy/enemy_thief.tscn"),
	EnemyType.WIZARD: preload("res://enemy/enemy_wizard.tscn"),
	EnemyType.WARRIOR: preload("res://enemy/enemy_warrior.tscn"),
	EnemyType.WEREWOLF: preload("res://enemy/enemy_werewolf.tscn")
}

# 获取敌人场景的方法
func get_enemy_scene(type: EnemyType):
	if enemy_scenes.has(type):
		return enemy_scenes[type]
	else:
		printerr("Error: Enemy type not found in enemy_scenes: ", type)
		return null # 或者返回一个默认的敌人场景
