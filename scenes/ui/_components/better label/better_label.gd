class_name BetterLabel
extends RichTextLabel

var tween: Tween

signal text_updated


func _ready() -> void:
	connect_signals()


func connect_signals() -> void:
	self.text_updated.connect(on_text_updated)


func update_text(new_text: String) -> void:
	self.text = new_text
	text_updated.emit()


func on_text_updated() -> void:
	self.pivot_offset = Vector2(size.x / 2.0, size.y / 2.0)
	
	self.scale = Vector2(1.2, 1.2)
	var r := 10.0 * (64.0 / self.size.x)
	self.rotation_degrees = clamp(r, 2.0, 10.0)
	
	if tween:
		tween.kill()
	
	tween = self.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC).set_parallel()
	tween.tween_property(self, "scale", Vector2.ONE, 1.0)
	tween.tween_property(self, "rotation_degrees", 0.0, 1.0)
