class_name PushProp
extends Node2D
## Heavy furniture the hero pushes to a spot (the X-chair under the orange
## tree). The hero walks behind it; STR makes it faster (HeroStats effect
## "push_time") - never required. Things sitting on it (the plush bear)
## ride along. Once there it stays (done_flag) and turns into a plain prop.

@export var hotspot: Hotspot
## Where the prop ends up (world position of the node origin).
@export var target: Vector2 = Vector2.ZERO
## Things on top that move with it.
@export var riders: Array[Node2D] = []
@export var done_flag: String = "chair_under_tree"
@export var push_prompt: String = "UI_PUSH"
@export var done_line_key: String = "SAY_CHAIR_PUSHED"
## Hero offset from the prop while pushing (stands behind it).
@export var hero_offset: Vector2 = Vector2(-22, 6)

var busy: bool = false
var _plain_prompt: String = ""


func _ready() -> void:
	_plain_prompt = hotspot.prompt_text
	if GameManager.has_flag(done_flag):
		_move_to(target)
	else:
		hotspot.set_prompt(push_prompt)


func _unhandled_input(event: InputEvent) -> void:
	if busy or GameManager.has_flag(done_flag) or not hotspot.is_active() or not event.is_action_pressed("ui_accept"):
		return
	if not GameManager.rule_for(hotspot.target_id).is_empty():
		return
	get_viewport().set_input_as_handled()
	push()


func push() -> void:
	if busy:
		return
	busy = true
	var time: float = GameManager.stats.effect("str", "push_time")
	var hero: Hero = hotspot.hero
	if hero:
		hero.play_pose("interact_mid")
		hero.walk_to(target + hero_offset, time)
	var start: Vector2 = global_position
	var tween: Tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_method(func(t: float) -> void: _move_to(start.lerp(target, t).round()), 0.0, 1.0, time)
	await tween.finished
	GameManager.set_flag(done_flag)
	GameManager.stats.add_xp("str", 10)
	hotspot.set_prompt(_plain_prompt)
	hotspot.say(done_line_key)
	busy = false
	EventBus.autosave_requested.emit()


func _move_to(at: Vector2) -> void:
	var delta: Vector2 = at - global_position
	global_position = at
	for rider: Node2D in riders:
		rider.global_position += delta
