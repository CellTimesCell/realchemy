class_name Sway
extends Node2D
## Swings around its origin: a clock pendulum (big, steady), a garland in a
## draught (tiny, slow). Each one starts at its own phase.

@export var amplitude: float = 1.0
@export var period: float = 3.0
## Random start phase so neighbours never move in step.
@export var random_phase: bool = true

var _t: float = 0.0


func _ready() -> void:
	if random_phase:
		_t = randf_range(0.0, period)


func _process(delta: float) -> void:
	_t += delta
	rotation_degrees = sin(_t * TAU / period) * amplitude
