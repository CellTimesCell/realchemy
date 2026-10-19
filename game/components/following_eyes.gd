class_name FollowingEyes
extends Sprite2D
## The eyes of a portrait (a separate band of the painting's own pixels) that
## slide a whole pixel or two toward the hero along x. Creepy on purpose.
## The sprite holds only the eye whites; an overbright modulate keeps them
## readable under the night tint.

@export var target: Node2D
@export var max_shift: int = 1
## No shift while the hero is this close (px) to the painting's x.
@export var dead_zone: float = 24.0

var _base_x: float = 0.0


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
