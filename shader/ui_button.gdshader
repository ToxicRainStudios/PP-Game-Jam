shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform bool hovered = false;
uniform vec4 base_color : source_color;

void fragment() {
	vec2 uv = SCREEN_UV;
	float time = TIME;
	vec4 color = base_color;

	if (hovered) {
		float offset = sin(time * 6.0) * 0.009;

		// RGB channel split using screen samples
		float r = texture(SCREEN_TEXTURE, uv + vec2(offset, 0.0)).r;
		float g = texture(SCREEN_TEXTURE, uv).g;
		float b = texture(SCREEN_TEXTURE, uv - vec2(offset, 0.0)).b;

		color = vec4(r, g, b, base_color.a);
	}

	COLOR = color;
}
