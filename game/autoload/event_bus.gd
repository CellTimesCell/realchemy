extends Node
## Global signal hub: systems talk through these signals instead of holding
## direct references to each other.

## Emitted when a full-screen reader or dialogue opens or closes. While it is
## active, hotspot prompts are hidden and the hero ignores input.
signal modal_ui_changed(active: bool)

var modal_ui_active: bool = false


func set_modal_ui(active: bool) -> void:
	if active == modal_ui_active:
		return
	modal_ui_active = active
	modal_ui_changed.emit(active)
