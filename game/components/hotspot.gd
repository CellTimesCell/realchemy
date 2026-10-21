class_name Hotspot
extends Area2D
## Interactive spot: while the hero stands inside the area its prop gets a
## soft pulsing outline (shaders/outline.gdshader) and a small prompt on a
## dark see-through plate. Holding "show_all" (Tab) outlines every hotspot.
## Texts are localization keys. If say_key is set, ui_accept says that line.
## Lines go to the hero's speech bubble (above his emotes); without a hero
## they replace the prompt for a few seconds.
## Prompts hide and input is ignored while a modal UI is open (EventBus).
## An item in the hero's hand with a use rule for `target_id`
## (data/use_rules.json) turns the prompt into "Verb (Item)" and ui_accept
## applies it (GameManager) before anything else.
## The prompt label moves onto the "above_night" CanvasLayer, so the night
## tint does not grey it out, and follows the hotspot.

signal hero_entered(hotspot: Hotspot)
signal hero_exited(hotspot: Hotspot)

const SAY_TIME: float = 3.0
const OVERLAY_GROUP: StringName = &"above_night"
const SHOW_ALL_ACTION: StringName = &"show_all"
const OUTLINE_SHADER: String = "res://shaders/outline.gdshader"

@export var prompt_text: String = "UI_INSPECT"
@export var say_key: String = ""
@export var prompt: Label
## Sprite that gets the outline; by default the parent's "Sprite" child.
@export var outline_sprite: Sprite2D
## Id for use rules; empty = the parent's interactable_id or its name.
@export var target_id: String = ""

## The hero standing in the area (null when nobody is).
var hero: Hero
var _hero_inside: bool = false
var _saying: bool = false
var _prompt_anchor: Vector2 = Vector2.ZERO
var _prompt_moved: bool = false
var _outline: ShaderMaterial
var _item_prompt: String = ""


func _ready() -> void:
	if target_id.is_empty():
		var parent_id: Variant = get_parent().get("interactable_id")
		target_id = parent_id if parent_id is String and not (parent_id as String).is_empty() 				else (get_parent().name as String).to_snake_case()
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	EventBus.modal_ui_changed.connect(_on_modal_ui_changed)
	_setup_outline()
	if prompt:
		prompt.text = prompt_text
		prompt.visible = false
		# Anchor = bottom centre of the label rect set in the scene.
		_prompt_anchor = Vector2((prompt.offset_left + prompt.offset_right) * 0.5, prompt.offset_bottom)
		UiStyle.style_prompt(prompt)
		EventBus.settings_changed.connect(func(_key: String) -> void: UiStyle.style_prompt(prompt))
		var overlay: CanvasLayer = get_tree().get_first_node_in_group(OVERLAY_GROUP) as CanvasLayer
		if overlay:
			_prompt_moved = true
			prompt.reparent.call_deferred(overlay, false)


func _process(_delta: float) -> void:
	var lit: bool = is_visible_in_tree() and not EventBus.modal_ui_active and (_hero_inside or _show_all())
	if _outline:
		_outline.set_shader_parameter("enabled", lit)
	if prompt and _hero_inside and not _saying:
		var item_prompt: String = GameManager.item_prompt(target_id)
		if item_prompt != _item_prompt:
			_item_prompt = item_prompt
			prompt.text = item_prompt if not item_prompt.is_empty() else prompt_text
			_update_prompt_visibility()
	if prompt and prompt.visible:
		var s: float = UiStyle.text_scale()
		prompt.scale = Vector2(s, s)
		prompt.reset_size()
		var base: Vector2 = global_position if _prompt_moved else Vector2.ZERO
		prompt.position = (base + _prompt_anchor - Vector2(prompt.size.x * s * 0.5, prompt.size.y * s)).round()


func _exit_tree() -> void:
	if _prompt_moved and is_instance_valid(prompt):
		prompt.queue_free()


func _unhandled_input(event: InputEvent) -> void:
	if not _hero_inside or not is_visible_in_tree() or EventBus.modal_ui_active:
		return
	if event.is_action_pressed("ui_accept") and not (hero and hero.acting) 			and not GameManager.rule_for(target_id).is_empty():
		get_viewport().set_input_as_handled()
		GameManager.use_held_on(target_id)
		return
	if say_key.is_empty():
		return
	if event.is_action_pressed("ui_accept") and prompt:
		get_viewport().set_input_as_handled()
		say(say_key)


## True while the hero stands in the area and nothing modal is open.
func is_active() -> bool:
	return _hero_inside and is_visible_in_tree() and not EventBus.modal_ui_active and not (hero and hero.acting)


## Says a line: in the hero's bubble (the prompt hides meanwhile), or in
## place of the prompt when there is no hero bubble.
func say(key: String) -> void:
	if key.is_empty():
		return
	if hero and hero.bubble:
		_saying = true
		_update_prompt_visibility()
		await hero.bubble.say(key)
		_saying = false
		_update_prompt_visibility()
		return
	if not prompt:
		return
	prompt.text = key
	await get_tree().create_timer(SAY_TIME).timeout
	if prompt.text == key:
		prompt.text = prompt_text


func _show_all() -> bool:
	return InputMap.has_action(SHOW_ALL_ACTION) and Input.is_action_pressed(SHOW_ALL_ACTION)


func _setup_outline() -> void:
	if not outline_sprite:
		outline_sprite = get_parent().get_node_or_null("Sprite") as Sprite2D
	if not outline_sprite or outline_sprite.material or not ResourceLoader.exists(OUTLINE_SHADER):
		return
	_outline = ShaderMaterial.new()
	_outline.shader = load(OUTLINE_SHADER)
	outline_sprite.material = _outline


## Re-checks whether the prompt should show (after prompt_text changes).
func refresh_prompt() -> void:
	_update_prompt_visibility()


func _update_prompt_visibility() -> void:
	if prompt:
		prompt.visible = _hero_inside and not _saying and not EventBus.modal_ui_active 				and not (prompt_text.is_empty() and _item_prompt.is_empty())


func _on_body_entered(body: Node2D) -> void:
	if body is Hero and is_visible_in_tree():
		hero = body as Hero
		_hero_inside = true
		_update_prompt_visibility()
		hero_entered.emit(self)


func _on_body_exited(body: Node2D) -> void:
	if body is Hero:
		hero = null
		_hero_inside = false
		_update_prompt_visibility()
		hero_exited.emit(self)


func _on_modal_ui_changed(_active: bool) -> void:
	_update_prompt_visibility()
