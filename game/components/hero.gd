class_name Hero
extends CharacterBody2D
## Player character: arrow-key movement, four-direction walk/idle animation
## (west = east mirrored). Reactions (body animation + emote icon) go through
## the ReactionPlayer; E plays "scratch_head". Frozen while a reaction plays or
## a modal UI (letter, dialogue) is open.

const SPEED: float = 120.0

@export var anim: AnimatedSprite2D
@export var reactions: ReactionPlayer

var _facing: String = "south"


func _ready() -> void:
	if reactions:
		reactions.reaction_finished.connect(func(_name: String) -> void: _facing = "south")


func _unhandled_input(event: InputEvent) -> void:
	if EventBus.modal_ui_active:
		return
	var key: InputEventKey = event as InputEventKey
	if key and key.pressed and not key.echo and key.physical_keycode == KEY_E:
		play_reaction("scratch_head")


func _physics_process(_delta: float) -> void:
	if reactions and reactions.busy:
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


func play_reaction(reaction_name: String) -> void:
	if reactions:
		await reactions.play_reaction(reaction_name)


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
