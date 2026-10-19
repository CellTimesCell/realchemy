extends Node
## Global signal hub: systems talk through these signals instead of holding
## direct references to each other.

## Emitted when a full-screen reader or dialogue opens or closes. While it is
## active, hotspot prompts are hidden and the hero ignores input.
signal modal_ui_changed(active: bool)

# --- Gameplay events the characters react to (data/character_reactions.json) --
signal reaction_completed(reaction_id: String)
signal reaction_failed(reaction_id: String)
signal item_found(item_id: String)
signal secret_found(secret_id: String)
## No useful action for a long time, or a dead end.
signal player_stuck
## Something sudden happens next to the hero (a skeleton falls out).
signal sudden_event
## The hero looks at or touches something revolting.
signal gross_thing_seen
## Two items are picked for a combination.
signal combination_selected
## Several wrong attempts in a row.
signal repeated_mistakes
## Hint system (the ghost grandmother).
signal hint_requested
signal hint_given(hint_level: int)
signal hint_on_cooldown
signal player_blunder
signal combination_failed
## Something nearby fizzed or popped (a failed reaction, never a goal).
signal loud_event

var modal_ui_active: bool = false


func set_modal_ui(active: bool) -> void:
	if active == modal_ui_active:
		return
	modal_ui_active = active
	modal_ui_changed.emit(active)
