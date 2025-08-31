shader_type canvas_item;

uniform bool is_active = false;
uniform vec4 flash_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	if (is_active) {
		COLOR = vec4(flash_color.rgb, color.a);
	}
}