shader_type canvas_item;

uniform sampler2D mask_texture;

void fragment() {
    vec4 base_color = COLOR;
    vec4 mask = texture(mask_texture, UV);

    base_color.a *= (1.0 - mask.r);
    COLOR = base_color;
}