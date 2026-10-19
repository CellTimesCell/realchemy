class_name PickupProp
extends Node2D
## Prop the hero can take something from (an orange from the tree, a hairpin
## from the vanity). ui_accept in the hotspot gives the item: EventBus
## item_found (the hero reacts) and a line in place of the prompt. When
## nothing is left, the hotspot just says empty_say_key.
## There is no inventory yet: the item only goes out as the event.

@export var hotspot: Hotspot
@export var item_id: String = ""
@export var count: int = 1
@export var taken_say_key: String = ""
@export var empty_say_key: String = ""
## Prompt shown once everything has been taken.
@export var empty_prompt_text: String = "UI_INSPECT"


func _unhandled_input(event: InputEvent) -> void:
	if not hotspot.is_active() or not event.is_action_pressed("ui_accept"):
		return
	get_viewport().set_input_as_handled()
	if count <= 0:
		hotspot.say(empty_say_key)
		return
	count -= 1
	EventBus.item_found.emit(item_id)
	if count == 0:
		hotspot.prompt_text = empty_prompt_text
	hotspot.say(taken_say_key)
