class_name FireLight
extends PointLight2D
## A living fire light (hearth, candles, sconces): energy and size flicker
## around their base values in small random steps, never in sync with other
## fires (own phase and speed). Night stays night: the swing is small.

## Relative swing of the energy (0.15 = +-15 %).
@export var flicker: float = 0.15
## Average flickers per second.
@export var speed: float = 7.0
## Relative swing of texture_scale (a breathing glow).
@export var breathe: float = 0.05

var _base_energy: float = 0.0
var _base_scale: float = 0.0
var _target: float = 0.0
var _value: float = 0.0
var _left: float = 0.0


func _ready() -> void:
	_base_energy = energy
	_base_scale = texture_scale
	speed *= randf_range(0.8, 1.25)


func _process(delta: float) -> void:
	_left -= delta
	if _left <= 0.0:
		_left = randf_range(0.5, 1.5) / speed
		_target = randf_range(-1.0, 1.0)
	_value = move_toward(_value, _target, delta * speed * 2.0)
	energy = _base_energy * (1.0 + flicker * _value)
	texture_scale = _base_scale * (1.0 + breathe * _value)
