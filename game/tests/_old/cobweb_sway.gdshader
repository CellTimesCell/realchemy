shader_type canvas_item;
// Temporary art check: gentle cobweb sway. Pixels shift sideways by whole
// texels, more the farther they are from the anchor (where the web is attached).

uniform vec2 anchor = vec2(0.0, 0.0); // attachment point in UV space
uniform float max_shift_px = 2.0;
uniform float speed = 1.2;
uniform float phase = 0.0;
uniform float opacity = 0.75;

void fragment() {
	float reach = clamp(distance(UV, anchor) / 1.2, 0.0, 1.0);
	float wave = sin(TIME * speed + phase + UV.y * 2.5);
	float shift = floor(wave * max_shift_px * reach + 0.5);
	vec2 uv = UV + vec2(shift * TEXTURE_PIXEL_SIZE.x, 0.0);
	vec4 col = texture(TEXTURE, uv);
	col.a *= opacity;
	COLOR = col * COLOR;
}
