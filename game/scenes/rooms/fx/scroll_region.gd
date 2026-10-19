extends Sprite2D
## Scrolls a repeating texture sideways (drifting clouds).

@export var speed: float = 4.0

var _offset: float = 0.0


func _ready() -> void:
	texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	region_enabled = true


func _process(delta: float) -> void:
	_offset = fposmod(_offset + speed * delta, float(texture.get_width()))
	# Whole pixels only, to keep the pixel grid crisp.
	region_rect.position.x = floorf(_offset)
