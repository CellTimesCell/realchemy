class_name CritterRun
extends Sprite2D
## A mouse that now and then scurries along the skirting board and slips into
## a crack. Position = where it pops out; it runs `distance` px along x (sign
## = direction) and vanishes. A click on it gets a line from the hero.

const RUN_FPS: float = 14.0
const CLICK_RADIUS: float = 10.0

@export var distance: float = 120.0
@export var speed: float = 90.0
@export var interval_min: float = 45.0
@export var interval_max: float = 90.0
@export var hero: Hero
@export var line_key: String = "SAY_MOUSE"
@export var squeak_sfx: String = "squeak"

var running: bool = false
var _start: Vector2 = Vector2.ZERO
var _t: float = 0.0
var _wait: float = 0.0
var _clicked: bool = false


func _ready() -> void:
	_start = position
	visible = false
	flip_h = distance < 0.0
	_wait = randf_range(interval_min, interval_max)


func _process(delta: float) -> void:
	if not running:
		_wait -= delta
		if _wait <= 0.0:
			run()
		return
	_t += delta
	var travelled: float = minf(_t * speed, absf(distance))
	position = _start + Vector2(roundf(signf(distance) * travelled), 0.0)
	frame = int(_t * RUN_FPS) % hframes
	if travelled >= absf(distance):
		running = false
		visible = false
		_wait = randf_range(interval_min, interval_max)


func _unhandled_input(event: InputEvent) -> void:
	if not running or _clicked:
		return
	var click: InputEventMouseButton = event as InputEventMouseButton
	if click and click.pressed and click.button_index == MOUSE_BUTTON_LEFT \
			and global_position.distance_to(get_global_mouse_position()) <= CLICK_RADIUS:
		get_viewport().set_input_as_handled()
		_clicked = true
		if AudioManager.has_sfx(squeak_sfx):
			AudioManager.play_sfx(squeak_sfx, 1.6)
		if is_instance_valid(hero) and hero.bubble:
			hero.bubble.say(line_key)


## One dash from the start point to the crack.
func run() -> void:
	running = true
	_clicked = false
	_t = 0.0
	position = _start
	visible = true
