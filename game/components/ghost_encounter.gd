class_name GhostEncounter
extends Node
## Meeting the ghost grandmother (docs/PUZZLES.md §3-4): the first time the
## wardrobe opens she rises in it and the intro dialogue plays; then she is
## "met" (the crown hint button appears) and stays. Talk to her -> her next
## riddle (RiddlePanel).

@export var wardrobe: Interactable
@export var ghost: Ghost
## On the ghost: "Talk" once she is met.
@export var talk_hotspot: Hotspot

const MET_FLAG: String = "ghost_met"


func _ready() -> void:
	wardrobe.opened.connect(func(_prop: Interactable) -> void: meet())
	EventBus.dialogue_finished.connect(_on_dialogue_finished)
	EventBus.game_loaded.connect(_sync)
	talk_hotspot.set_prompt("UI_TALK")
	_sync()


func _unhandled_input(event: InputEvent) -> void:
	if ghost.visible and talk_hotspot.is_active() and event.is_action_pressed("ui_accept"):
		get_viewport().set_input_as_handled()
		EventBus.riddle_requested.emit()


## She rises in the open wardrobe and introduces herself (first time only).
func meet() -> void:
	if GameManager.has_flag(MET_FLAG):
		return
	# The hero jumps back a step so she is not hidden behind him.
	var hero: Hero = wardrobe.hotspot.hero
	if hero:
		hero.walk_to(hero.global_position + Vector2(-34, 6), 0.25)
	await ghost.appear()
	EventBus.sudden_event.emit()
	EventBus.dialogue_requested.emit("ghost_intro")


func _on_dialogue_finished(dialogue_id: String) -> void:
	if dialogue_id != "ghost_intro":
		return
	GameManager.set_flag(MET_FLAG)
	EventBus.autosave_requested.emit()


func _sync() -> void:
	if GameManager.has_flag(MET_FLAG) and not ghost.visible:
		ghost.visible = true
		ghost.modulate.a = 1.0
		ghost.anim.play(ghost.reactions.idle_animation)
