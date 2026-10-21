extends GutTest
## L-4: aim and kick. The predicted path stays in the room and bounces off
## its walls; how much of it is drawn depends on the mode; a real kick in the
## boudoir hits the chandelier (key falls out), five hits bring it down with
## the prism; ten misses in a row get a remark from the ghost.

const SUITE: String = "res://scenes/rooms/princess_suite.tscn"


func before_each() -> void:
	SaveManager.load_on_start = false
	GameManager.reset()
	TimeManager.clear()


func _suite_with_ball(hero_at: Vector2) -> Node:
	var scene: Node = (load(SUITE) as PackedScene).instantiate()
	add_child_autofree(scene)
	(scene.get("hero") as Node2D).global_position = hero_at
	GameManager.give_item("ball")
	GameManager.equip("ball", 1)
	return scene


func test_prediction_bounces_inside_the_room() -> void:
	var scene: Node = _suite_with_ball(Vector2(1240, 330))
	var aim: ThrowAim = scene.get_node("ThrowAim")
	var room: Rect2 = aim.room_rect()
	var points: PackedVector2Array = aim.predict(aim.origin(), Vector2(600, -500))
	assert_gt(points.size(), 10)
	var bounced: bool = false
	for p: Vector2 in points:
		assert_between(p.x, room.position.x - 0.01, room.end.x + 0.01)
		bounced = bounced or p.x >= room.end.x - ThrownBall.RADIUS - 0.5
	assert_true(bounced, "Kicked to the right wall, it comes back")


func test_preview_share_by_mode() -> void:
	assert_eq(ThrowAim.PREVIEW["cozy"], 1.0)
	assert_lt(ThrowAim.PREVIEW["classic"], 1.0)
	assert_eq(ThrowAim.PREVIEW["real"], 0.0)


func test_kick_hits_chandelier_and_key_falls() -> void:
	var scene: Node = _suite_with_ball(Vector2(1180, 330))
	var aim: ThrowAim = scene.get_node("ThrowAim")
	var chandelier: Chandelier = scene.get_node("Chandelier")
	chandelier.idle_sway = false
	var target: Rect2 = Rect2(chandelier.global_position + Vector2(-20, 12), Vector2(40, 44))
	var pull: Vector2 = aim.solve_pull(target)
	assert_ne(pull, Vector2.ZERO, "Some kick reaches the chandelier")
	aim.begin_aim(aim.origin())
	aim.set_pull(pull)
	var ball: ThrownBall = aim.release()
	assert_not_null(ball)
	assert_false(GameManager.inventory.has("ball"), "The ball left the hand")
	await wait_until(func() -> bool: return chandelier.hits() >= 1, 3.0)
	assert_eq(chandelier.hits(), 1)
	assert_true((scene.get_node("Props/KeyPickup") as Pickup).visible, "The key dropped out")
	await wait_until(func() -> bool: return aim.flying == null, 8.0)
	assert_true((scene.get_node("Props/Ball") as Pickup).visible, "The ball lies where it stopped")


func test_five_hits_bring_it_down() -> void:
	var scene: Node = _suite_with_ball(Vector2(900, 330))
	var chandelier: Chandelier = scene.get_node("Chandelier")
	for i: int in 4:
		chandelier.register_hit(false)
	assert_ne(chandelier.state, Chandelier.State.FALLEN)
	chandelier.register_hit(true)
	await wait_until(func() -> bool: return chandelier.state == Chandelier.State.FALLEN and (scene.get_node("Props/PrismPickup") as Pickup).visible, 3.0)
	assert_true((scene.get_node("Props/PrismPickup") as Pickup).visible)
	assert_true("bounce_angle" in GameManager.codex, "A hit after a wall bounce: the fact")
	assert_true("prism" in GameManager.codex)


func test_ten_misses_get_a_remark() -> void:
	var scene: Node = _suite_with_ball(Vector2(900, 330))
	var aim: ThrowAim = scene.get_node("ThrowAim")
	watch_signals(EventBus)
	for i: int in 9:
		aim._on_landed(Vector2(900, 330), false)
	assert_signal_not_emitted(EventBus, "ghost_line_requested")
	aim._on_landed(Vector2(900, 330), false)
	assert_signal_emitted_with_parameters(EventBus, "ghost_line_requested", ["GHOST_NOT_THAT_GAME"])
	assert_eq(int(GameManager.flags["throw_misses"]), 0)


func test_no_aim_without_ball() -> void:
	var scene: Node = (load(SUITE) as PackedScene).instantiate()
	add_child_autofree(scene)
	var aim: ThrowAim = scene.get_node("ThrowAim")
	assert_false(aim.can_aim())
