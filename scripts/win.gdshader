shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float intensity : hint_range(0.0, 1.0) = 0.0;
uniform vec4 base_color : source_color;

void fragment() {
	vec2 uv = SCREEN_UV;
	float time = TIME;
	vec4 color = base_color;

	if (intensity > 0.01) {
		float offset = sin(time * 6.0) * 0.009 * intensity;

		// RGB split
		float r = texture(SCREEN_TEXTURE, uv + vec2(offset, 0.0)).r;
		float g = texture(SCREEN_TEXTURE, uv).g;
		float b = texture(SCREEN_TEXTURE, uv - vec2(offset, 0.0)).b;

		color = vec4(r, g, b, base_color.a);

		// Scanlines
		color.rgb *= 0.95 + 0.05 * sin(uv.y * 800.0 + time * 10.0);

		// Purple-pink overlay
		color.rgb = mix(color.rgb, vec3(1.0, 0.4, 0.9), 0.2 * intensity);
	}

	COLOR = color;
}
