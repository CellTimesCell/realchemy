extends GutTest
## Reactions: the data table links EventBus events to reactions, and a
## reaction shows its emote even when the body animation is missing.

var _player: ReactionPlayer
var _emote: Emote


func before_each() -> void:
	_emote = Emote.new()
	_emote.sprite_frames = SpriteFrames.new()
	for emote_name: String in ["sweat", "exclaim", "dots"]:
		_emote.sprite_frames.add_animation(emote_name)
		_emote.sprite_frames.add_frame(emote_name, PlaceholderTexture2D.new())
	_player = ReactionPlayer.new()
	_player.character = "ghost"
	_player.emote = _emote
	add_child_autofree(_emote)
	add_child_autofree(_player)


func test_table_has_every_reaction_for_both_characters() -> void:
	var table: Dictionary = ReactionPlayer.load_table()
	for character: String in ["hero", "ghost"]:
		var reactions: Dictionary = table["reactions"][character]
		for event_name: String in table["events"][character]:
			assert_true(EventBus.has_signal(event_name), "EventBus has '%s'" % event_name)
			assert_has(reactions, table["events"][character][event_name], "Reaction for '%s' exists" % event_name)


func test_event_without_args_plays_emote() -> void:
	EventBus.combination_failed.emit()
	assert_true(_player.busy, "Reaction started")
	assert_true(_emote.visible, "Emote shown")
	assert_eq(_emote.animation, &"sweat")


func test_event_with_args_plays_reaction() -> void:
	EventBus.hint_given.emit(2)
	assert_true(_player.busy, "hint_given(level) triggers the lecture reaction")
	assert_eq(_emote.animation, &"exclaim")
