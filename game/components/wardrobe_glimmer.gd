class_name WardrobeGlimmer
extends PointLight2D
## Teaser before the ghost grandmother is met: now and then a faint green
## light swells and fades at the closed wardrobe doors, so the player wants
## to open it. Gone for good once the wardrobe has been opened.

@export var wardrobe: Interactable
@export var peak_energy: float = 0.9
@export var pulse_time: float = 1.8
@export var interval_min: float = 8.0
@export var interval_max: float = 15.0

var _wait: float = 0.0
var _done: bool = false


func _ready() -> void:
	energy = 0.0
	if wardrobe:
		wardrobe.opened.connect(func(_prop: Interactable) -> void: stop())
	EventBus.game_loaded.connect(func() -> void:
		if GameManager.has_flag("ghost_met") or (wardrobe and wardrobe.is_open):
			stop())
	_wait = randf_range(interval_min, interval_max)


func _process(delta: float) -> void:
	if _done:
		return
	_wait -= delta
	if _wait <= 0.0:
		_wait = randf_range(interval_min, interval_max) + pulse_time
		glimmer()


func glimmer() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "energy", peak_energy, pulse_time * 0.5).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "energy", 0.0, pulse_time * 0.5).set_trans(Tween.TRANS_SINE)


func stop() -> void:
	_done = true
	energy = 0.0
	enabled = false
