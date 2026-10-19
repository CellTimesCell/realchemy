shader_type canvas_item;
// Ghost look for any opaque sprite: translucent, green tint, soft outer glow,
// gentle vertical float (whole pixels) and a faint flicker.

uniform vec4 tint : source_color = vec4(0.62, 1.0, 0.78, 1.0);
uniform float tint_amount : hint_range(0.0, 1.0) = 0.45;
uniform float opacity : hint_range(0.0, 1.0) = 0.65;
uniform vec4 glow_color : source_color = vec4(0.55, 1.0, 0.75, 1.0);
uniform float glow_alpha : hint_range(0.0, 1.0) = 0.35;
uniform float float_px = 2.0;
uniform float float_speed = 1.6;
uniform float flicker = 0.08;

void vertex() {
	VERTEX.y += floor(sin(TIME * float_speed) * float_px + 0.5);
}

void fragment() {
	vec4 col = texture(TEXTURE, UV);
	vec2 px = TEXTURE_PIXEL_SIZE;
	// 1px halo: transparent pixels next to the silhouette glow.
	float near = 0.0;
	near = max(near, texture(TEXTURE, UV + vec2(px.x, 0.0)).a);
	near = max(near, texture(TEXTURE, UV - vec2(px.x, 0.0)).a);
	near = max(near, texture(TEXTURE, UV + vec2(0.0, px.y)).a);
	near = max(near, texture(TEXTURE, UV - vec2(0.0, px.y)).a);
	float pulse = 1.0 - flicker * (0.5 + 0.5 * sin(TIME * 13.0) * sin(TIME * 7.3));
	if (col.a > 0.5) {
		vec3 rgb = mix(col.rgb, col.rgb * tint.rgb + vec3(0.08, 0.12, 0.08), tint_amount);
		COLOR = vec4(rgb, opacity * pulse);
	} else if (near > 0.5) {
		COLOR = vec4(glow_color.rgb, glow_alpha * pulse);
	} else {
		COLOR = vec4(0.0);
	}
}
