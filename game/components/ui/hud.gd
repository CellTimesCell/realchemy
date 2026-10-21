class_name Hud
extends CanvasLayer
## Bottom HUD: health and energy orbs (left), the two hands with Combine
## between them (centre), the bag, the guild card and the hint crown
## (right). The bag (button or I) opens the pockets panel; a click on a hand
## opens Put away / Swap / Inspect. While a panel or menu is open the game is
## modal (the hero stands still, prompts hide). Placeholders, CLAUDE.md §8.

const BAR_Y: float = 337.0
const FONT_SIZE: int = 8

var health_orb: StatOrb
var energy_orb: StatOrb
var hand_slots: Array[ItemSlot] = []
var combine_button: Button
var bag_button: ItemSlot
var card_button: ItemSlot
var hint_button: ItemSlot
var panel: InventoryPanel
var card: GuildCard
var _root: Control
var _hand_menu: VBoxContainer
var _menu_hand: Inventory.Hand = Inventory.Hand.LEFT
var _aim_hint: Label
var _toast: Label
var _toast_token: int = 0


static func make_label(text_value: String) -> Label:
	var label: Label = Label.new()
	label.text = text_value
	label.add_theme_color_override("font_color", Color(0.93, 0.9, 0.96))
	if ResourceLoader.exists(UiStyle.TINY5):
		label.add_theme_font_override("font", load(UiStyle.TINY5))
		label.add_theme_font_size_override("font_size", FONT_SIZE)
	return label


static func make_button(text_value: String, on_press: Callable) -> Button:
	var button: Button = Button.new()
	button.text = text_value
	button.focus_mode = Control.FOCUS_NONE
	if ResourceLoader.exists(UiStyle.TINY5):
		button.add_theme_font_override("font", load(UiStyle.TINY5))
		button.add_theme_font_size_override("font_size", FONT_SIZE)
	button.pressed.connect(on_press)
	return button


func _ready() -> void:
	layer = 20
	_root = Control.new()
	_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_root)
	health_orb = _orb(Color(0.85, 0.15, 0.2), "H", Vector2(6, BAR_Y))
	energy_orb = _orb(Color(0.2, 0.45, 0.95), "E", Vector2(27, BAR_Y))
	for i: int in 2:
		var slot: ItemSlot = ItemSlot.new("L" if i == 0 else "R")
		slot.position = Vector2(278 + i * 62, BAR_Y - 1)
		slot.pressed.connect(_on_hand_pressed.bind(i, slot))
		_root.add_child(slot)
		hand_slots.append(slot)
	combine_button = make_button("UI_COMBINE", _on_combine)
	combine_button.position = Vector2(300, BAR_Y + 2)
	combine_button.custom_minimum_size = Vector2(38, 16)
	var box: StyleBoxFlat = StyleBoxFlat.new()
	box.bg_color = Color(0.25, 0.16, 0.32, 0.95)
	box.border_color = Color(0.85, 0.7, 0.4)
	box.set_border_width_all(1)
	box.set_content_margin_all(1)
	for style: String in ["normal", "hover", "pressed"]:
		combine_button.add_theme_stylebox_override(style, box)
	var off: StyleBoxFlat = box.duplicate()
	off.bg_color = Color(0.1, 0.07, 0.12, 0.7)
	off.border_color = Color(0.4, 0.34, 0.45)
	combine_button.add_theme_stylebox_override("disabled", off)
	_root.add_child(combine_button)
	bag_button = _corner_button("B", Color(0.62, 0.44, 0.26), 0, _toggle_panel)
	card_button = _corner_button("F", Color(0.62, 0.5, 0.85), 1, _toggle_card)
	# The crown (hint): a gold placeholder until the icon exists.
	hint_button = _corner_button("?", Color(1, 0.82, 0.3), 2, func() -> void: EventBus.hint_requested.emit())
	ItemPop.target = bag_button.position + ItemSlot.SIZE * 0.5
	panel = InventoryPanel.new()
	panel.position = Vector2(230, 150)
	_root.add_child(panel)
	panel.closed_panel.connect(func() -> void: EventBus.set_modal_ui(false))
	card = GuildCard.new()
	card.position = Vector2(200, 70)
	_root.add_child(card)
	_root.add_child(GhostVoice.new())
	_aim_hint = make_label("UI_AIM_HINT")
	_aim_hint.position = Vector2(250, BAR_Y - 13)
	_aim_hint.visible = false
	_root.add_child(_aim_hint)
	_toast = make_label("")
	_toast.position = Vector2(6, 6)
	_toast.visible = false
	_root.add_child(_toast)
	EventBus.codex_unlocked.connect(_on_codex_unlocked)
	_hand_menu = VBoxContainer.new()
	_hand_menu.visible = false
	_root.add_child(_hand_menu)
	EventBus.inventory_changed.connect(refresh)
	EventBus.stats_changed.connect(refresh)
	EventBus.flag_changed.connect(func(_flag: String, _value: Variant) -> void: refresh())
	refresh()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		get_viewport().set_input_as_handled()
		_toggle_panel()
	elif event.is_action_pressed("ui_cancel") and (panel.visible or card.visible or _hand_menu.visible):
		get_viewport().set_input_as_handled()
		close_all()


func refresh() -> void:
	var inventory: Inventory = GameManager.inventory
	for i: int in 2:
		hand_slots[i].set_item(inventory.hands[i])
		hand_slots[i].set_active(not inventory.hands[i].is_empty() and inventory.last_hand == i)
	combine_button.disabled = not inventory.both_hands_full()
	health_orb.set_value(GameManager.stats.health, HeroStats.health_max())
	energy_orb.set_value(GameManager.stats.energy, HeroStats.energy_max())
	# The crown appears once the ghost grandmother has been met.
	hint_button.visible = GameManager.has_flag("ghost_met")
	var throwable: bool = false
	for id: String in inventory.active_items():
		throwable = throwable or ItemDb.has_tag(id, "throwable")
	_aim_hint.visible = throwable


## A new science fact (shown once the Handbook is found).
func _on_codex_unlocked(entry_id: String) -> void:
	if not GameManager.has_flag("has_handbook"):
		return
	_toast_token += 1
	var token: int = _toast_token
	_toast.text = "%s %s" % [tr("UI_CODEX_NEW"), ChemistryEngine.codex_title(entry_id)]
	_toast.visible = true
	await get_tree().create_timer(3.0).timeout
	if token == _toast_token:
		_toast.visible = false


func close_all() -> void:
	_hand_menu.visible = false
	if panel.visible:
		panel.close()
	if card.visible:
		card.close()
	EventBus.set_modal_ui(false)


func open_panel() -> void:
	close_all()
	EventBus.set_modal_ui(true)
	panel.open()


func _toggle_panel() -> void:
	if panel.visible:
		close_all()
	else:
		open_panel()


func _toggle_card() -> void:
	if card.visible:
		close_all()
	else:
		close_all()
		EventBus.set_modal_ui(true)
		card.open()


func _on_combine() -> void:
	var result: Dictionary = GameManager.inventory.combine()
	if not result["ok"]:
		EventBus.combination_failed.emit()
	else:
		EventBus.combination_selected.emit()
	EventBus.hero_line_requested.emit(result["line_key"])


func _on_hand_pressed(hand: int, slot: ItemSlot) -> void:
	if GameManager.inventory.hands[hand].is_empty():
		open_panel()
		return
	_menu_hand = hand as Inventory.Hand
	for child: Node in _hand_menu.get_children():
		child.queue_free()
	_hand_menu.add_child(make_button("UI_PUT_AWAY", _put_away))
	_hand_menu.add_child(make_button("UI_SWAP", _swap))
	_hand_menu.add_child(make_button("UI_INSPECT", _inspect_hand))
	_hand_menu.reset_size()
	_hand_menu.position = (slot.position + Vector2(0, -_hand_menu.size.y - 2)).round()
	_hand_menu.visible = true
	EventBus.set_modal_ui(true)


func _put_away() -> void:
	if not GameManager.inventory.put_away(_menu_hand):
		EventBus.hero_line_requested.emit(GameManager.POCKETS_FULL_KEY)
	close_all()


func _swap() -> void:
	GameManager.inventory.swap_hands()
	close_all()


func _inspect_hand() -> void:
	var id: String = GameManager.inventory.hands[_menu_hand]
	close_all()
	EventBus.hero_line_requested.emit(ItemDb.desc_key(id))


func _orb(color: Color, letter: String, at: Vector2) -> StatOrb:
	var orb: StatOrb = StatOrb.new()
	orb.fill_color = color
	orb.letter = letter
	orb.position = at
	orb.size = Vector2(18, 18)
	_root.add_child(orb)
	return orb


func _corner_button(symbol: String, color: Color, index: int, on_press: Callable) -> ItemSlot:
	var button: ItemSlot = ItemSlot.new()
	button.set_symbol(symbol, color)
	button.position = Vector2(560 + index * 24, BAR_Y - 1)
	button.pressed.connect(on_press)
	_root.add_child(button)
	return button
