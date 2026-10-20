class_name CloseupProp
extends Node2D
## A prop whose "Use" opens a first-person close-up (FirstPersonView), e.g.
## the princess's lab table: the work place for reactions in the suite.

@export var hotspot: Hotspot
@export var view: FirstPersonView


func _unhandled_input(event: InputEvent) -> void:
	if not hotspot.is_active() or not event.is_action_pressed("ui_accept"):
		return
	get_viewport().set_input_as_handled()
	view.open()
