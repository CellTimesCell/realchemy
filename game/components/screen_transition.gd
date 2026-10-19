class_name ScreenTransition
extends CanvasLayer
## Full-screen transitions above everything: fade to black and back, and the
## iris wipe (a circle closing on a point, shaders/iris.gdshader) for comic
## moments. Debug: I plays iris out/in around `iris_target`.

const FADE_TIME: float = 0.3
const IRIS_TIME: float = 0.6
const IRIS_HOLD: float = 0.25
## Radius that covers the whole 16:9 screen from any point.
const IRIS_OPEN: float = 1.9

@export var fade_rect: ColorRect
@export var iris_rect: ColorRect
## Node the iris closes on (usually the hero).
@export var iris_target: Node2D
@export var debug_keys: bool = false

var busy: bool = false


func _ready() -> void:
	fade_rect.modulate.a = 0.0
	fade_rect.visible = false
	iris_rect.visible = false


func _unhandled_input(event: InputEvent) -> void:
	var key: InputEventKey = event as InputEventKey
	if debug_keys and key and key.pressed and not key.echo and key.physical_keycode == KEY_I and not busy:
		get_viewport().set_input_as_handled()
		iris_out_in()


func fade_out() -> void:
	fade_rect.visible = true
	var tween: Tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1.0, FADE_TIME)
	await tween.finished


func fade_in() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0.0, FADE_TIME)
	await tween.finished
	fade_rect.visible = false


func iris_out(target_screen_pos: Vector2 = Vector2(-1, -1)) -> void:
	_aim_iris(target_screen_pos)
	iris_rect.visible = true
	await _tween_iris(IRIS_OPEN, 0.0)


func iris_in(target_screen_pos: Vector2 = Vector2(-1, -1)) -> void:
	_aim_iris(target_screen_pos)
	await _tween_iris(0.0, IRIS_OPEN)
	iris_rect.visible = false


## Closes on the target, holds a moment on black, opens again.
func iris_out_in() -> void:
	busy = true
	await iris_out()
	await get_tree().create_timer(IRIS_HOLD).timeout
	await iris_in()
	busy = false


func _aim_iris(target_screen_pos: Vector2) -> void:
	var view: Vector2 = get_viewport().get_visible_rect().size
	var pos: Vector2 = target_screen_pos
	if pos.x < 0.0 and iris_target:
		# Aim a little above the feet, at the middle of the body.
		pos = iris_target.get_global_transform_with_canvas().origin + Vector2(0, -28)
	elif pos.x < 0.0:
		pos = view * 0.5
	var material: ShaderMaterial = iris_rect.material as ShaderMaterial
	material.set_shader_parameter("center", pos / view)
	material.set_shader_parameter("screen_px", view)


func _tween_iris(from: float, to: float) -> void:
	var material: ShaderMaterial = iris_rect.material as ShaderMaterial
	var tween: Tween = create_tween()
	tween.tween_method(func(r: float) -> void: material.set_shader_parameter("radius", r), from, to, IRIS_TIME)
	await tween.finished
