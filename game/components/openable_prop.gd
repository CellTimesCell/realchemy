class_name OpenableProp
extends Node2D
## Prop with closed/open states (wardrobe, chest...). While the hero stands in
## the hotspot, ui_accept toggles it open; the "inside" node shows when open.

signal opened(prop: OpenableProp)

@export var sprite: Sprite2D
@export var closed_texture: Texture2D
@export var open_texture: Texture2D
@export var inside: Node2D
@export var hotspot: Hotspot
@export var start_open: bool = false

var is_open: bool = false
var _hero_near: bool = false


func _ready() -> void:
	hotspot.hero_entered.connect(func(_h: Hotspot) -> void: _hero_near = true)
	hotspot.hero_exited.connect(func(_h: Hotspot) -> void: _hero_near = false)
	_set_open(start_open)


func _unhandled_input(event: InputEvent) -> void:
	if EventBus.modal_ui_active:
		return
	if _hero_near and not is_open and event.is_action_pressed("ui_accept"):
		_set_open(true)
		opened.emit(self)


func _set_open(value: bool) -> void:
	is_open = value
	sprite.texture = open_texture if value else closed_texture
	if inside:
		inside.visible = value
	if hotspot.prompt:
		hotspot.prompt.text = "" if value else hotspot.prompt_text
