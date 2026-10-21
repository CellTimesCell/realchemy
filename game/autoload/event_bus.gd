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
## The player started a reaction with a dangerous by-product (a warning, never
## a goal). The canary in the boudoir gets anxious.
signal danger_reaction_started(reaction_id: String)
## A harp string was played (index into the harp's notes). Groundwork for a
## music puzzle.
signal harp_note_played(note_index: int)
## The boudoir gramophone started (true) or stopped (false) playing. The canary
## sings along.
signal music_played(playing: bool)

## A player setting changed (SaveManager), e.g. "text_size".
signal settings_changed(key: String)

# --- Game state (GameManager, TimeManager, inventory) -------------------------
## A story / puzzle flag was set or cleared (GameManager.flags).
signal flag_changed(flag: String, value: Variant)
## Pockets, hands or capacity changed.
signal inventory_changed
## Something the hero has to say (a key): the hero's bubble shows it.
signal hero_line_requested(key: String)
## The hero should play an interaction pose ("interact_mid"...).
signal hero_pose_requested(pose: String)
## A named puzzle event for scene scripts (data/use_rules.json "event").
signal puzzle_event(event_name: String)
## A Codex entry (science fact) was unlocked.
signal codex_unlocked(entry_id: String)
## A real-time process started / finished (TimeManager).
signal process_started(process_id: String)
signal process_finished(process_id: String)
## Stats / xp changed (HeroStats).
signal stats_changed
## The ghost grandmother says something (a key); shown by the ghost's voice.
signal ghost_line_requested(key: String)
## Ask the game to save now (room change, puzzle step, quit).
signal autosave_requested
## A save was loaded: nodes re-read their flags and states.
signal game_loaded

var modal_ui_active: bool = false


func set_modal_ui(active: bool) -> void:
	if active == modal_ui_active:
		return
	modal_ui_active = active
	modal_ui_changed.emit(active)
