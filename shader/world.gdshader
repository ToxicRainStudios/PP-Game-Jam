shader_type canvas_item;
uniform float wave_freq = 5.0;
uniform float wave_speed = 2.0;
uniform float wave_amp = 0.01;
uniform vec4 tint_color = vec4(1.0, 1.0, 1.0, 1.0);

uniform vec2 atlas_uv_min; // e.g., (0.25, 0.25)
uniform vec2 atlas_uv_max; // e.g., (0.5, 0.5)

void fragment() {
    vec2 uv = UV;

    vec2 wave_offset;
    wave_offset.x = sin(SCREEN_UV.y * wave_freq + TIME * wave_speed) * wave_amp * 0.5;
    wave_offset.y = sin(SCREEN_UV.x * wave_freq + TIME * wave_speed) * wave_amp;

    vec2 sampled_uv = uv + wave_offset;

    float edge_fade = smoothstep(0.01, 0.1, uv.x) * smoothstep(0.01, 0.1, uv.y) *
                      smoothstep(0.99, 0.9, uv.x) * smoothstep(0.99, 0.9, uv.y);
    sampled_uv = mix(uv, sampled_uv, edge_fade);

    // Convert to 0-1 relative to the atlas region, wrap, then remap to atlas space
    vec2 region_size = atlas_uv_max - atlas_uv_min;
    vec2 wrapped_uv = fract((sampled_uv - atlas_uv_min) / region_size) * region_size + atlas_uv_min;

    COLOR = texture(TEXTURE, wrapped_uv) * tint_color;
}
