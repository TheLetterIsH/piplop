extends Node

# Game
var game: Game

# Options
var options_file: ConfigFile = ConfigFile.new()
var options_file_name: String = "options.yeet"
var options_file_path: String

var options: Dictionary[String, Dictionary] = {
	video = {
		fullscreen = true,
		vsync = true,
	},
	audio = {
		music = 0.5,
		sound = 0.5,
	}
}

# Bounds
var viewport_size: Vector2i = Vector2i(640, 360)
var viewport_top_edge: int = 0
var viewport_bottom_edge: int = viewport_size.y
var viewport_left_edge: int = 0
var viewport_right_edge: int = viewport_size.x
var viewport_center: Vector2 = viewport_size / 2.0

# Screens
enum Screen {
	SPLASH,
	MAIN_MENU,
	OPTIONS_MENU,
	PASSIVE_SELECTION,
	ARENA,
	PAUSE_MENU,
	GAME_OVER,
}

# Colors
@export var colors: Dictionary[String, Color] = {
	red = Color("#de4343"),
	orange = Color("#ed7e36"),
	yellow = Color("#eec042"),
	green = Color("#50d16e"),
	blue = Color("#419eed"),
	purple = Color("#9766f6"),
	light = Color("#d9d9d9"),
	mid_1 = Color("#b3b3b3"),
	mid_2 = Color("#6b6b6b"),
	dark = Color("#2e2e2e"),
	background_1 = Color("#262626"),
	background_2 = Color("#242424"),
	shadow = Color("#1a1a1a"),
}

# Variables
# Arena
var arena_unit: float = 16.0
