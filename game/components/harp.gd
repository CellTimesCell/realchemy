class_name Harp
extends Node2D
## The broken harp: ui_accept in the hotspot plays its notes one after
## another (placeholder sounds) and reports each one on EventBus
## (harp_note_played) for a future music puzzle.

const NOTE_GAP: float = 0.35

@export var hotspot: Hotspot
@export var player: AudioStreamPlayer2D
@export var notes: Array[AudioStream] = []

var _playing: bool = false


func _unhandled_input(event: InputEvent) -> void:
	if _playing or not hotspot.is_active() or not event.is_action_pressed("ui_accept"):
		return
	get_viewport().set_input_as_handled()
	_play_all()


func _play_all() -> void:
	_playing = true
	for index: int in notes.size():
		player.stream = notes[index]
		player.play()
		EventBus.harp_note_played.emit(index)
		await get_tree().create_timer(NOTE_GAP).timeout
	_playing = false
