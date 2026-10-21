class_name Chandelier
extends Node2D
## The boudoir chandelier above the mosaic. Three looks: hanging (still),
## swinging (a hit makes it sway around the ceiling hook and settle) and
## fallen (the hanging sprite drops, the wreck with the prism lies on the
## floor). Node origin = the ceiling hook; `hanging` hangs below it.
## Kicked balls (ThrownBall) hit it through `hit_area`: hit 1 swings it and
## the key drops out, hits 2-4 swing it (the third, once the ghost is met,
## gets her "Do you want the Count up here?!"), hit 5 brings it down with
## the crystal prism. A hit after a wall bounce unlocks the
## angle-of-reflection fact. Hits are a GameManager flag (saved).
## While nobody touches it, it sways a tiny bit by itself (a draught):
## the strength drifts between gusts, under a degree (bottom moves ~1 px).

signal swung
signal fell

enum State { HANGING, SWINGING, FALLEN }

const SWING_ANGLE: float = 7.0
const SWING_PERIOD: float = 0.9
const SWING_DAMP: float = 0.55
const FALL_TIME: float = 0.45
const IDLE_PERIOD: float = 3.2
const IDLE_MAX: float = 0.9
const FALL_HITS: int = 5
const HITS_FLAG: String = "chandelier_hits"

@export var hanging: Node2D
@export var fallen: Node2D
## World y of the floor where the wreck lies (fallen sprite origin).
@export var floor_y: float = 306.0
## Catches kicked balls (mask = ThrownBall layer).
@export var hit_area: Area2D
## Drops out on the first hit.
@export var key_pickup: Pickup
## Lies in the wreck once it has fallen.
@export var prism_pickup: Pickup
## The wreck sprite and its look once the prism has been taken.
@export var fallen_sprite: Sprite2D
@export var fallen_empty: Texture2D

var state: State = State.HANGING
## Idle draught sway on/off (tests and screenshots turn it off).
var idle_sway: bool = true
var _tween: Tween
var _idle_t: float = 0.0
var _idle_amp: float = 0.0
var _idle_target: float = 0.0
var _gust_left: float = 0.0


func _ready() -> void:
	if fallen:
		fallen.visible = false
	if hit_area:
		hit_area.body_entered.connect(_on_body_entered)
	if prism_pickup:
		prism_pickup.taken.connect(_empty_wreck)
	EventBus.game_loaded.connect(_sync)
	_sync()


## A saved game where it already lies on the floor.
func _sync() -> void:
	if hits() >= FALL_HITS and state != State.FALLEN:
		state = State.FALLEN
		_kill_tween()
		hanging.visible = false
		if fallen:
			fallen.visible = true
	if prism_pickup and GameManager.has_flag(prism_pickup.taken_flag):
		_empty_wreck()


func _empty_wreck() -> void:
	if fallen_sprite and fallen_empty:
		fallen_sprite.texture = fallen_empty


func hits() -> int:
	return int(GameManager.flags.get(HITS_FLAG, 0))


## One more hit; `after_bounce`: the ball came off a wall first.
func register_hit(after_bounce: bool) -> void:
	if state == State.FALLEN:
		return
	var count: int = hits() + 1
	GameManager.set_flag(HITS_FLAG, count)
	if after_bounce:
		GameManager.unlock_codex("bounce_angle")
	if count >= FALL_HITS:
		fall()
		EventBus.hero_line_requested.emit("SAY_CHANDELIER_CRASH")
		await fell
		if prism_pickup:
			prism_pickup.drop_to(prism_pickup.global_position + Vector2(0, -12))
		GameManager.unlock_codex("prism")
	else:
		swing()
		if count == 1:
			EventBus.hero_line_requested.emit("SAY_CHANDELIER_KEY")
			if key_pickup:
				key_pickup.drop_to(global_position + Vector2(0, 60))
		elif count == 3 and GameManager.has_flag("ghost_met"):
			EventBus.ghost_line_requested.emit("GHOST_COUNT_UP_HERE")
	EventBus.autosave_requested.emit()


func _on_body_entered(body: Node) -> void:
	var ball: ThrownBall = body as ThrownBall
	if not ball or ball.hit_target or state == State.FALLEN:
		return
	ball.hit_target = true
	# The ball glances off downwards.
	ball.linear_velocity = Vector2(ball.linear_velocity.x * 0.5, absf(ball.linear_velocity.y) * 0.4)
	register_hit(ball.bounced_off_wall)


func _process(delta: float) -> void:
	if state != State.HANGING or not idle_sway:
		return
	_gust_left -= delta
	if _gust_left <= 0.0:
		_gust_left = randf_range(3.0, 7.0)
		_idle_target = randf_range(0.0, IDLE_MAX)
	_idle_amp = move_toward(_idle_amp, _idle_target, delta * 0.3)
	_idle_t += delta
	hanging.rotation_degrees = sin(_idle_t * TAU / IDLE_PERIOD) * _idle_amp


## A hit: sway around the hook with a damped swing, then hang still again.
func swing() -> void:
	if state == State.FALLEN:
		return
	state = State.SWINGING
	_idle_amp = 0.0
	swung.emit()
	_kill_tween()
	_tween = create_tween()
	var angle: float = SWING_ANGLE
	for i: int in 4:
		_tween.tween_property(hanging, "rotation_degrees", angle, SWING_PERIOD * 0.5) \
				.set_trans(Tween.TRANS_SINE)
		_tween.tween_property(hanging, "rotation_degrees", -angle * SWING_DAMP, SWING_PERIOD * 0.5) \
				.set_trans(Tween.TRANS_SINE)
		angle *= SWING_DAMP * SWING_DAMP
	_tween.tween_property(hanging, "rotation_degrees", 0.0, SWING_PERIOD * 0.3)
	_tween.tween_callback(func() -> void: state = State.HANGING)


## The last hit: the chandelier drops and lies smashed on the floor.
func fall() -> void:
	if state == State.FALLEN:
		return
	state = State.FALLEN
	_kill_tween()
	_tween = create_tween()
	var drop: float = floor_y - global_position.y - 40.0
	_tween.tween_property(hanging, "position:y", hanging.position.y + drop, FALL_TIME) \
			.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	_tween.tween_callback(_land)


func _land() -> void:
	hanging.visible = false
	if fallen:
		fallen.visible = true
	fell.emit()


func _kill_tween() -> void:
	if _tween and _tween.is_valid():
		_tween.kill()
