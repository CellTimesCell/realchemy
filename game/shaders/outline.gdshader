shader_type canvas_item;
// 1 px light outline around a sprite's opaque pixels, softly pulsing.
// Hotspot turns it on while the hero is near (or Tab shows all). The sprite
// texture needs 1 px of transparent margin for the outline to show there.
// The colour is "overbright" (> 1): the night CanvasModulate multiplies it
// afterwards, so it still reads as a light line in the dark rooms.

uniform bool enabled = false;
uniform vec3 outline_rgb = vec3(3.2, 3.0, 2.4);
uniform float pulse_speed = 3.0;
uniform float min_alpha = 0.7;

void fragment() {
	vec4 base = texture(TEXTURE, UV);
	COLOR = base;
	if (enabled && base.a < 0.5) {
		vec2 px = TEXTURE_PIXEL_SIZE;
		float n = texture(TEXTURE, UV + vec2(px.x, 0.0)).a
			+ texture(TEXTURE, UV - vec2(px.x, 0.0)).a
			+ texture(TEXTURE, UV + vec2(0.0, px.y)).a
			+ texture(TEXTURE, UV - vec2(0.0, px.y)).a;
		if (n > 0.5) {
			// Stepped pulse (4 levels): no smooth fades in pixel art.
			float wave = 0.5 + 0.5 * sin(TIME * pulse_speed);
			float a = mix(min_alpha, 1.0, floor(wave * 4.0) / 3.0);
			COLOR = vec4(outline_rgb, a);
		}
	}
}
