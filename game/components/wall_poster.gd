class_name WallPoster
extends Node2D
## A flat thing on a wall (poster, scratched words) drawn in the wall's
## perspective. The wall is a quad (wall_quad: top-left, top-right,
## bottom-right, bottom-left in parent coords) that stands for a flat
## rectangle of wall_size "wall pixels"; `rect` places the poster on it.
## The picture and its title are rendered into a small SubViewport and
## stretched over the mapped quad, so the title bends with the wall.
## Titles are i18n keys drawn with a font (never by the generator): the first
## word at the top, the second at the bottom, like a concert bill.
## swing() turns the poster around its top-left nail in the wall plane.

const SHADOW_COLOR: Color = Color(0.0, 0.0, 0.0, 0.35)
const SHADOW_OFFSET: Vector2 = Vector2(1, 1)

@export var texture: Texture2D
## Canvas for a poster without a picture (scratched words).
@export var blank_size: Vector2i = Vector2i(48, 24)
@export var wall_quad: PackedVector2Array = PackedVector2Array([Vector2(0, 0), Vector2(100, 0), Vector2(100, 100), Vector2(0, 100)])
@export var wall_size: Vector2 = Vector2(100, 100)
## Poster position and size on the wall, in wall pixels.
@export var rect: Rect2 = Rect2(10, 10, 48, 64)
@export var title_top: String = ""
@export var title_bottom: String = ""
@export var title_font: Font
@export var title_color: Color = Color(1, 0.95, 0.6)
@export var title_outline: Color = Color(0.08, 0.02, 0.1)
@export var text_color: Color = Color(0.86, 0.82, 0.8, 0.9)
## Plain text in the middle (scratched words), an i18n key.
@export var body_text: String = ""
@export var body_font: Font
@export var has_shadow: bool = true
## Fixtures: a nail at the top-left (the swing pin) and tape on the right.
@export var nail: Texture2D
@export var tape: Texture2D

## Swing angle around the top-left nail, degrees (wall plane).
var swing_degrees: float = 0.0:
	set(value):
		swing_degrees = value
		_update()

var _viewport: SubViewport
var _poster: Polygon2D
var _shadow: Polygon2D
var _nail: Sprite2D
var _tape: Sprite2D


func _ready() -> void:
	var size: Vector2i = Vector2i(texture.get_size()) if texture else blank_size
	_viewport = SubViewport.new()
	_viewport.size = size
	_viewport.transparent_bg = true
	_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	_viewport.canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST
	add_child(_viewport)
	if texture:
		var picture: TextureRect = TextureRect.new()
		picture.texture = texture
		_viewport.add_child(picture)
	_add_label(title_top, 1, title_font, title_color, true)
	_add_label(title_bottom, size.y - 10, title_font, title_color, true)
	_add_label(body_text, 0, body_font, text_color, false)
	if has_shadow:
		_shadow = Polygon2D.new()
		_shadow.color = SHADOW_COLOR
		add_child(_shadow)
	_poster = Polygon2D.new()
	_poster.texture = _viewport.get_texture()
	_poster.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_poster.uv = PackedVector2Array([Vector2(0, 0), Vector2(size.x, 0), Vector2(size.x, size.y), Vector2(0, size.y)])
	add_child(_poster)
	if tape:
		_tape = Sprite2D.new()
		_tape.texture = tape
		add_child(_tape)
	if nail:
		_nail = Sprite2D.new()
		_nail.texture = nail
		add_child(_nail)
	_update()


## Turns the poster around its nail in the wall plane.
func swing(degrees: float, time: float) -> void:
	var tween: Tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "swing_degrees", swing_degrees + degrees, time)
	if _tape:
		_tape.visible = false


## Screen-space bounds of the poster (for hotspots).
func bounds() -> Rect2:
	var corners: PackedVector2Array = _corners()
	var r: Rect2 = Rect2(corners[0], Vector2.ZERO)
	for c: Vector2 in corners:
		r = r.expand(c)
	return Rect2(to_global(r.position), r.size)


## Wall pixels -> parent coords (bilinear over the wall quad).
func wall_to_local(p: Vector2) -> Vector2:
	var u: float = p.x / wall_size.x
	var v: float = p.y / wall_size.y
	var top: Vector2 = wall_quad[0].lerp(wall_quad[1], u)
	var bottom: Vector2 = wall_quad[3].lerp(wall_quad[2], u)
	return top.lerp(bottom, v)


func _corners() -> PackedVector2Array:
	var pin: Vector2 = rect.position
	var out: PackedVector2Array = []
	for local: Vector2 in [Vector2.ZERO, Vector2(rect.size.x, 0), rect.size, Vector2(0, rect.size.y)]:
		out.append(wall_to_local(pin + local.rotated(deg_to_rad(swing_degrees))))
	return out


func _update() -> void:
	if not _poster:
		return
	var corners: PackedVector2Array = _corners()
	_poster.polygon = corners
	if _shadow:
		var shifted: PackedVector2Array = []
		for c: Vector2 in corners:
			shifted.append(c + SHADOW_OFFSET)
		_shadow.polygon = shifted
	if _nail:
		_nail.position = corners[0].round()
	if _tape:
		_tape.position = corners[1].round()


func _add_label(key: String, y: int, font: Font, color: Color, outlined: bool) -> void:
	if key.is_empty():
		return
	var label: Label = Label.new()
	label.text = key
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.position = Vector2(0, y)
	label.size = Vector2(_viewport.size.x, 9)
	if font:
		label.add_theme_font_override("font", font)
		label.add_theme_font_size_override("font_size", 8)
	label.add_theme_color_override("font_color", color)
	label.add_theme_constant_override("outline_size", 2 if outlined else 0)
	label.add_theme_color_override("font_outline_color", title_outline)
	label.add_theme_constant_override("line_spacing", -1)
	if not outlined:
		label.size = Vector2(_viewport.size)
	_viewport.add_child(label)
