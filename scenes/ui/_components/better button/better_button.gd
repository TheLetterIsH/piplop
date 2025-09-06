class_name BetterButton
extends Button

@export var hover_color: Color = Color("#d9d9d9")

var tween: Tween


func _ready() -> void:
	connect_signals()


func connect_signals() -> void:
	self.focus_entered.connect(on_focus_entered)
	self.mouse_entered.connect(on_focus_entered)
	
	self.focus_exited.connect(on_focus_exited)
	self.mouse_exited.connect(on_focus_exited)
	
	self.button_down.connect(on_button_down)
	self.button_up.connect(on_button_up)
	
	self.pressed.connect(on_pressed)
	
	self.toggled.connect(on_toggled)


func on_focus_entered() -> void:
	self.self_modulate = hover_color
	
	self.pivot_offset = Vector2(size.x / 2.0, size.y / 2.0)
	
	self.scale = Vector2(1.2, 1.2)
	var r := 10.0 * (64.0 / self.size.x)
	self.rotation_degrees = clamp(r, 2.0, 10.0)
	
	if tween:
		tween.kill()
	
	tween = self.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC).set_parallel()
	tween.tween_property(self, "scale", Vector2.ONE, 1.0)
	tween.tween_property(self, "rotation_degrees", 0.0, 1.0)
	
	# SoundManager.play_sound_with_pitch(Repository.sound_ui_pop, randf_range(0.9, 1.1))


func on_focus_exited() -> void:
	self.self_modulate = Color.WHITE
	
	# SoundManager.stop_sound(Repository.sound_ui_pop)


func on_button_down() -> void:
	pass


func on_button_up() -> void:
	pass


func on_pressed() -> void:
	self.pivot_offset = Vector2(size.x / 2.0, size.y / 2.0)
	tween = self.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.1)
	tween.tween_property(self, "scale", Vector2.ONE, 0.1)
	
	# SoundManager.play_sound_with_pitch(Repository.sound_ui_click, randf_range(0.9, 1.1))


func on_toggled(_toggled_on: bool) -> void:
	pass
