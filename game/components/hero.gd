class_name Hero
extends CharacterBody2D
## Player character: arrow-key movement, four-direction walk/idle animation
## (west = east mirrored). Reactions (body animation + emote icon) go through
## the ReactionPlayer; E plays "scratch_head". Frozen while a reaction plays,
## while an interaction pose or a scripted walk (door) runs, or while a modal
## UI (letter, dialogue) is open.

const SPEED: float = 120.0
## How long the last frame of an interaction pose is held.
const POSE_HOLD: float = 0.25

@export var anim: AnimatedSprite2D
@export var reactions: ReactionPlayer
## Where the hero's lines appear (above his emotes).
@export var bubble: SpeechBubble

## Set while a pose or a scripted walk plays; input is ignored.
var acting: bool = false
var _facing: String = "south"


func _ready() -> void:
	EventBus.hero_line_requested.connect(func(key: String) -> void:
		if bubble and not key.is_empty():
			bubble.say(key))
	EventBus.hero_pose_requested.connect(func(pose: String) -> void: play_pose(pose))
	if reactions:
		reactions.reaction_finished.connect(func(_name: String) -> void: _facing = "south")


func _unhandled_input(event: InputEvent) -> void:
	if EventBus.modal_ui_active:
		return
	var key: InputEventKey = event as InputEventKey
	if acting:
		return
	if key and key.pressed and not key.echo and key.physical_keycode == KEY_E:
		play_reaction("scratch_head")


func _physics_process(_delta: float) -> void:
	if acting or (reactions and reactions.busy):
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


## Plays an interaction pose ("interact_low", "interact_mid", "interact_high")
## in the current facing (south, or east mirrored for west), holds it, then
## stands idle again. Missing animations are skipped.
func play_pose(pose: String) -> void:
	if pose.is_empty():
		return
	# Facing the back wall (north) uses the side view: no back-view poses.
	var side: String = "south" if _facing == "south" else "east"
	var anim_name: String = "%s_%s" % [pose, side]
	if not anim.sprite_frames.has_animation(anim_name):
		return
	acting = true
	anim.flip_h = _facing == "west"
	anim.play(anim_name)
	await anim.animation_finished
	await get_tree().create_timer(POSE_HOLD).timeout
	_update_animation(Vector2.ZERO)
	acting = false


## Turns the hero in place ("south", "north", "east", "west").
func face(direction: String) -> void:
	_facing = direction
	_update_animation(Vector2.ZERO)


## Scripted walk to a point (into a doorway), ignoring collisions.
func walk_to(target: Vector2, time: float) -> void:
	acting = true
	_update_animation((target - position).normalized())
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", target, time)
	await tween.finished
	_update_animation(Vector2.ZERO)
	acting = false


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
