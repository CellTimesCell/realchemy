shader_type canvas_item;
// Ghost look for any opaque sprite: translucent, green tint, glowing rim and
// 2px outer halo, hem that dissolves towards the bottom, gentle vertical float
// (whole pixels) and a faint flicker. Works per frame texture (no atlases).

uniform vec4 tint : source_color = vec4(0.42, 1.0, 0.58, 1.0);
uniform float tint_amount : hint_range(0.0, 1.0) = 0.8;
uniform float opacity : hint_range(0.0, 1.0) = 0.55;
uniform vec4 glow_color : source_color = vec4(0.55, 1.0, 0.6, 1.0);
uniform float glow_alpha : hint_range(0.0, 1.0) = 0.6;
// Silhouette pixels touching the outside are lightened towards glow_color.
uniform float rim_amount : hint_range(0.0, 1.0) = 0.55;
// Alpha fades out over the last fade_px rows above fade_end (UV.y of the hem).
uniform float fade_px = 10.0;
uniform float fade_end : hint_range(0.0, 1.0) = 1.0;
uniform float fade_min : hint_range(0.0, 1.0) = 0.1;
uniform float float_px = 2.0;
uniform float float_speed = 1.6;
uniform float flicker = 0.08;

void vertex() {
	VERTEX.y += floor(sin(TIME * float_speed) * float_px + 0.5);
}

// Max alpha of the four neighbours `step` away (inlined: TEXTURE cannot be
// passed to a function - the shader compiler rejects it).
#define RING(step) max(max(texture(TEXTURE, UV + vec2(step.x, 0.0)).a, texture(TEXTURE, UV - vec2(step.x, 0.0)).a), max(texture(TEXTURE, UV + vec2(0.0, step.y)).a, texture(TEXTURE, UV - vec2(0.0, step.y)).a))

void fragment() {
	vec4 col = texture(TEXTURE, UV);
	vec2 px = TEXTURE_PIXEL_SIZE;
	float pulse = 1.0 - flicker * (0.5 + 0.5 * sin(TIME * 13.0) * sin(TIME * 7.3));
	// Whole-pixel row distance to the hem: the dissolve stays pixel-crisp.
	float rows_left = floor((fade_end - UV.y) / px.y);
	float fade = mix(fade_min, 1.0, clamp(rows_left / fade_px, 0.0, 1.0));
	if (col.a > 0.5) {
		vec3 rgb = mix(col.rgb, col.rgb * tint.rgb + vec3(0.06, 0.14, 0.08), tint_amount);
		// Rim: an edge pixel has a transparent neighbour.
		float inner = min(min(texture(TEXTURE, UV + vec2(px.x, 0.0)).a, texture(TEXTURE, UV - vec2(px.x, 0.0)).a),
				min(texture(TEXTURE, UV + vec2(0.0, px.y)).a, texture(TEXTURE, UV - vec2(0.0, px.y)).a));
		if (inner < 0.5) {
			rgb = mix(rgb, glow_color.rgb, rim_amount);
		}
		COLOR = vec4(rgb, opacity * pulse * fade);
	} else if (RING(px) > 0.5) {
		COLOR = vec4(glow_color.rgb, glow_alpha * pulse * fade);
	} else if (RING((px * 2.0)) > 0.5) {
		COLOR = vec4(glow_color.rgb, glow_alpha * 0.45 * pulse * fade);
	} else {
		COLOR = vec4(0.0);
	}
}
