shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture;
uniform float time;

float scanline(vec2 uv, vec2 resolution) {
    return 0.1 + 0.15 * sin(uv.y * resolution.y * 1.5);
}

vec3 chromatic_aberration(sampler2D tex, vec2 uv, float offset) {
    float r = texture(tex, uv + vec2(offset, 0.0)).r;
    float g = texture(tex, uv).g;
    float b = texture(tex, uv - vec2(offset, 0.0)).b;
    return vec3(r, g, b);
}

void fragment() {
    vec2 uv = SCREEN_UV;

    // Slight vertical wave animation
    uv.y += 0.02 * sin(uv.x * 30.0 + time * 5.0);

    // Chromatic aberration offset
    float ca_offset = 0.002;
    vec3 color = chromatic_aberration(screen_texture, uv, ca_offset);

    color *= vec3(1.2, 1.0, 1.5);

    // Add scanline effect
    float sl = scanline(uv, vec2(textureSize(screen_texture, 0)));
    color *= sl;

    float dist = distance(uv, vec2(0.5));
    color *= smoothstep(0.8, 0.5, dist);

    COLOR = vec4(clamp(color, 0.0, 1.0), 1.0);
}
