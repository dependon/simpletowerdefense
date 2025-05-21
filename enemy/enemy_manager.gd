# enemy_manager.gd
extends Node

# 敌人类型枚举
enum EnemyType {
	NORMAL,
	THIEF,
	WIZARD,
	WARRIOR,
	WEREWOLF,
	BLACKWIZARD,
	BLUEEYEDWIZARD,
	COWBOY,
	CRAZYONE,
	GREENMAGE,
	GREENWIZARD,
	MAGEONE,
	ORC,
	REDWIZARD,
	TECHKNIFEMAKER
}

# 预加载敌人场景
var enemy_scenes = {
	EnemyType.NORMAL: preload("res://enemy/enemy.tscn"),
	EnemyType.THIEF: preload("res://enemy/enemy_thief.tscn"),
	EnemyType.WIZARD: preload("res://enemy/enemy_wizard.tscn"),
	EnemyType.WARRIOR: preload("res://enemy/enemy_warrior.tscn"),
	EnemyType.WEREWOLF: preload("res://enemy/enemy_werewolf.tscn"),
	EnemyType.BLACKWIZARD: preload("res://enemy/enemy_BlackWizard_p.tscn"),
	EnemyType.BLUEEYEDWIZARD: preload("res://enemy/enemy_BlueEyedWizard_p.tscn"),
	EnemyType.COWBOY: preload("res://enemy/enemy_Cowboy_p.tscn"),
	EnemyType.CRAZYONE: preload("res://enemy/enemy_CrazyOne_p.tscn"),
	EnemyType.GREENMAGE: preload("res://enemy/enemy_GreenMage_p.tscn"),
	EnemyType.GREENWIZARD: preload("res://enemy/enemy_GreenWizard_p.tscn"),
	EnemyType.MAGEONE: preload("res://enemy/enemy_MageOne_p.tscn"),
	EnemyType.ORC: preload("res://enemy/enemy_Orc_p.tscn"),
	EnemyType.REDWIZARD: preload("res://enemy/enemy_RedWizard_p.tscn"),
	EnemyType.TECHKNIFEMAKER: preload("res://enemy/enemy_TechKnifeMaker_p.tscn")
}

# 获取敌人场景的方法
func get_enemy_scene(type: EnemyType):
	if enemy_scenes.has(type):
		return enemy_scenes[type]
	else:
		printerr("Error: Enemy type not found in enemy_scenes: ", type)
		return null # 或者返回一个默认的敌人场景
