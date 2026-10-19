shader_type canvas_item;
// Iris wipe (old cartoon "circle closes on the hero"). Put on a full-screen
// ColorRect. Everything outside the circle is the rect colour. The edge is
// snapped to whole game pixels so it stays crisp pixel art.

uniform vec2 center = vec2(0.5, 0.5); // in screen UV
uniform float radius : hint_range(0.0, 2.0) = 2.0; // in screen heights
uniform vec2 screen_px = vec2(640.0, 360.0); // base resolution

void fragment() {
	vec2 px = floor(UV * screen_px) + 0.5;
	vec2 c = center * screen_px;
	float d = length(px - c) / screen_px.y;
	COLOR = vec4(COLOR.rgb, d > radius ? COLOR.a : 0.0);
}
