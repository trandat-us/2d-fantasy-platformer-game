shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture, filter_nearest;
uniform vec4 color: source_color = vec4(0.0, 1.0, 1.0, 1.0);
uniform float color_correction: hint_range(0.0, 1.0) = 0.1;

void fragment() {
	vec4 screen_color = texture(screen_texture, SCREEN_UV);
	screen_color = mix(screen_color, color, color_correction);
	COLOR = screen_color;
}
