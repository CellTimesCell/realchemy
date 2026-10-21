class_name HintGiver
extends Node
## The crown button: once the ghost grandmother has been met
## (flag ghost_met), each press gives the next hint level for the current
## step in her voice, with a cooldown (systems/hints/hints.gd).


func _ready() -> void:
	EventBus.hint_requested.connect(give)


func give() -> String:
	if not GameManager.has_flag("ghost_met"):
		return ""
	var hint: Dictionary = Hints.next_hint(TimeManager.now())
	EventBus.ghost_line_requested.emit(hint["key"])
	return hint["key"]
