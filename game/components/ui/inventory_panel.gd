class_name InventoryPanel
extends PanelContainer
## The pockets (pajamas 2x3) or the backpack (6x6): a grid of ItemSlots. A
## click on an item opens a small menu: Left hand / Right hand / Inspect.
## Inspect shows the name and the hero's line about it at the bottom.

signal closed_panel

const GAP: int = 2

var _title: Label
var _grid: GridContainer
var _desc: Label
var _menu: VBoxContainer
var _menu_slot: int = -1


func _ready() -> void:
	visible = false
	var box: StyleBoxFlat = StyleBoxFlat.new()
	box.bg_color = Color(0.05, 0.03, 0.09, 0.92)
	box.border_color = Color(0.55, 0.45, 0.65)
	box.set_border_width_all(1)
	box.set_content_margin_all(4)
	add_theme_stylebox_override("panel", box)
	var column: VBoxContainer = VBoxContainer.new()
	column.add_theme_constant_override("separation", 3)
	add_child(column)
	_title = Hud.make_label("")
	column.add_child(_title)
	_grid = GridContainer.new()
	_grid.add_theme_constant_override("h_separation", GAP)
	_grid.add_theme_constant_override("v_separation", GAP)
	column.add_child(_grid)
	_desc = Hud.make_label("")
	_desc.visible = false
	column.add_child(_desc)
	# The menu lives next to the panel (not inside the container layout).
	_menu = VBoxContainer.new()
	_menu.visible = false
	_menu.z_index = 1
	get_parent().add_child.call_deferred(_menu)
	EventBus.inventory_changed.connect(refresh)
	refresh()


func open() -> void:
	_desc.text = ""
	_desc.visible = false
	visible = true
	refresh()


func close() -> void:
	_menu.visible = false
	visible = false
	closed_panel.emit()


func refresh() -> void:
	if not is_node_ready():
		return
	var inventory: Inventory = GameManager.inventory
	var backpack: bool = inventory.capacity > Inventory.POCKETS
	_grid.columns = 6 if backpack else 3
	_title.text = "%s  %d/%d" % [tr("UI_BACKPACK" if backpack else "UI_POCKETS"), inventory.used_slots(), inventory.capacity]
	for child: Node in _grid.get_children():
		_grid.remove_child(child)
		child.queue_free()
	for i: int in inventory.capacity:
		var slot: ItemSlot = ItemSlot.new()
		var data: Dictionary = inventory.slots[i]
		slot.set_item(data.get("id", ""), int(data.get("count", 0)))
		slot.pressed.connect(_on_slot_pressed.bind(i, slot))
		_grid.add_child(slot)
	_fit.call_deferred()


## Shrinks to the content and centres above the HUD bar (36 slots fit too).
func _fit() -> void:
	size = Vector2.ZERO
	reset_size()
	var view: Vector2 = get_viewport().get_visible_rect().size
	position = Vector2(floorf((view.x - size.x) * 0.5), maxf(4.0, floorf((Hud.BAR_Y - 4.0 - size.y) * 0.5)))


## Shows the inspect text of an item (also used from the hand slots).
func describe(id: String) -> void:
	_desc.text = "%s: %s" % [tr(ItemDb.name_key(id)), tr(ItemDb.desc_key(id))]
	_desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_desc.custom_minimum_size = Vector2(_grid.size.x, 0)
	_desc.visible = true
	_fit.call_deferred()


func _on_slot_pressed(index: int, slot: ItemSlot) -> void:
	var data: Dictionary = GameManager.inventory.slots[index]
	if data.is_empty():
		_menu.visible = false
		return
	_menu_slot = index
	for child: Node in _menu.get_children():
		child.queue_free()
	for entry: Array in [["UI_LEFT_HAND", _equip.bind(Inventory.Hand.LEFT)],
			["UI_RIGHT_HAND", _equip.bind(Inventory.Hand.RIGHT)], ["UI_INSPECT", _inspect]]:
		_menu.add_child(Hud.make_button(entry[0], entry[1]))
	_menu.reset_size()
	_menu.global_position = (slot.global_position + Vector2(slot.size.x + 2, 0)).round()
	_menu.visible = true


func _equip(hand: Inventory.Hand) -> void:
	_menu.visible = false
	if not GameManager.inventory.equip(_menu_slot, hand):
		EventBus.hero_line_requested.emit(GameManager.POCKETS_FULL_KEY)


func _inspect() -> void:
	_menu.visible = false
	describe(GameManager.inventory.slots[_menu_slot].get("id", ""))
