extends Node


class Text:
	static func center_align_text(text: String) -> String:
		return "[center]%s[/center]" % text
	
	
	static func left_align_text(text: String) -> String:
		return "[left]%s[/left]" % text
	
	
	static func right_align_text(text: String) -> String:
		return "[right]%s[/right]" % text
	
	
	static func wave_text(text: String) -> String:
		return "[wave amp=40.0 freq=5.0 connected=1]%s[/wave]" % text
