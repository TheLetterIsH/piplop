extends Node

@export var total_levels: int = 20
@export var level: int = 1
@export var is_endless: bool = false
@export var waves_per_level: int = 3

var time_survived: float = 0
var enemies_killed: int = 0
var enemies_killed_direct: int = 0
var enemies_killed_recall: int = 0
#var killed_by: Enemy = null


func _ready() -> void:
	initialize()
	connect_signals()


func initialize() -> void:
	# TODO Get level from save system
	pass


func connect_signals() -> void:
	pass
