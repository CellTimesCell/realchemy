class_name FirstPersonView
extends CanvasLayer
## A first-person screen (scene type "first_person"): a 640x360 picture with
## no hero on it, a hand cursor (point / grab), hotspots from JSON. Clicking a
## hotspot opens a small verb menu; a verb says a line (the hero's inner
## monologue at the bottom), moves a node (a poster slides away), plays an
## effect (spray) or takes an item (ItemPop + EventBus.item_found).
## open() / close() fade through the ScreenTransition; Back (button, Esc,
## right click) closes. Data: data/first_person/<id>.json, see DATA_SCHEMA.

signal closed_view

const MONOLOGUE_TIME: float = 3.5
const MOVE_TIME: float = 0.4

@export_file("*.json") var data_path: String = ""
@export var transition: ScreenTransition
## Children named in the JSON (posters, effects, items) live under this node.
@export var content: Node2D
@export var cursor: Sprite2D
@export var cursor_point: Texture2D
@export var cursor_grab: Texture2D
@export var verb_menu: VBoxContainer
@export var monologue: PanelContainer
@export var monologue_label: Label
@export var back_button: Button
## Close-up panel (the toilet remote): buttons built from data "closeups".
@export var closeup: PanelContainer
@export var closeup_row: HBoxContainer
## Font for close-up button labels (Japanese, DotGothic16).
@export var closeup_font: Font

var data: Dictionary = {}
var is_open: bool = false
var _hotspots: Array[Dictionary] = []
var _active: Dictionary = {}
var _used: Dictionary = {}
var _entered_once: bool = false
var _say_token: int = 0


func _ready() -> void:
	add_to_group(&"persist")
	visible = false
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(data_path))
	data = parsed if parsed is Dictionary else {}
	for entry: Dictionary in data.get("hotspots", []):
		_hotspots.append(entry)
	verb_menu.visible = false
	closeup.visible = false
	monologue.visible = false
	monologue.add_theme_stylebox_override("panel", UiStyle.bubble_box())
	back_button.text = "UI_BACK"
	back_button.pressed.connect(close)


func save_state() -> Dictionary:
	return {"used": _used.keys(), "entered": _entered_once}


## Moved posters stay moved, taken things stay gone.
func load_state(state: Dictionary) -> void:
	_entered_once = bool(state.get("entered", false))
	for key: String in state.get("used", []):
		_used[key] = true
		var node: Node = content.get_node_or_null(key)
		if node is WallPoster:
			(node as WallPoster).swing(_rotation_for(key), 0.0)
		for entry: Dictionary in _hotspots:
			if entry.get("id", "") == key:
				for verb: Dictionary in entry.get("verbs", []):
					var target: CanvasItem = content.get_node_or_null(verb.get("target", "")) as CanvasItem
					if verb.get("action", "") == "take" and target:
						target.visible = false


func _rotation_for(target: String) -> float:
	for entry: Dictionary in _hotspots:
		for verb: Dictionary in entry.get("verbs", []):
			if verb.get("action", "") == "move" and verb.get("target", "") == target:
				return float(verb.get("rotate", 0.0))
	return 0.0


func open() -> void:
	if is_open:
		return
	EventBus.set_modal_ui(true)
	await transition.fade_out()
	visible = true
	is_open = true
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	await transition.fade_in()
	if not _entered_once:
		_entered_once = true
		say(data.get("enter_line_key", ""))


func close() -> void:
	if not is_open:
		return
	is_open = false
	verb_menu.visible = false
	await transition.fade_out()
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	await transition.fade_in()
	EventBus.set_modal_ui(false)
	closed_view.emit()


func _process(_delta: float) -> void:
	if not is_open:
		return
	var mouse: Vector2 = content.get_global_mouse_position()
	cursor.position = mouse.round()
	var hover: Dictionary = hotspot_at(mouse)
	cursor.texture = cursor_grab if not hover.is_empty() else cursor_point


func _unhandled_input(event: InputEvent) -> void:
	if not is_open:
		return
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		if verb_menu.visible or closeup.visible:
			verb_menu.visible = false
			closeup.visible = false
		else:
			close()
		return
	var click: InputEventMouseButton = event as InputEventMouseButton
	if click and click.pressed:
		get_viewport().set_input_as_handled()
		if click.button_index == MOUSE_BUTTON_RIGHT:
			close()
		elif click.button_index == MOUSE_BUTTON_LEFT and not closeup.visible:
			_open_menu(hotspot_at(content.get_global_mouse_position()), click.position)


## The hotspot under a point of the 640x360 picture (empty if none).
func hotspot_at(point: Vector2) -> Dictionary:
	for entry: Dictionary in _hotspots:
		if _entry_rect(entry).has_point(point) and _is_available(entry):
			return entry
	return {}


## Runs one verb of a hotspot (also used by tests and the verb menu).
func run_verb(entry: Dictionary, verb: Dictionary) -> void:
	verb_menu.visible = false
	closeup.visible = false
	match verb.get("action", "say"):
		"closeup":
			_open_closeup(entry, verb.get("target", ""))
		"move":
			var target: String = verb.get("target", "")
			var node: Node2D = content.get_node_or_null(target) as Node2D
			if node and not _used.has(target):
				_used[target] = true
				AudioManager.play_sfx(verb.get("sfx", "creak"))
				if node is WallPoster:
					# Posters move in their wall's plane (perspective kept).
					(node as WallPoster).swing(float(verb.get("rotate", 0.0)), MOVE_TIME)
				else:
					var offset: Array = verb.get("offset", [0, 0])
					var tween: Tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
					tween.tween_property(node, "position", node.position + Vector2(offset[0], offset[1]), MOVE_TIME)
					# "rotate": swing around the node origin.
					if verb.has("rotate"):
						tween.parallel().tween_property(node, "rotation_degrees", node.rotation_degrees + float(verb["rotate"]), MOVE_TIME)
		"fx":
			var fx: CPUParticles2D = content.get_node_or_null(verb.get("target", "")) as CPUParticles2D
			if fx:
				fx.restart()
				fx.emitting = true
			AudioManager.play_sfx(verb.get("sfx", ""))
		"react":
			# The workbench: chemistry from the hero's things (ChemistryEngine).
			var result: Dictionary = ChemistryEngine.run(verb.get("reaction", ""))
			if result["ok"]:
				AudioManager.play_sfx(verb.get("sfx", ""))
			say(result["line_key"])
			return
		"take":
			var item_node: CanvasItem = content.get_node_or_null(verb.get("target", "")) as CanvasItem
			if item_node and item_node.visible:
				var item: Dictionary = verb.get("item", {})
				if not GameManager.give_item(item.get("id", "")):
					say(GameManager.POCKETS_FULL_KEY)
					return
				item_node.visible = false
				ItemPop.spawn(get_tree(), (item_node as Node2D).global_position, Color(item.get("color", "#ffffff")), item.get("letter", "?"))
				_used[entry.get("id", "")] = true
	say(verb.get("line_key", ""))


## The hero's inner monologue at the bottom of the screen.
func say(key: String) -> void:
	if key.is_empty():
		return
	_say_token += 1
	var token: int = _say_token
	monologue_label.text = key
	monologue.visible = true
	await get_tree().create_timer(MONOLOGUE_TIME).timeout
	if token == _say_token:
		monologue.visible = false


## A hotspot's area: "rect" [x, y, w, h], or the current bounds of a wall
## poster named in "rect_from" (it follows the poster when it swings).
func _entry_rect(entry: Dictionary) -> Rect2:
	var from: String = entry.get("rect_from", "")
	if not from.is_empty():
		var poster: WallPoster = content.get_node_or_null(from) as WallPoster
		if poster:
			return poster.bounds()
	var r: Array = entry.get("rect", [0, 0, 0, 0])
	return Rect2(r[0], r[1], r[2], r[3])


func _is_available(entry: Dictionary) -> bool:
	# A hotspot can need a moved node (scratches behind a poster) or vanish
	# once its item is taken.
	var needs: String = entry.get("needs_moved", "")
	if not needs.is_empty() and not _used.has(needs):
		return false
	return not (entry.get("once", false) and _used.has(entry.get("id", "")))


func _open_menu(entry: Dictionary, screen_pos: Vector2) -> void:
	for child: Node in verb_menu.get_children():
		child.queue_free()
	if entry.is_empty():
		verb_menu.visible = false
		return
	for verb: Dictionary in entry.get("verbs", []):
		var button: Button = Button.new()
		button.text = verb.get("verb", "UI_INSPECT")
		button.focus_mode = Control.FOCUS_NONE
		button.pressed.connect(run_verb.bind(entry, verb))
		verb_menu.add_child(button)
	verb_menu.visible = true
	verb_menu.reset_size()
	var view: Vector2 = get_viewport().get_visible_rect().size
	verb_menu.position = (screen_pos + Vector2(8, -4)).clamp(Vector2.ZERO, view - verb_menu.size)


func _open_closeup(entry: Dictionary, closeup_id: String) -> void:
	for child: Node in closeup_row.get_children():
		child.queue_free()
	for button_data: Dictionary in data.get("closeups", {}).get(closeup_id, []):
		var button: Button = Button.new()
		# In-world signage, not localized: the joke is that it can't be read.
		button.text = button_data.get("label", "?")
		button.auto_translate_mode = Node.AUTO_TRANSLATE_MODE_DISABLED
		button.focus_mode = Control.FOCUS_NONE
		if closeup_font:
			button.add_theme_font_override("font", closeup_font)
			button.add_theme_font_size_override("font_size", 16)
		button.pressed.connect(run_verb.bind(entry, button_data))
		closeup_row.add_child(button)
	closeup.visible = true
