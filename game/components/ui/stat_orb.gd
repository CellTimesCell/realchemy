class_name StatOrb
extends Control
## Health / energy orb on the HUD (placeholder: a coloured disc filled from
## the bottom, with a letter - CLAUDE.md §8). value / max_value set the fill.

@export var fill_color: Color = Color(0.85, 0.15, 0.2)
@export var letter: String = "H"

var value: int = 10
var max_value: int = 10


func _init() -> void:
	custom_minimum_size = Vector2(18, 18)
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func set_value(current: int, maximum: int) -> void:
	value = current
	max_value = maxi(1, maximum)
	queue_redraw()


func _draw() -> void:
	var r: float = size.x * 0.5
	var c: Vector2 = Vector2(r, r)
	draw_circle(c, r, Color(0.05, 0.03, 0.08, 0.9))
	var level: float = size.y * (1.0 - float(value) / float(max_value))
	# Fill: rows of the disc below the level line, whole pixels.
	for y: int in range(int(level), int(size.y)):
		var dy: float = float(y) + 0.5 - r
		var half: float = floor(sqrt(maxf(0.0, (r - 1.0) * (r - 1.0) - dy * dy)))
		if half > 0.0:
			draw_rect(Rect2(r - half, y, half * 2.0, 1), fill_color)
	draw_arc(c, r - 0.5, 0.0, TAU, 24, Color(0.75, 0.65, 0.85), 1.0)
	var font: Font = load(UiStyle.TINY5) if ResourceLoader.exists(UiStyle.TINY5) else ThemeDB.fallback_font
	draw_string(font, Vector2(r - 2, r + 3), letter, HORIZONTAL_ALIGNMENT_LEFT, -1, 8, Color(1, 1, 1, 0.9))
