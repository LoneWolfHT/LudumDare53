extends Node

@export var enemy_count: int = 1
@export var enemy_hp: int = 100
@export var rewards: Array = []

func start_battle(count: int, hp: int, win_rewards: Array = []):
	enemy_count = count
	enemy_hp = hp
	rewards = win_rewards

	get_tree().change_scene_to_file("res://Scenes/BattleScene.tscn")
