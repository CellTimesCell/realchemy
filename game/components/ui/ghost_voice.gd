class_name GhostVoice
extends PanelContainer
## The ghost grandmother's voice when she is not on screen (hints, remarks
## from afar): a green-rimmed plate at the top centre, "Grandma: ...".

const SHOW_TIME: float = 4.5

var _label: Label
var _token: int = 0


func _ready() -> void:
	visible = false
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	var box: StyleBoxFlat = StyleBoxFlat.new()
	box.bg_color = Color(0.04, 0.1, 0.07, 0.92)
	box.border_color = Color(0.55, 1, 0.65)
	box.set_border_width_all(1)
	box.set_content_margin_all(4)
	add_theme_stylebox_override("panel", box)
	_label = Hud.make_label("")
	_label.add_theme_color_override("font_color", Color(0.75, 1, 0.8))
	_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_label.custom_minimum_size = Vector2(260, 0)
	add_child(_label)
	EventBus.ghost_line_requested.connect(say)


func say(key: String) -> void:
	if key.is_empty():
		return
	_token += 1
	var token: int = _token
	_label.text = "%s %s" % [tr("UI_GRANDMA"), tr(key)]
	visible = true
	size = Vector2.ZERO
	reset_size()
	position = Vector2(floorf((get_viewport().get_visible_rect().size.x - size.x) * 0.5), 6)
	await get_tree().create_timer(SHOW_TIME).timeout
	if token == _token:
		visible = false
