shader_type canvas_item;

uniform float time;
uniform float scanline_strength : hint_range(0.0, 1.0) = 0.02;
uniform float wave_amplitude : hint_range(0.0, 20.0) = 5.0;
uniform float wave_frequency : hint_range(0.0, 10.0) = 2.0;
uniform float hue_shift_speed : hint_range(0.0, 5.0) = 1.0;
uniform float aberration_offset : hint_range(0.0, 0.01) = 0.003;

void fragment() {
    // UV distortion wave
    vec2 uv = UV;
    uv.y += sin(uv.x * wave_frequency + time * 2.0) * (wave_amplitude / 100.0);

    // Chromatic aberration effect
    vec4 col;
    col.r = texture(TEXTURE, uv + vec2(aberration_offset, 0.0)).r;
    col.g = texture(TEXTURE, uv).g;
    col.b = texture(TEXTURE, uv - vec2(aberration_offset, 0.0)).b;
    col.a = texture(TEXTURE, uv).a;

    // Scanlines
    float scanline = sin(UV.y * 800.0 + time * 20.0) * scanline_strength;
    col.rgb -= scanline;

    // Hue shift (rotate hue)
    float angle = time * hue_shift_speed;
    float c = cos(angle);
    float s = sin(angle);
    mat3 hue_rotate = mat3(
        vec3(0.299 + 0.701 * c + 0.168 * s, 0.587 - 0.587 * c + 0.330 * s, 0.114 - 0.114 * c - 0.497 * s),
        vec3(0.299 - 0.299 * c - 0.328 * s, 0.587 + 0.413 * c + 0.035 * s, 0.114 - 0.114 * c + 0.292 * s),
        vec3(0.299 - 0.300 * c + 1.250 * s, 0.587 - 0.588 * c - 1.050 * s, 0.114 + 0.886 * c - 0.203 * s)
    );
    col.rgb = hue_rotate * col.rgb;

    COLOR = col;
}
