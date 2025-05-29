shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture;
uniform float blur_size = 2.0;
uniform int samples = 4;

void fragment() {
    vec2 pixel_size = blur_size * SCREEN_PIXEL_SIZE;
    vec2 uv = SCREEN_UV;
    vec4 color = vec4(0.0);
    int count = 0;

    for (int i = -samples; i <= samples; i++) {
        for (int j = -samples; j <= samples; j++) {
            vec2 offset_uv = uv + vec2(float(i), float(j)) * pixel_size;
            color += texture(screen_texture, offset_uv);
            count += 1;
        }
    }

    color /= float(count);
    COLOR = color;
}
