class_name ThrowAim
extends Node2D
## Aim and kick (GAME_DESIGN §12, physical puzzles - at things, never at
## people). With a throwable (the ball) in hand: press near the hero and pull
## back like a slingshot; a dotted line shows the flight (cozy: the whole
## path with bounces, classic: its start, real: none); release -> the hero
## kicks and a ThrownBall flies, bouncing off the room's walls and vault.
## Where it stops the ball lies again to be picked up. Hits are reported by
## the target (Chandelier); a run of misses gets a remark from the ghost.

signal thrown(ball: ThrownBall)

const GRAB_RADIUS: float = 26.0
const MAX_PULL: float = 72.0
const POWER: float = 13.0
const START_HEIGHT: float = 8.0
const WALL_INSET: float = 6.0
const VAULT_Y: float = 6.0
const DOT_EVERY: int = 4
const SIM_STEPS: int = 150
const SIM_DT: float = 1.0 / 60.0
## Share of the predicted path drawn per mode.
const PREVIEW: Dictionary = {"cozy": 1.0, "classic": 0.3, "real": 0.0}
const MISSES_FOR_REMARK: int = 10
const DOT_COLOR: Color = Color(1, 0.95, 0.7)

@export var hero: Hero
## The loose ball in the room (a Pickup): it moves to where a kick ends.
@export var ball_pickup: Pickup
@export var item_id: String = "ball"
## Dev helper (screenshots): what demo_kick() aims at.
@export var demo_target: Node2D

var aiming: bool = false
var flying: ThrownBall
var pull: Vector2 = Vector2.ZERO
var _press_at: Vector2 = Vector2.ZERO
var _bounds: Node2D
## The dotted line is drawn on the "above_night" layer (the night tint would
## swallow it), in world coordinates (that layer follows the camera).
var _preview: Node2D


func _ready() -> void:
	_preview = Node2D.new()
	_preview.draw.connect(_draw_preview)
	var layer: Node = get_tree().get_first_node_in_group(&"above_night")
	if layer:
		layer.add_child.call_deferred(_preview)
	else:
		add_child(_preview)


func _exit_tree() -> void:
	if is_instance_valid(_preview) and _preview.get_parent() != self:
		_preview.queue_free()


func can_aim() -> bool:
	return is_instance_valid(hero) and not EventBus.modal_ui_active and not hero.acting \
			and flying == null and GameManager.inventory.active_items().has(item_id)


func _unhandled_input(event: InputEvent) -> void:
	var button: InputEventMouseButton = event as InputEventMouseButton
	if button and button.button_index == MOUSE_BUTTON_LEFT:
		if button.pressed and can_aim() and get_global_mouse_position().distance_to(origin()) <= GRAB_RADIUS:
			get_viewport().set_input_as_handled()
			begin_aim(get_global_mouse_position())
		elif not button.pressed and aiming:
			get_viewport().set_input_as_handled()
			release()
	elif event is InputEventMouseMotion and aiming:
		set_pull(_press_at - get_global_mouse_position())


func origin() -> Vector2:
	return hero.global_position + Vector2(0, -START_HEIGHT)


func begin_aim(at: Vector2) -> void:
	aiming = true
	_press_at = at
	pull = Vector2.ZERO
	_redraw()


## The pull, from the press point back towards the finger (slingshot).
func set_pull(value: Vector2) -> void:
	pull = value.limit_length(MAX_PULL)
	_redraw()


func release() -> ThrownBall:
	aiming = false
	_redraw()
	if pull.length() < 6.0 or not GameManager.inventory.consume_held(item_id):
		return null
	hero.play_pose("interact_low")
	_build_bounds()
	var texture: Texture2D = ItemDb.icon(item_id)
	flying = ThrownBall.create(texture, origin(), pull * POWER)
	get_parent().add_child(flying)
	flying.landed.connect(_on_landed)
	thrown.emit(flying)
	return flying


## Predicted flight: points with simple bounces (the same walls as physics).
func predict(from: Vector2, velocity: Vector2) -> PackedVector2Array:
	var points: PackedVector2Array = PackedVector2Array()
	# The ball's centre turns a radius away from the walls and the vault.
	var room: Rect2 = room_rect().grow_individual(-ThrownBall.RADIUS, -ThrownBall.RADIUS, -ThrownBall.RADIUS, 0.0)
	var floor_y: float = from.y + START_HEIGHT
	var gravity: float = float(ProjectSettings.get_setting("physics/2d/default_gravity", 980.0))
	var p: Vector2 = from
	var v: Vector2 = velocity
	for i: int in SIM_STEPS:
		v.y += gravity * SIM_DT
		p += v * SIM_DT
		if p.x < room.position.x or p.x > room.end.x:
			p.x = clampf(p.x, room.position.x, room.end.x)
			v.x = -v.x * ThrownBall.BOUNCE
		if p.y < room.position.y:
			p.y = room.position.y
			v.y = -v.y * ThrownBall.BOUNCE
		if p.y > floor_y:
			p.y = floor_y
			v.y = -v.y * ThrownBall.BOUNCE
			if absf(v.y) < 40.0:
				break
		points.append(p)
	return points


## For tests and screenshots: a pull whose predicted flight passes through
## `target` (optionally only after a wall bounce); ZERO if none is found.
func solve_pull(target: Rect2, after_bounce: bool = false) -> Vector2:
	var room: Rect2 = room_rect().grow_individual(-ThrownBall.RADIUS, -ThrownBall.RADIUS, -ThrownBall.RADIUS, 0.0)
	# Straight up first, then ever flatter; simple paths only: at most one
	# wall bounce and none off the vault before the target.
	for offset: int in range(0, 80, 2):
		for side: int in [-1, 1]:
			for length: float in [72.0, 66.0, 60.0, 54.0, 48.0]:
				var dir: Vector2 = Vector2.from_angle(deg_to_rad(-90.0 + side * offset))
				var walls: int = 0
				var was_at_wall: bool = false
				for p: Vector2 in predict(origin(), dir * length * POWER):
					var at_wall: bool = p.x <= room.position.x + 0.5 or p.x >= room.end.x - 0.5
					if at_wall and not was_at_wall:
						walls += 1
					was_at_wall = at_wall
					if p.y <= room.position.y + 0.5 or walls > 1:
						break
					if target.has_point(p) and (walls == 1 or (walls == 0 and not after_bounce)):
						return dir * length
	return Vector2.ZERO


## Dev helper for screenshots: pulls back slowly towards a solved aim at
## demo_target, then kicks.
func demo_kick(after_bounce: bool = false) -> void:
	var at: Vector2 = demo_target.global_position
	var target_pull: Vector2 = solve_pull(Rect2(at + Vector2(-20, 12), Vector2(40, 44)), after_bounce)
	begin_aim(origin())
	for i: int in 30:
		set_pull(target_pull * float(i + 1) / 30.0)
		await get_tree().process_frame
		await get_tree().process_frame
	await get_tree().create_timer(0.5).timeout
	release()


## The current room's inner box (walls and vault), world coordinates.
func room_rect() -> Rect2:
	var left: float = floorf(hero.global_position.x / 640.0) * 640.0
	return Rect2(left + WALL_INSET, VAULT_Y, 640.0 - WALL_INSET * 2.0, 360.0)


func _redraw() -> void:
	if is_instance_valid(_preview):
		_preview.queue_redraw()


func _draw_preview() -> void:
	if not aiming or pull.length() < 2.0:
		return
	var share: float = float(PREVIEW.get(GameManager.mode, 0.3))
	var start: Vector2 = origin()
	# The pull itself: a short line back towards the finger.
	_preview.draw_line(start, start - pull * 0.35, Color(DOT_COLOR, 0.6), 1.0)
	if share <= 0.0:
		return
	var points: PackedVector2Array = predict(origin(), pull * POWER)
	var shown: int = int(points.size() * share)
	for i: int in range(0, shown, DOT_EVERY):
		var alpha: float = 0.9 - 0.6 * float(i) / maxf(1.0, float(shown))
		_preview.draw_rect(Rect2(points[i].round() - Vector2(1, 1), Vector2(2, 2)), Color(DOT_COLOR, alpha))


func _build_bounds() -> void:
	if is_instance_valid(_bounds):
		_bounds.queue_free()
	_bounds = Node2D.new()
	var walls: StaticBody2D = _body(true)
	var ground: StaticBody2D = _body(false)
	var room: Rect2 = room_rect()
	var floor_y: float = origin().y + START_HEIGHT + ThrownBall.RADIUS
	_add_segment(walls, Vector2(room.position.x, -40), Vector2(room.position.x, 400))
	_add_segment(walls, Vector2(room.end.x, -40), Vector2(room.end.x, 400))
	_add_segment(walls, Vector2(room.position.x, room.position.y), Vector2(room.end.x, room.position.y))
	_add_segment(ground, Vector2(room.position.x, floor_y), Vector2(room.end.x, floor_y))
	get_parent().add_child(_bounds)


## Walls and the vault count as "a wall" for the bounce fact; the floor not.
func _body(wall: bool) -> StaticBody2D:
	var body: StaticBody2D = StaticBody2D.new()
	body.collision_layer = ThrownBall.THROW_LAYER
	body.collision_mask = 0
	if wall:
		body.add_to_group(&"throw_wall")
	_bounds.add_child(body)
	return body


func _add_segment(body: StaticBody2D, a: Vector2, b: Vector2) -> void:
	var shape: CollisionShape2D = CollisionShape2D.new()
	var segment: SegmentShape2D = SegmentShape2D.new()
	segment.a = a
	segment.b = b
	shape.shape = segment
	body.add_child(shape)


func _on_landed(at: Vector2, hit_target: bool) -> void:
	flying = null
	if is_instance_valid(_bounds):
		_bounds.queue_free()
	if ball_pickup:
		ball_pickup.global_position = Vector2(at.x, minf(at.y, origin().y + START_HEIGHT)) + Vector2(0, 8)
		GameManager.clear_flag(ball_pickup.taken_flag)
		ball_pickup.visible = true
	if hit_target:
		GameManager.set_flag("throw_misses", 0)
		return
	var misses: int = int(GameManager.flags.get("throw_misses", 0)) + 1
	GameManager.set_flag("throw_misses", misses)
	if misses >= MISSES_FOR_REMARK:
		GameManager.set_flag("throw_misses", 0)
		EventBus.ghost_line_requested.emit("GHOST_NOT_THAT_GAME")
