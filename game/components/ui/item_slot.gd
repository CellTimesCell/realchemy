class_name ItemSlot
extends Button
## One inventory / hand cell: the item's sprite, or a placeholder square in
## the item's colour with its letter (CLAUDE.md §8), a stack count, and a
## tiny caption ("L", "R"). Emits `pressed` like any button.

const SIZE: Vector2 = Vector2(20, 20)
const BG: Color = Color(0.08, 0.05, 0.12, 0.85)
const BORDER: Color = Color(0.55, 0.45, 0.65, 1)
const BORDER_ACTIVE: Color = Color(1, 0.85, 0.45, 1)

var item_id: String = ""
var caption: String = ""
var _box: StyleBoxFlat


func _init(slot_caption: String = "") -> void:
	caption = slot_caption
	custom_minimum_size = SIZE
	focus_mode = Control.FOCUS_NONE
	clip_contents = true
	_box = StyleBoxFlat.new()
	_box.bg_color = BG
	_box.border_color = BORDER
	_box.set_border_width_all(1)
	for style: String in ["normal", "hover", "pressed", "disabled"]:
		add_theme_stylebox_override(style, _box)


func set_item(id: String, count: int = 1) -> void:
	item_id = id
	for child: Node in get_children():
		child.queue_free()
	if not caption.is_empty():
		_label(caption, Vector2(1, -2), Color(0.7, 0.62, 0.8))
	if id.is_empty():
		return
	var icon_texture: Texture2D = ItemDb.icon(id)
	if icon_texture:
		var icon_rect: TextureRect = TextureRect.new()
		icon_rect.texture = icon_texture
		icon_rect.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
		icon_rect.size = SIZE
		icon_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(icon_rect)
	else:
		var square: ColorRect = ColorRect.new()
		square.color = ItemDb.color(id)
		square.position = Vector2(5, 5)
		square.size = Vector2(10, 10)
		square.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(square)
		_centered(ItemDb.letter(id), square)
	if count > 1:
		_label(str(count), Vector2(13, 10), Color(1, 1, 1))


## A HUD button look: a placeholder square with a symbol (no item).
func set_symbol(symbol: String, color: Color) -> void:
	set_item("")
	var square: ColorRect = ColorRect.new()
	square.color = color
	square.position = Vector2(4, 4)
	square.size = Vector2(12, 12)
	square.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(square)
	_centered(symbol, square)


func set_active(active: bool) -> void:
	_box.border_color = BORDER_ACTIVE if active else BORDER


## A dark letter centred on a placeholder square.
func _centered(text_value: String, square: ColorRect) -> void:
	var label: Label = _label(text_value, square.position, Color(0.08, 0.04, 0.1))
	label.size = square.size
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER


func _label(text_value: String, at: Vector2, color: Color) -> Label:
	var label: Label = Label.new()
	label.text = text_value
	label.auto_translate_mode = Node.AUTO_TRANSLATE_MODE_DISABLED
	label.position = at
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_color_override("font_color", color)
	if ResourceLoader.exists(UiStyle.TINY5):
		label.add_theme_font_override("font", load(UiStyle.TINY5))
		label.add_theme_font_size_override("font_size", 8)
	add_child(label)
	return label
