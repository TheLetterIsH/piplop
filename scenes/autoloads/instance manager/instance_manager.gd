extends Node


func get_player() -> Player:
	return get_tree().get_first_node_in_group("player")


func get_enemy_container() -> Node2D:
	return get_tree().get_first_node_in_group("enemy_container")


func get_entity_container() -> Node2D:
	return get_tree().get_first_node_in_group("entity_container")


func get_effect_container() -> Node2D:
	return get_tree().get_first_node_in_group("effect_container")
