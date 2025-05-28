shader_type canvas_item;

uniform float dissolve_amount : hint_range(0.0, 1.0);
uniform sampler2D noise_texture;
uniform float noise_scale : hint_range(0.1, 10.0) = 1.0;
uniform float edge_smoothness : hint_range(0.01, 0.2) = 0.1;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    // Scale noise UV
    vec2 noise_uv = UV * noise_scale;
    float noise = texture(noise_texture, noise_uv).r;

    // Smooth dissolve transition
    float threshold = dissolve_amount;
    float alpha = smoothstep(threshold - edge_smoothness, threshold, noise);

    // Discard fully transparent pixels
    if (alpha <= 0.001) {
        discard;
    }

    tex_color.a *= alpha;

    COLOR = tex_color;
}
