class_name SettingsMenu
extends CanvasLayer
## Settings stub: F2 (or open()) shows a small panel with Text size
## Small / Large. The choice is saved by SaveManager in user://.

const SIZES: Array[String] = ["small", "large"]

@export var panel: PanelContainer
@export var text_size: OptionButton
@export var close_button: Button


func _ready() -> void:
	panel.visible = false
	text_size.clear()
	text_size.add_item("UI_TEXT_SMALL")
	text_size.add_item("UI_TEXT_LARGE")
	text_size.item_selected.connect(func(index: int) -> void: SaveManager.set_text_size(SIZES[index]))
	close_button.pressed.connect(close)


func _unhandled_input(event: InputEvent) -> void:
	var key: InputEventKey = event as InputEventKey
	if key and key.pressed and not key.echo and key.physical_keycode == KEY_F2:
		get_viewport().set_input_as_handled()
		if panel.visible:
			close()
		else:
			open()


func open() -> void:
	text_size.select(SIZES.find(SaveManager.get_text_size()))
	panel.visible = true
	EventBus.set_modal_ui(true)


func close() -> void:
	panel.visible = false
	EventBus.set_modal_ui(false)
