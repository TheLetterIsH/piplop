class_name MainMenu
extends CanvasLayer

# Components
@onready var play_button: BetterButton = %PlayButton
@onready var options_button: BetterButton = %OptionsButton
@onready var credits_button: BetterButton = %CreditsButton
@onready var quit_button: BetterButton = %QuitButton


func _ready() -> void:
	initialize()
	connect_signals()


func initialize() -> void:
	pass


func connect_signals() -> void:
	play_button.pressed.connect(on_play_button_pressed)
	options_button.pressed.connect(on_options_button_pressed)
	#credits_button.pressed.connect(on_credits_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)


func on_play_button_pressed() -> void:
	G.game.change_state(Game.State.ARENA)


func on_options_button_pressed() -> void:
	G.game.push_overlay_screen(G.Screen.OPTIONS_MENU)


func on_quit_button_pressed() -> void:
	G.game.quit()
