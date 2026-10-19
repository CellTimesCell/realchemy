class_name FollowingEyes
extends Sprite2D
## The eyes of a portrait (a separate band of the painting's own pixels) that
## slide a whole pixel or two toward the hero along x. Creepy on purpose.
## The sprite holds the eye band (whites and pupils); when the hero passes
## under the painting the eyes catch a short glint (GLINT_TIME).

const GLINT_TIME: float = 0.3
const GLINT_COLOR: Color = Color(2.4, 2.4, 2.2, 1)

@export var target: Node2D
@export var max_shift: int = 1
## No shift while the hero is this close (px) to the painting's x.
@export var dead_zone: float = 24.0

var _base_x: float = 0.0
var _last_side: int = 0


func _ready() -> void:
	_base_x = offset.x


func _process(_delta: float) -> void:
	if not is_instance_valid(target):
		return
	var dx: float = target.global_position.x - global_position.x
	var shift: int = 0
	if dx > dead_zone:
		shift = max_shift
	elif dx < -dead_zone:
		shift = -max_shift
	offset.x = _base_x + shift
	# Crossing under the painting (left <-> right): a glint.
	if shift != 0 and _last_side != 0 and shift != _last_side:
		_glint()
	if shift != 0:
		_last_side = shift


func _glint() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "modulate", GLINT_COLOR, GLINT_TIME * 0.4)
	tween.tween_property(self, "modulate", Color.WHITE, GLINT_TIME * 0.6)
