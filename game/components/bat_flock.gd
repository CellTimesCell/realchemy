class_name BatFlock
extends Node2D
## A small flock of bats that crosses the room now and then in a wave: each
## bat rides a sine (own phase, a little spread), wings flapping. Behind the
## window glass (a node between the sky and the room picture) they are just
## life outside; under the vaults (`interactive`) a click on them or the hero
## standing under them makes him wave - and the bats scatter, squeaking,
## unharmed. Spies of the Count, maybe (CASTLE.md [?]).

signal scattered

const FLAP_FPS: float = 12.0
const FLAP_FRAMES: Array[int] = [0, 1, 2, 3, 4, 3, 2, 1]
const SCATTER_TIME: float = 0.9
const CLICK_RADIUS: float = 12.0

@export var texture: Texture2D
@export var hframes: int = 5
@export var count: int = 5
## Flight from x_from to x_to (either way, picked at random), around base_y.
@export var x_from: float = 0.0
@export var x_to: float = 640.0
@export var base_y: float = 120.0
@export var amplitude: float = 10.0
@export var wave_length: float = 90.0
@export var speed: float = 70.0
@export var spread: Vector2 = Vector2(36, 14)
@export var interval_min: float = 30.0
@export var interval_max: float = 90.0
## Under the dark vaults the night tint swallows them: brighten a little.
@export var tint: Color = Color.WHITE
@export var interactive: bool = false
@export var hero: Hero
## The hero counts as "under them" within this many px along x.
@export var hero_reach: float = 40.0
@export var squeak_sfx: String = "squeak"
@export var missed_line_key: String = "SAY_BATS_MISSED"

var flying: bool = false
var _bats: Array[Sprite2D] = []
var _offsets: Array[Vector2] = []
var _phases: Array[float] = []
var _wait: float = 0.0
var _t: float = 0.0
var _dir: float = 1.0
var _scattering: bool = false


func _ready() -> void:
	for i: int in count:
		var bat: Sprite2D = Sprite2D.new()
		bat.texture = texture
		bat.hframes = hframes
		bat.self_modulate = tint
		bat.visible = false
		add_child(bat)
		_bats.append(bat)
		_offsets.append(Vector2(randf_range(0.0, spread.x), randf_range(-spread.y, spread.y)))
		_phases.append(randf_range(0.0, TAU))
	_wait = randf_range(interval_min, interval_max)


func _process(delta: float) -> void:
	if not flying:
		_wait -= delta
		if _wait <= 0.0:
			fly()
		return
	_t += delta
	if _scattering:
		# Wings keep beating while they flee.
		for i: int in _bats.size():
			_bats[i].frame = FLAP_FRAMES[(int(_t * FLAP_FPS * 1.5) + i * 3) % FLAP_FRAMES.size()]
		return
	var lead: float = (x_from if _dir > 0.0 else x_to) + _dir * _t * speed
	var all_out: bool = true
	for i: int in _bats.size():
		var bat: Sprite2D = _bats[i]
		var x: float = lead - _dir * _offsets[i].x
		var y: float = base_y + _offsets[i].y + sin(x / wave_length * TAU + _phases[i]) * amplitude
		bat.position = Vector2(roundf(x), roundf(y))
		bat.frame = FLAP_FRAMES[(int(_t * FLAP_FPS) + i * 3) % FLAP_FRAMES.size()]
		bat.visible = x >= x_from - 16.0 and x <= x_to + 16.0
		if bat.visible:
			all_out = false
	if all_out and _t > 0.5:
		_land()
	elif interactive and is_instance_valid(hero) and _hero_under():
		scatter()


func _unhandled_input(event: InputEvent) -> void:
	if not interactive or not flying or _scattering:
		return
	var click: InputEventMouseButton = event as InputEventMouseButton
	if click and click.pressed and click.button_index == MOUSE_BUTTON_LEFT:
		var at: Vector2 = get_global_mouse_position()
		for bat: Sprite2D in _bats:
			if bat.visible and bat.global_position.distance_to(at) <= CLICK_RADIUS:
				get_viewport().set_input_as_handled()
				scatter()
				return


## Starts a pass across the room.
func fly() -> void:
	flying = true
	_t = 0.0
	_dir = 1.0 if randf() < 0.5 else -1.0
	for bat: Sprite2D in _bats:
		bat.flip_h = _dir < 0.0
		bat.modulate.a = 1.0


## The hero waves; the bats burst apart and are gone. Nobody gets hurt.
func scatter() -> void:
	if _scattering or not flying:
		return
	_scattering = true
	if is_instance_valid(hero):
		hero.play_pose("interact_mid")
		if hero.bubble and not missed_line_key.is_empty():
			hero.bubble.say(missed_line_key)
	if AudioManager.has_sfx(squeak_sfx):
		AudioManager.play_sfx(squeak_sfx, randf_range(1.1, 1.4))
	var tween: Tween = create_tween().set_parallel()
	for bat: Sprite2D in _bats:
		if not bat.visible:
			continue
		var away: Vector2 = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, -0.2)).normalized() * randf_range(70.0, 120.0)
		tween.tween_property(bat, "position", bat.position + away, SCATTER_TIME) \
				.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(bat, "modulate:a", 0.0, SCATTER_TIME)
	await tween.finished
	scattered.emit()
	_land()


func _hero_under() -> bool:
	for bat: Sprite2D in _bats:
		if bat.visible and absf(bat.global_position.x - hero.global_position.x) <= hero_reach:
			return true
	return false


func _land() -> void:
	flying = false
	_scattering = false
	for bat: Sprite2D in _bats:
		bat.visible = false
	_wait = randf_range(interval_min, interval_max)
