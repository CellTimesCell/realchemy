class_name ReactionPlayer
extends Node
## Plays a character's reaction: a body animation and an emote icon together.
## Which reactions exist and which EventBus events trigger them is data
## (data/character_reactions.json, keyed by `character`). A reaction whose body
## animation is missing (not approved yet) still shows its emote.

signal reaction_started(reaction_name: String)
signal reaction_finished(reaction_name: String)

const TABLE_PATH: String = "res://data/character_reactions.json"
const EMOTE_ONLY_TIME: float = 1.4

@export var character: String = "hero"
@export var anim: AnimatedSprite2D
@export var emote: Emote
## Animation to return to after a reaction.
@export var idle_animation: String = "idle_south"
## React to the EventBus events listed for this character.
@export var listen_events: bool = true

var busy: bool = false
var _reactions: Dictionary = {}


static func load_table() -> Dictionary:
	var data: Variant = JSON.parse_string(FileAccess.get_file_as_string(TABLE_PATH))
	return data if data is Dictionary else {}


func _ready() -> void:
	var table: Dictionary = load_table()
	_reactions = table.get("reactions", {}).get(character, {})
	if listen_events:
		var events: Dictionary = table.get("events", {}).get(character, {})
		for event_name: String in events:
			_connect_event(event_name, events[event_name])


func reaction_names() -> Array:
	return _reactions.keys()


func play_reaction(reaction_name: String) -> void:
	if busy or not _reactions.has(reaction_name):
		return
	var entry: Dictionary = _reactions[reaction_name]
	var anim_name: String = entry.get("anim", "")
	var emote_name: String = entry.get("emote", "")
	busy = true
	reaction_started.emit(reaction_name)
	if emote and not emote_name.is_empty():
		emote.show_emote(emote_name)
	if anim and not anim_name.is_empty() and anim.sprite_frames.has_animation(anim_name):
		anim.flip_h = false
		anim.play(anim_name)
		await anim.animation_finished
	else:
		await get_tree().create_timer(EMOTE_ONLY_TIME).timeout
	if anim and anim.sprite_frames.has_animation(idle_animation):
		anim.play(idle_animation)
	busy = false
	reaction_finished.emit(reaction_name)


func _connect_event(event_name: String, reaction_name: String) -> void:
	if not EventBus.has_signal(event_name):
		push_warning("ReactionPlayer: no EventBus signal '%s'" % event_name)
		return
	var arg_count: int = 0
	for info: Dictionary in EventBus.get_signal_list():
		if info["name"] == event_name:
			arg_count = info["args"].size()
	var callback: Callable = play_reaction.bind(reaction_name)
	if arg_count > 0:
		callback = callback.unbind(arg_count)
	EventBus.connect(event_name, callback)
