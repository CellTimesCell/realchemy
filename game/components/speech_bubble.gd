class_name SpeechBubble
extends PanelContainer
## The hero's line in a framed bubble with a little tail, above his head and
## always above the emote zone (emotes sit up to ~25 px over the head top), so
## a line never covers an icon. Drawn on the "above_night" layer, kept inside
## the screen. Size and font follow UiStyle (variant A/B).

const MAX_WIDTH: float = 168.0
const SCREEN_MARGIN: float = 4.0
const TAIL: PackedVector2Array = [Vector2(-3, 0), Vector2(3, 0), Vector2(0, 4)]

## The head-top marker of the speaker.
@export var anchor: Node2D
## Gap between the head top and the bubble's tail (room for emotes).
@export var clearance: float = 28.0
@export var show_time: float = 3.0

var _label: Label
var _tail: Polygon2D
var _token: int = 0


func _ready() -> void:
	visible = false
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_theme_stylebox_override("panel", UiStyle.bubble_box())
	_label = Label.new()
	_label.add_theme_constant_override("outline_size", 0)
	_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(_label)
	_tail = Polygon2D.new()
	_tail.polygon = TAIL
	_tail.color = UiStyle.BUBBLE_BORDER
	add_child(_tail)
	var s: float = UiStyle.text_scale()
	scale = Vector2(s, s)
	var layer: Node = get_tree().get_first_node_in_group(&"above_night")
	if layer:
		reparent.call_deferred(layer, false)


## Shows the line (an i18n key) for show_time seconds; returns when hidden.
func say(key: String, time: float = -1.0) -> void:
	if key.is_empty():
		return
	_token += 1
	var token: int = _token
	_label.text = key
	var text: String = tr(key)
	var font: Font = _label.get_theme_font("font")
	var width: float = font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, _label.get_theme_font_size("font_size")).x
	if width > MAX_WIDTH:
		_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_label.custom_minimum_size.x = MAX_WIDTH
	else:
		_label.autowrap_mode = TextServer.AUTOWRAP_OFF
		_label.custom_minimum_size.x = 0.0
	reset_size()
	visible = true
	_place()
	await get_tree().create_timer(show_time if time < 0.0 else time).timeout
	if token == _token:
		visible = false


func is_speaking() -> bool:
	return visible


func _process(_delta: float) -> void:
	if visible:
		_place()


func _place() -> void:
	if not is_instance_valid(anchor):
		return
	# Container minimum size settles a frame late after the text changes.
	size = get_combined_minimum_size()
	var s: float = scale.x
	var box: Vector2 = size * s
	var head: Vector2 = anchor.global_position
	var pos: Vector2 = Vector2(head.x - box.x * 0.5, head.y - clearance - box.y)
	# Keep the bubble on screen (the layer follows the camera).
	var view: Rect2 = get_viewport().get_visible_rect()
	var to_world: Transform2D = get_viewport().get_canvas_transform().affine_inverse()
	var left: float = (to_world * view.position).x + SCREEN_MARGIN
	var right: float = (to_world * view.end).x - SCREEN_MARGIN - box.x
	pos.x = clampf(pos.x, left, maxf(left, right))
	position = pos.round()
	_tail.position = Vector2((head.x - pos.x) / s, size.y)
