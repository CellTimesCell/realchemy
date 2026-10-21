class_name ThrownBall
extends RigidBody2D
## A kicked ball in flight: a physics body on its own collision layer
## (THROW_LAYER), bouncing off the room's walls, vault and floor line
## (ThrowAim builds them). Remembers whether it hit a wall first (for the
## angle-of-reflection fact) and reports where it came to rest.

signal landed(at: Vector2, hit_target: bool)

const THROW_LAYER: int = 1 << 4
const RADIUS: float = 6.0
const BOUNCE: float = 0.72
const REST_SPEED: float = 12.0
const REST_TIME: float = 0.4
const MAX_TIME: float = 6.0
const ROLL_DAMP: float = 2.5

var bounced_off_wall: bool = false
var hit_target: bool = false
var _rest: float = 0.0
var _age: float = 0.0
var _done: bool = false


static func create(texture: Texture2D, at: Vector2, start_velocity: Vector2) -> ThrownBall:
	var ball: ThrownBall = ThrownBall.new()
	ball.collision_layer = THROW_LAYER
	ball.collision_mask = THROW_LAYER
	ball.physics_material_override = PhysicsMaterial.new()
	ball.physics_material_override.bounce = BOUNCE
	# No friction in flight: a wall bounce keeps the vertical speed (as the
	# predicted path assumes); after the first floor contact it rolls out.
	ball.physics_material_override.friction = 0.0
	ball.contact_monitor = true
	ball.max_contacts_reported = 4
	ball.continuous_cd = RigidBody2D.CCD_MODE_CAST_SHAPE
	var shape: CollisionShape2D = CollisionShape2D.new()
	var circle: CircleShape2D = CircleShape2D.new()
	circle.radius = RADIUS
	shape.shape = circle
	ball.add_child(shape)
	var sprite: Sprite2D = Sprite2D.new()
	sprite.texture = texture
	ball.add_child(sprite)
	ball.position = at
	ball.linear_velocity = start_velocity
	return ball


func _ready() -> void:
	body_entered.connect(func(body: Node) -> void:
		if body.is_in_group(&"throw_wall"):
			bounced_off_wall = true
		else:
			linear_damp = ROLL_DAMP)


func _physics_process(delta: float) -> void:
	if _done:
		return
	_age += delta
	_rest = _rest + delta if linear_velocity.length() < REST_SPEED else 0.0
	if _rest >= REST_TIME or _age >= MAX_TIME:
		_done = true
		landed.emit(global_position.round(), hit_target)
		queue_free()
