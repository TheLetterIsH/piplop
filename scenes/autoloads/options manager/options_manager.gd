extends Node


func _ready() -> void:
	initialize()
	connect_signals()


func initialize() -> void:
	load_options()
	apply_options()
	set_bounds()


func connect_signals() -> void:
	get_viewport().size_changed.connect(on_viewport_resized)


func load_options() -> void:
	G.options_file_path = OS.get_user_data_dir() + "/" + G.options_file_name
	
	# If options file exists, then load it and set it's values in Globals
	if FileAccess.file_exists(G.options_file_path):
		G.options_file.load(G.options_file_path)
		
		for section in G.options_file.get_sections():
			for key in G.options_file.get_section_keys(section):
				G.options[section][key] = G.options_file.get_value(section, key)
		
		return
	
	# If options file doesn't exist, then make one from the values in Globals
	for section in G.options.keys():
		for key in G.options[section].keys():
			G.options_file.set_value(section, key, G.options[section][key])
	
	G.options_file.save(G.options_file_path)


func save_option(section: String, key: String, value: Variant) -> void:
	G.options[section][key] = value
	
	G.options_file.set_value(section, key, value)
	G.options_file.save(G.options_file_path)
	
	apply_option(key, value)


func apply_option(key: String, value: Variant) -> void:
	match key:
		"fullscreen":
			if value:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
				DisplayServer.window_set_size(DisplayServer.screen_get_size())
			else:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
				DisplayServer.window_set_size(Vector2i(1280, 720))
				get_window().move_to_center()
		"vsync":
			if value:
				DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
			else:
				DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		"music":
			# SoundManager.set_music_volume(value)
			pass
		"sound":
			# SoundManager.set_sound_volume(value)
			pass


func apply_options() -> void:
	for section in G.options.keys():
		for key in G.options.get(section).keys():
			apply_option(key, G.options[section][key])


func on_viewport_resized() -> void:
	G.viewport_size = get_viewport().size
	G.viewport_center = G.viewport_size / 2.0
	set_bounds()


func set_bounds() -> void:
	G.viewport_top_edge = 0
	G.viewport_bottom_edge = G.viewport_size.y
	G.viewport_left_edge = 0
	G.viewport_right_edge = G.viewport_size.x
