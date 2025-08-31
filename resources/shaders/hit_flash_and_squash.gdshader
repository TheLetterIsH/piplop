shader_type canvas_item;

uniform vec2 squash_direction = vec2(0.0, 0.0);
uniform float squash_amount = 0.5; // Controls squash strength

uniform bool is_flash_active = false;
uniform vec4 flash_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void vertex() {
	if (squash_direction != vec2(0.0, 0.0)) {
		vec2 norm_dir = normalize(squash_direction);
		vec2 perp_dir = vec2(-norm_dir.y, norm_dir.x);

		float dot_parallel = dot(VERTEX.xy, norm_dir);
		float dot_perpendicular = dot(VERTEX.xy, perp_dir);

		float scale_parallel = 1.0 - squash_amount * length(squash_direction);
		float scale_perpendicular = 1.0 + squash_amount * length(squash_direction);

		vec2 new_pos = dot_parallel * norm_dir * scale_parallel + dot_perpendicular * perp_dir * scale_perpendicular;

		VERTEX.xy = new_pos;
	}
}

void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	if (is_flash_active) {
		COLOR = vec4(flash_color.rgb, texture_color.a);
	} else {
		COLOR = texture_color;
	}
}