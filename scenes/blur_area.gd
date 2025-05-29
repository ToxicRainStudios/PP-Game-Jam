shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture;
uniform float blur_size = 2.0; // Higher = blurrier
uniform int samples = 8;

void fragment() {
	vec2 size = vec2(blur_size) / SCREEN_PIXEL_SIZE;
	vec2 uv = SCREEN_UV;
	vec4 col = vec4(0.0);

	for (int x = -samples; x <= samples; x++) {
		for (int y = -samples; y <= samples; y++) {
			vec2 offset = vec2(x, y);
			col += texture(screen_texture, uv + offset * size);
		}
	}
	col /= float((2 * samples + 1) * (2 * samples + 1));
	COLOR = col;
}
