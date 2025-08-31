shader_type canvas_item;

uniform sampler2D transition_texture;
uniform float progress: hint_range(0, 1) = 0.0;
uniform float smoothness: hint_range(0, 1) = 0.1;
uniform vec4 color: source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform bool inverted = false;

void fragment() {
	float value = 1.0 - texture(transition_texture, UV).r;

	if (inverted) {
		value = 1.0 - value;
	}

	float p = 1.0 - progress;

	float alpha = smoothstep(p, p + smoothness, value * (1.0 - smoothness) + smoothness);
	COLOR = vec4(color.rgb, alpha);
}