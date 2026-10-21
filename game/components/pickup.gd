class_name Pickup
extends Node2D
## A loose thing the hero can take (the ball, the key that falls out of the
## chandelier, the prism in the wreck): ui_accept in its hotspot puts it in
## the pockets (GameManager.give_item) and it is gone for good (a flag, so
## the save remembers). Things that appear later start hidden and drop in
## with drop_to().

const DROP_TIME: float = 0.35

@export var item_id: String = ""
@export var hotspot: Hotspot
## Hidden until something drops it (the key from the chandelier).
@export var start_hidden: bool = false

var taken_flag: String = ""


func _ready() -> void:
	taken_flag = "taken_%s" % (name as String).to_snake_case()
	if hotspot:
		hotspot.set_prompt("UI_TAKE")
		hotspot.say_key = ""
	visible = not start_hidden and not GameManager.has_flag(taken_flag)
	if GameManager.has_flag("shown_%s" % (name as String).to_snake_case()) and not GameManager.has_flag(taken_flag):
		visible = true


func _unhandled_input(event: InputEvent) -> void:
	if not visible or not hotspot or not hotspot.is_active() or not event.is_action_pressed("ui_accept"):
		return
	get_viewport().set_input_as_handled()
	take()


func take() -> bool:
	if not visible or not GameManager.give_item(item_id):
		return false
	visible = false
	GameManager.set_flag(taken_flag)
	ItemPop.spawn(get_tree(), global_position + Vector2(0, -6), ItemDb.color(item_id), ItemDb.letter(item_id))
	EventBus.hero_pose_requested.emit("interact_low")
	EventBus.autosave_requested.emit()
	return true


## Shows the thing falling from `from` (world) down to where it lies.
func drop_to(from: Vector2) -> void:
	var rest: Vector2 = global_position
	global_position = from
	visible = true
	GameManager.set_flag("shown_%s" % (name as String).to_snake_case())
	var tween: Tween = create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", rest, DROP_TIME)
	await tween.finished
