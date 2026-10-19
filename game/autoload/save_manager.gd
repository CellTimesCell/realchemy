extends Node
## Saves and settings in user://. For now only settings (ConfigFile):
##   text_size - "small" (UiStyle variant B) or "large" (variant A).
## Defaults depend on the platform: PC small, Android large.
## Changes go out as EventBus.settings_changed(key).

const SETTINGS_PATH: String = "user://settings.cfg"
const TEXT_SIZE_SMALL: String = "small"
const TEXT_SIZE_LARGE: String = "large"

var _config: ConfigFile = ConfigFile.new()


func _ready() -> void:
	_config.load(SETTINGS_PATH)
	_apply_text_size()


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
