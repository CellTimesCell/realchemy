shader_type canvas_item;
// Draught in the curtains painted into a room picture: inside each rect
// (texture pixels: x, y, w, h) rows shift sideways by whole pixels, nothing
// at the top (the rod) and up to `amplitude` px at the bottom hem. Each
// curtain has its own phase, so they never move in step.

uniform vec4 rects[6];
uniform int rect_count = 0;
uniform float amplitude = 1.0;
uniform float speed = 0.9;

void fragment() {
	vec2 tex_size = 1.0 / TEXTURE_PIXEL_SIZE;
	vec2 px = floor(UV * tex_size);
	float shift = 0.0;
	for (int i = 0; i < rect_count; i++) {
		vec4 r = rects[i];
		if (px.x >= r.x && px.x < r.x + r.z && px.y >= r.y && px.y < r.y + r.w) {
			float t = (px.y - r.y) / r.w;
			float wave = sin(TIME * speed + float(i) * 1.7 + px.y * 0.05) * sin(TIME * speed * 0.37 + float(i));
			shift = floor(wave * amplitude * t * t + 0.5);
		}
	}
	COLOR = texture(TEXTURE, (px + vec2(-shift, 0.0) + 0.5) * TEXTURE_PIXEL_SIZE);
}
