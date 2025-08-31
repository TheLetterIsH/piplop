class_name OptionsMenu
extends CanvasLayer

# Components
@onready var fullscreen_button: BetterButton = %FullscreenButton
@onready var v_sync_button: BetterButton = %VSyncButton
@onready var music_slider: HSlider = %MusicSlider
@onready var sound_slider: HSlider = %SoundSlider
@onready var back_button: BetterButton = %BackButton


func _ready() -> void:
	connect_signals()
	set_initial_values()


func connect_signals() -> void:
	fullscreen_button.toggled.connect(on_fullscreen_button_toggled)
	v_sync_button.toggled.connect(on_v_sync_button_toggled)
	music_slider.value_changed.connect(on_music_slider_value_changed)
	sound_slider.value_changed.connect(on_sound_slider_value_changed)
	back_button.pressed.connect(on_back_button_pressed)


func set_initial_values() -> void:
	var is_fullscreen_toggled_on := G.options["video"]["fullscreen"] as bool
	fullscreen_button.text = "on" if is_fullscreen_toggled_on else "off"
	fullscreen_button.button_pressed = true if is_fullscreen_toggled_on else false
	
	var is_v_sync_toggled_on := G.options["video"]["vsync"] as bool
	v_sync_button.text = "on" if is_v_sync_toggled_on else "off"
	v_sync_button.button_pressed = true if is_v_sync_toggled_on else false
	
	var music_slider_value := G.options["audio"]["music"] as float
	music_slider_value *= 100
	music_slider.value = music_slider_value
	
	var sound_slider_value := G.options["audio"]["sound"] as float
	sound_slider_value *= 100
	sound_slider.value = sound_slider_value


func on_fullscreen_button_toggled(toggled_on: bool) -> void:
	fullscreen_button.text = "on" if toggled_on else "off"
	OptionsManager.save_option("video", "fullscreen", toggled_on)


func on_v_sync_button_toggled(toggled_on: bool) -> void:
	v_sync_button.text = "on" if toggled_on else "off"
	OptionsManager.save_option("video", "vsync", toggled_on)


func on_music_slider_value_changed(value: float) -> void:
	value /= 100
	OptionsManager.save_option("audio", "music", value)


func on_sound_slider_value_changed(value: float) -> void:
	value /= 100
	OptionsManager.save_option("audio", "sound", value)


func on_back_button_pressed() -> void:
	G.game.pop_overlay_screen()
