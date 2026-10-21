extends Node
## Saves and settings in user://.
## Settings (ConfigFile, settings.cfg): text_size - "small" (UiStyle variant
## B) or "large" (variant A); PC defaults to small, Android to large. Changes
## go out as EventBus.settings_changed(key).
## The game (JSON, save.json): GameManager (mode, flags, inventory and hands,
## stats, Codex, room, hero position), TimeManager processes (Unix
## timestamps) and the state of every node in the "persist" group
## (save_state / load_state, keyed by path from the scene). Autosave: on
## EventBus.autosave_requested (debounced), on a room change and on quit.
## After a load EventBus.game_loaded lets nodes re-read their flags.

const SETTINGS_PATH: String = "user://settings.cfg"
const TEXT_SIZE_SMALL: String = "small"
const TEXT_SIZE_LARGE: String = "large"
const SAVE_PATH: String = "user://save.json"
const SAVE_VERSION: int = 1
const AUTOSAVE_DELAY: float = 0.3
const PERSIST_GROUP: StringName = &"persist"

## Off for screenshots and tests: the scene starts fresh.
var load_on_start: bool = true
var save_path: String = SAVE_PATH
var _scene: Node
var _save_queued: bool = false

var _config: ConfigFile = ConfigFile.new()


func _ready() -> void:
	_config.load(SETTINGS_PATH)
	_apply_text_size()
	EventBus.autosave_requested.connect(request_save)
	get_window().size_changed.connect(_on_window_resized)
	_on_window_resized()


static func default_text_size() -> String:
	return TEXT_SIZE_LARGE if OS.get_name() == "Android" else TEXT_SIZE_SMALL


func get_text_size() -> String:
	return _config.get_value("ui", "text_size", default_text_size())


func set_text_size(value: String) -> void:
	if value != TEXT_SIZE_SMALL and value != TEXT_SIZE_LARGE:
		return
	_config.set_value("ui", "text_size", value)
	_config.save(SETTINGS_PATH)
	_apply_text_size()
	EventBus.settings_changed.emit("text_size")


func _apply_text_size() -> void:
	UiStyle.variant = "B" if get_text_size() == TEXT_SIZE_SMALL else "A"


## Small text turns into Large on a window under 1280x720 (UiStyle); tell
## the prompts and bubbles when a resize crosses that line.
func _on_window_resized() -> void:
	var before: String = UiStyle.get_variant()
	UiStyle.window_size = get_window().size
	if UiStyle.get_variant() != before:
		EventBus.settings_changed.emit("text_size")



# --- Game save ------------------------------------------------------------------

## The playing scene calls this once it is ready: it is what gets saved, and
## the last save is loaded into it.
func register_scene(scene: Node) -> void:
	_scene = scene
	if load_on_start and has_save():
		load_game()


func has_save() -> bool:
	return FileAccess.file_exists(save_path)


func delete_save() -> void:
	if has_save():
		DirAccess.remove_absolute(ProjectSettings.globalize_path(save_path))


## Saves a moment later (several changes in one step make one write).
func request_save() -> void:
	if _save_queued or not _scene:
		return
	_save_queued = true
	await get_tree().create_timer(AUTOSAVE_DELAY).timeout
	_save_queued = false
	save_game()


func snapshot() -> Dictionary:
	var nodes: Dictionary = {}
	if is_instance_valid(_scene):
		var hero: Node2D = _scene.get("hero") as Node2D
		if hero:
			GameManager.hero_position = hero.global_position
		for node: Node in get_tree().get_nodes_in_group(PERSIST_GROUP):
			if _scene.is_ancestor_of(node) and node.has_method("save_state"):
				nodes[str(_scene.get_path_to(node))] = node.call("save_state")
	return {
		"version": SAVE_VERSION, "saved_at": int(Time.get_unix_time_from_system()),
		"game": GameManager.to_dict(), "time": TimeManager.to_dict(), "nodes": nodes,
	}


func save_game() -> bool:
	var file: FileAccess = FileAccess.open(save_path, FileAccess.WRITE)
	if not file:
		push_warning("SaveManager: cannot write %s" % save_path)
		return false
	file.store_string(JSON.stringify(snapshot(), "\t"))
	return true


func load_game() -> bool:
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(save_path)) if has_save() else null
	if not parsed is Dictionary or int(parsed.get("version", 0)) != SAVE_VERSION:
		return false
	apply(parsed)
	return true


func apply(data: Dictionary) -> void:
	GameManager.from_dict(data.get("game", {}))
	TimeManager.from_dict(data.get("time", {}))
	if is_instance_valid(_scene):
		var nodes: Dictionary = data.get("nodes", {})
		for path: String in nodes:
			var node: Node = _scene.get_node_or_null(path)
			if node and node.has_method("load_state"):
				node.call("load_state", nodes[path])
		var hero: Node2D = _scene.get("hero") as Node2D
		if hero and GameManager.hero_position != Vector2.ZERO:
			hero.global_position = GameManager.hero_position
	EventBus.game_loaded.emit()


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST and is_instance_valid(_scene):
		save_game()
