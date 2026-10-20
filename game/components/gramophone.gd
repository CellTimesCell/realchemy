class_name Gramophone
extends Node2D
## The boudoir gramophone: ui_accept in the hotspot ("Wind up") plays a short
## placeholder tune (harp notes at other pitches) while the sprite bobs by
## a pixel, reports it on EventBus.music_played (the canary sings along) and
## then the hero says a line.

const NOTE_GAP: float = 0.3
## Note indices into `notes`, played in order, all at PITCH.
const TUNE: Array[int] = [0, 1, 2, 1, 3, 2, 1, 0, 1, 2, 3, 3]
const PITCH: float = 0.8

@export var hotspot: Hotspot
@export var player: AudioStreamPlayer2D
@export var sprite: Sprite2D
@export var notes: Array[AudioStream] = []
@export var done_line_key: String = ""

var playing: bool = false


func _unhandled_input(event: InputEvent) -> void:
	if playing or not hotspot.is_active() or not event.is_action_pressed("ui_accept"):
		return
	get_viewport().set_input_as_handled()
	play_tune()


func play_tune() -> void:
	if playing or notes.is_empty():
		return
	playing = true
	EventBus.music_played.emit(true)
	var base: Vector2 = sprite.position if sprite else Vector2.ZERO
	for step: int in TUNE.size():
		player.stream = notes[TUNE[step] % notes.size()]
		player.pitch_scale = PITCH
		player.play()
		if sprite:
			sprite.position = base + Vector2(0, -(step % 2))
		await get_tree().create_timer(NOTE_GAP).timeout
	if sprite:
		sprite.position = base
	playing = false
	EventBus.music_played.emit(false)
	hotspot.say(done_line_key)
