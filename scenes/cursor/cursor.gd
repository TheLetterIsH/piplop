class_name Cursor
extends Sprite2D


func _ready() -> void:
	initialize()


func initialize() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func _process(_delta: float) -> void:
	self.global_position = get_global_mouse_position()
