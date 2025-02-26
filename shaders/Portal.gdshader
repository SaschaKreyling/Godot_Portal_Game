shader_type spatial;
render_mode cull_disabled, unshaded;

uniform sampler2D camTexture: source_color;
uniform float exposure = 1.0;

void fragment() {
    vec3 color = texture(camTexture, SCREEN_UV.xy).rgb;
    ALBEDO = color * exposure;     
}
