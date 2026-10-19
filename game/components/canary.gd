class_name Canary
extends AnimatedSprite2D
## The canary in the boudoir cage. Lives on its own: sits, preens, chirps and
## hops between perches. It is the "danger sensor": when the player starts a
## reaction with a dangerous by-product (EventBus.danger_reaction_started) it
## flaps in alarm and chirps fast - a warning, never a goal.
## Position = a perch; `perches` are the perch points in the parent's space.

const HOP_HEIGHT: float = 4.0
const HOP_TIME: float = 0.35
const ALARM_TIME: float = 3.0
const ALARM_CHIRP_GAP: float = 0.25

@export var perches: Array[Vector2] = []
@export var chirp: AudioStreamPlayer2D
@export var min_pause: float = 1.5
@export var max_pause: float = 4.0
## Debug: K starts the alarm. Off in release scenes.
@export var debug_keys: bool = false

var alarmed: bool = false
var _perch: int = 0
var _busy: bool = false


func _ready() -> void:
	EventBus.danger_reaction_started.connect(func(_id: String) -> void: alarm())
	if not perches.is_empty():
		position = perches[0]
	play("sit")
	_live()


func _unhandled_input(event: InputEvent) -> void:
	var key: InputEventKey = event as InputEventKey
	if debug_keys and key and key.pressed and not key.echo and key.physical_keycode == KEY_K:
		alarm()


func alarm() -> void:
	if alarmed:
		return
	alarmed = true
	play("alarm")
	var base: Vector2 = position
	var elapsed: float = 0.0
	while elapsed < ALARM_TIME:
		_chirp(1.3)
		# Jitter by whole pixels while flapping.
		position = base + Vector2(randi_range(-1, 1), -randi_range(0, 1))
		await get_tree().create_timer(ALARM_CHIRP_GAP).timeout
		elapsed += ALARM_CHIRP_GAP
	position = base
	play("sit")
	alarmed = false


func _live() -> void:
	while is_inside_tree():
		await get_tree().create_timer(randf_range(min_pause, max_pause)).timeout
		if alarmed:
			continue
		var roll: float = randf()
		if roll < 0.35:
			play("preen")
			await animation_finished
			if not alarmed:
				play("sit")
		elif roll < 0.7 and perches.size() > 1:
			await _hop()
		else:
			_chirp(1.0)


func _hop() -> void:
	var next: int = (_perch + 1 + randi() % (perches.size() - 1)) % perches.size()
	var start: Vector2 = position
	var target: Vector2 = perches[next]
	flip_h = target.x < start.x
	play("alarm")
	var tween: Tween = create_tween()
	tween.tween_method(func(t: float) -> void:
		var p: Vector2 = start.lerp(target, t)
		p.y -= sin(t * PI) * HOP_HEIGHT
		position = p.round(), 0.0, 1.0, HOP_TIME)
	await tween.finished
	_perch = next
	if not alarmed:
		play("sit")


func _chirp(pitch: float) -> void:
	if chirp:
		chirp.pitch_scale = pitch * randf_range(0.95, 1.1)
		chirp.play()
