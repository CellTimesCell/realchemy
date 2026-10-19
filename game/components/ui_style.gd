class_name UiStyle
extends RefCounted
## Text look for in-world UI: hotspot prompts (a small dark see-through plate)
## and the hero's speech bubble. Two size variants under review:
##   A - prompts in Tiny5, speech in Press Start 2P 8 px;
##   B - everything in Press Start 2P drawn at half scale: with the
##       canvas_items stretch the text is rendered at window resolution, so
##       on a 1280x720+ window it is half as big and just as crisp.
## The player picks it as Text size (Small = B, Large = A); SaveManager sets
## `variant` and tells listeners through EventBus.settings_changed.

const TINY5: String = "res://assets/fonts/_reserve/tiny5/Tiny5.ttf"
const PROMPT_BG: Color = Color(0.04, 0.02, 0.08, 0.6)
const BUBBLE_BG: Color = Color(0.07, 0.05, 0.12, 0.92)
const BUBBLE_BORDER: Color = Color(0.92, 0.88, 0.96, 1)

static var variant: String = ""


static func get_variant() -> String:
	return "A" if variant.is_empty() else variant


## Scale of in-world text nodes (B draws at half size).
static func text_scale() -> float:
	return 0.5 if get_variant() == "B" else 1.0


static func style_prompt(label: Label) -> void:
	var box: StyleBoxFlat = StyleBoxFlat.new()
	box.bg_color = PROMPT_BG
	box.content_margin_left = 3
	box.content_margin_right = 3
	box.content_margin_top = 1
	box.content_margin_bottom = 1
	label.add_theme_stylebox_override("normal", box)
	label.add_theme_constant_override("outline_size", 0)
	if get_variant() == "A" and ResourceLoader.exists(TINY5):
		label.add_theme_font_override("font", load(TINY5))
		label.add_theme_font_size_override("font_size", 8)
	else:
		label.remove_theme_font_override("font")
		label.remove_theme_font_size_override("font_size")
	label.autowrap_mode = TextServer.AUTOWRAP_OFF
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER


## Widest a speech bubble may get, in game pixels (A is narrower: the text
## is twice as big, so the bubble wraps into more lines).
static func bubble_max_width() -> float:
	return 136.0 if get_variant() == "A" else 168.0


static func bubble_box() -> StyleBoxFlat:
	var box: StyleBoxFlat = StyleBoxFlat.new()
	box.bg_color = BUBBLE_BG
	box.border_color = BUBBLE_BORDER
	box.set_border_width_all(1)
	box.content_margin_left = 4
	box.content_margin_right = 4
	box.content_margin_top = 3
	box.content_margin_bottom = 3
	return box
