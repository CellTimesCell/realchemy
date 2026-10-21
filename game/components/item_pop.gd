class_name ItemPop
extends Node2D
## A found item jumps out of a prop, sparkles, then flies to the top-right
## corner of the screen (where the inventory will be) and disappears.
## Until item icons exist (T-25c/D), the item is a placeholder: a coloured
## square with a letter (CLAUDE.md §8). Drawn on the "above_night" layer.

const SIZE: Vector2 = Vector2(10, 10)
const HOP_HEIGHT: float = 12.0
const HOP_TIME: float = 0.3
const HOLD_TIME: float = 0.35
const FLY_TIME: float = 0.45
## Screen point the item flies to (base resolution 640x360); the HUD sets
## it to its bag button.
const CORNER: Vector2 = Vector2(620, 18)

static var target: Vector2 = CORNER

var color: Color = Color(1, 0.6, 0.2)
var letter: String = "?"


## Spawns the pop at a world position; returns when it is gone.
static func spawn(tree: SceneTree, world_pos: Vector2, item_color: Color, item_letter: String) -> void:
	var pop: ItemPop = ItemPop.new()
	pop.color = item_color
	pop.letter = item_letter
	var layer: Node = tree.get_first_node_in_group(&"above_night")
	if not layer:
		layer = tree.current_scene if tree.current_scene else tree.root
	layer.add_child(pop)
	pop.global_position = world_pos
	await pop.play()


func _ready() -> void:
	var box: ColorRect = ColorRect.new()
	box.color = color
	box.size = SIZE
	box.position = -SIZE * 0.5
	add_child(box)
	var label: Label = Label.new()
	label.text = letter
	label.add_theme_font_size_override("font_size", 8)
	label.add_theme_color_override("font_color", Color(0.1, 0.05, 0.1))
	label.position = -SIZE * 0.5 + Vector2(1, 0)
	add_child(label)
	add_child(_make_sparkles())


func play() -> void:
	var start: Vector2 = global_position
	var hop: Tween = create_tween()
	hop.tween_method(func(t: float) -> void:
		global_position = (start + Vector2(0, -sin(t * PI * 0.5) * HOP_HEIGHT)).round(), 0.0, 1.0, HOP_TIME)
	await hop.finished
	await get_tree().create_timer(HOLD_TIME).timeout
	# The layer follows the camera: turn the screen corner into world coords.
	var corner: Vector2 = get_viewport().get_canvas_transform().affine_inverse() * target
	var fly: Tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	fly.tween_property(self, "global_position", corner, FLY_TIME)
	fly.parallel().tween_property(self, "scale", Vector2(0.5, 0.5), FLY_TIME)
	await fly.finished
	AudioManager.play_sfx("pickup", 1.3)
	queue_free()


func _make_sparkles() -> CPUParticles2D:
	var sparkles: CPUParticles2D = CPUParticles2D.new()
	sparkles.amount = 8
	sparkles.lifetime = 0.5
	sparkles.explosiveness = 0.6
	sparkles.emission_shape = CPUParticles2D.EMISSION_SHAPE_SPHERE
	sparkles.emission_sphere_radius = 7.0
	sparkles.direction = Vector2(0, -1)
	sparkles.spread = 180.0
	sparkles.gravity = Vector2.ZERO
	sparkles.initial_velocity_min = 4.0
	sparkles.initial_velocity_max = 10.0
	sparkles.scale_amount_min = 1.0
	sparkles.scale_amount_max = 2.0
	sparkles.color = Color(1, 0.95, 0.7)
	return sparkles
