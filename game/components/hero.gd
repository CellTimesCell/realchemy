class_name Hero
extends CharacterBody2D
## Player character: arrow-key movement, four-direction walk/idle animation
## (west = east mirrored) and the "scratch head" emote on E. Frozen while a
## modal UI (letter, dialogue) is open.

const SPEED: float = 120.0

@export var anim: AnimatedSprite2D

var _facing: String = "south"
var _emoting: bool = false


func _ready() -> void:
	anim.animation_finished.connect(_on_anim_finished)


func _unhandled_input(event: InputEvent) -> void:
	if EventBus.modal_ui_active:
		return
	var key: InputEventKey = event as InputEventKey
	if key and key.pressed and not key.echo and key.physical_keycode == KEY_E:
		play_emote()


func _physics_process(_delta: float) -> void:
	if _emoting:
		velocity = Vector2.ZERO
		return
	if EventBus.modal_ui_active:
		velocity = Vector2.ZERO
		_update_animation(Vector2.ZERO)
		return
	var direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * SPEED
	move_and_slide()
	_update_animation(direction)


func play_emote() -> void:
	if not anim.sprite_frames.has_animation("emote_scratch_head"):
		return
	_emoting = true
	anim.flip_h = false
	anim.play("emote_scratch_head")


func _update_animation(direction: Vector2) -> void:
	if direction != Vector2.ZERO:
		if absf(direction.x) > absf(direction.y):
			_facing = "east" if direction.x > 0.0 else "west"
		else:
			_facing = "south" if direction.y > 0.0 else "north"
	# West reuses the east frames mirrored.
	anim.flip_h = _facing == "west"
	var side: String = "east" if _facing == "west" else _facing
	if direction != Vector2.ZERO:
		anim.play("walk_" + side)
	elif _facing == "south":
		anim.play("idle_south")
	else:
		# Only a south idle exists: stand on the first walk frame.
		anim.animation = "walk_" + side
		anim.frame = 0
		anim.stop()


func _on_anim_finished() -> void:
	if anim.animation == "emote_scratch_head":
		_emoting = false
		_facing = "south"
