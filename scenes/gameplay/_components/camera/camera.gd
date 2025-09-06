class_name Camera
extends Camera2D

# NOTE This is unfinished

@export var decay: float = 0.8
@export var max_offset: Vector2 = Vector2(100, 100)
@export var max_rotation: float = 0.1

var trauma: float = 0.0
var trauma_power: int = 2

var default_offset: Vector2 = Vector2.ZERO


func _ready() -> void:
	initialize()
	connect_signals()


func initialize() -> void:
	default_offset = self.offset


func connect_signals() -> void:
	pass


func _process(delta: float) -> void:
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()


func shake() -> void:
	var amount = pow(trauma, trauma_power)
	self.rotation = max_rotation * amount * randf_range(-1, 1)
	self.offset.x = max_offset.x * amount * randf_range(-1, 1)
	self.offset.y = max_offset.y * amount * randf_range(-1, 1)
