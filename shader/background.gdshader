shader_type canvas_item;

uniform float time_speed = 1.0;        // Speed of animation
uniform float wave_strength = 0.01;    // Amount of distortion
uniform float shimmer_strength = 0.02; // How much the shimmer affects color
uniform vec2 wave_freq = vec2(10.0, 6.0); // Frequency of the wave distortion

void fragment() {
    float t = TIME * time_speed;

    // Apply a wavy distortion to the UV
    vec2 wave = vec2(
        sin(UV.y * wave_freq.x + t),
        cos(UV.x * wave_freq.y + t)
    ) * wave_strength;

    vec2 uv = UV + wave;

    // Sample the texture
    vec4 tex_color = texture(TEXTURE, uv);

    // Add shimmer/light sweep effect with anti-aliasing
    float shimmer_pos = (UV.x + t * 0.2) * 30.0;
    float shimmer_raw = sin(shimmer_pos);

    // Compute shimmer derivative and apply smoothstep for AA
    float width = fwidth(shimmer_pos); // Pixel-space rate of change
    float shimmer = smoothstep(-width, width, shimmer_raw) * shimmer_strength;

    tex_color.rgb += shimmer;

    COLOR = tex_color;
}
