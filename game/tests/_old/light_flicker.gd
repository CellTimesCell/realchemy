extends PointLight2D
## Temporary art check: torch flicker (fast, irregular) or moon-beam pulse (slow).

@export var base_energy: float = 1.2
@export var amount: float = 0.2
@export var speed: float = 9.0
@export var irregular: bool = true

var _time: float = 0.0


func _ready() -> void:
	_time = randf() * 10.0


func _process(delta: float) -> void:
	_time += delta
	var wave: float = sin(_time * speed)
	if irregular:
		wave = (wave + sin(_time * speed * 2.31 + 1.7) * 0.6) / 1.6
	energy = base_energy + amount * wave
