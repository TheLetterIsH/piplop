class_name Game
extends Node

# State Machine
enum State {
	NONE,
	SPLASH,
	MAIN_MENU,
	PASSIVE_SELECTION,
	ARENA,
	GAME_OVER,
}

@export var state: State = State.NONE
var state_duration: float = 0.0

@export var screen_map: Dictionary[G.Screen, PackedScene]
var overlay_screen_stack: Array[Node] = []

# Containers
@onready var gameplay: Node = $Gameplay
@onready var ui: Node = $UI

# Gameplay
var arena: Node2D

# UI
#var splash: Splash
var main_menu: MainMenu
var options_menu: OptionsMenu
#var pause_menu: PauseMenu
#var game_over: GameOver

# Others
@onready var cursor: Cursor = %Cursor
@onready var shadow_overlay: ColorRect = %ShadowOverlay
@onready var transition_overlay: ColorRect = %TransitionOverlay


func _enter_tree() -> void:
	pass


func _ready() -> void:
	initialize()
	connect_signals()


func initialize() -> void:
	G.game = self
	
	change_state(State.ARENA)


func connect_signals() -> void:
	pass


func _process(delta: float) -> void:
	state_duration += delta
	
	match state:
		State.SPLASH:
			splash_state()
		State.MAIN_MENU:
			main_menu_state()
		State.ARENA:
			arena_state()
		State.GAME_OVER:
			game_over_state()


func change_state(next_state: State) -> void:
	if state != State.NONE:
		await transition_in()
	
	match state:
		State.SPLASH:
			exit_splash_state()
		State.MAIN_MENU:
			exit_main_menu_state()
		State.ARENA:
			exit_arena_state()
		State.GAME_OVER:
			exit_game_over_state()
	
	state = next_state
	state_duration = 0.0
	
	match state:
		State.SPLASH:
			enter_splash_state()
		State.MAIN_MENU:
			enter_main_menu_state()
		State.ARENA:
			enter_arena_state()
		State.GAME_OVER:
			enter_game_over_state()
	
	await transition_out()


#region SPLASH
func enter_splash_state() -> void:
	pass


func splash_state() -> void:
	pass


func exit_splash_state() -> void:
	pass
#endregion


#region MAIN_MENU
func enter_main_menu_state() -> void:
	main_menu = load_screen(G.Screen.MAIN_MENU, ui) as MainMenu


func main_menu_state() -> void:
	pass


func exit_main_menu_state() -> void:
	unload_screen(main_menu)
#endregion


#region ARENA
func enter_arena_state() -> void:
	arena = load_screen(G.Screen.ARENA, gameplay)


func arena_state() -> void:
	pass


func exit_arena_state() -> void:
	unload_screen(arena)
#endregion


#region GAME_OVER
func enter_game_over_state() -> void:
	pass


func game_over_state() -> void:
	pass


func exit_game_over_state() -> void:
	pass
#endregion


#region SCREEN MANAGEMENT
func load_screen(id: G.Screen, parent: Node) -> Node:
	if screen_map.size() == 0:
		return
	
	var screen_scene := screen_map[id]
	if !screen_scene:
		return
	
	var screen := screen_map[id].instantiate()
	parent.add_child(screen)
	
	return screen


func unload_screen(screen: Node) -> void:
	if screen and screen.is_inside_tree():
		screen.queue_free()


func push_overlay_screen(screen: G.Screen, parent: Node = ui) -> Node:
	var overlay_screen := screen_map[screen].instantiate()
	parent.add_child(overlay_screen)
	overlay_screen_stack.append(overlay_screen)
	
	return overlay_screen


func pop_overlay_screen() -> void:
	if overlay_screen_stack.size() == 0:
		return
	
	var overlay_screen := overlay_screen_stack.pop_back() as Node
	if overlay_screen and overlay_screen.is_inside_tree():
		overlay_screen.queue_free()


func transition_in() -> void:
	transition_overlay.material.set("shader_parameter/inverted", false)
	
	var tween := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(transition_overlay.material, "shader_parameter/progress", 1.0, 0.5).from(0.0)
	
	await tween.finished
	
	transition_overlay.mouse_filter = Control.MOUSE_FILTER_STOP


func transition_out() -> void:
	transition_overlay.material.set("shader_parameter/inverted", true)
	
	var tween := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(transition_overlay.material, "shader_parameter/progress", 0.0, 0.5).from(1.0)
	
	await tween.finished
	
	transition_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
#endregion

func quit() -> void:
	get_tree().quit()
