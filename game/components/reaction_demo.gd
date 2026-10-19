class_name ReactionDemo
extends Node
## Debug: H — the ghost appears and plays all her reactions in turn;
## J — the same for the hero. Remove from release scenes.

const PAUSE: float = 0.4

@export var hero_reactions: ReactionPlayer
@export var ghost: Ghost

var _running: bool = false


func _unhandled_input(event: InputEvent) -> void:
	var key: InputEventKey = event as InputEventKey
	if not key or not key.pressed or key.echo or _running:
		return
	if key.physical_keycode == KEY_H and ghost:
		get_viewport().set_input_as_handled()
		_running = true
		await ghost.appear()
		await _play_all(ghost.reactions)
		await ghost.vanish()
		_running = false
	elif key.physical_keycode == KEY_J and hero_reactions:
		get_viewport().set_input_as_handled()
		_running = true
		await _play_all(hero_reactions)
		_running = false


func _play_all(player: ReactionPlayer) -> void:
	for reaction_name: String in player.reaction_names():
		await player.play_reaction(reaction_name)
		await get_tree().create_timer(PAUSE).timeout
