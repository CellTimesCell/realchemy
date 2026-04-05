# TASKS — Phase 0: Prototype Sprint

## Цель Phase 0
Один рабочий кейс "Пещера вампира" с реальным таймером, drag & drop инвентарём и 4-шаговой цепочкой крафта. Без сохранений, без звука, без анимаций.

**Критерий успеха:** Пройти кейс от начала до Victory Screen за один сеанс.

---

## PROGRESS LOG (обновляй здесь)
```
[ ] TASK-01: Autoload синглтоны (скелеты)
[ ] TASK-02: EventBus сигналы
[ ] TASK-03: GameManager State Machine
[ ] TASK-04: data/items.json
[ ] TASK-05: data/recipes.json
[ ] TASK-06: CraftingSystem
[ ] TASK-07: InventoryManager
[ ] TASK-08: TimeManager
[ ] TASK-09: InventorySlot компонент (drag source)
[ ] TASK-10: InteractiveZone компонент (drop target)
[ ] TASK-11: CaseUI главный экран
[ ] TASK-12: VictoryScreen
[ ] TASK-13: FailScreen
[ ] TASK-14: Main.gd точка входа
[ ] TASK-15: Интеграционный тест — полный прогон
```

---

## Прототип кейса C001 "Пещера вампира"

**Стартовый инвентарь:** `["stick", "cloth", "flint"]`

**Зоны на экране:**
- `zone_skeleton` — "Скелет у стены"
- `zone_cave_exit` — "Завал у выхода"

**Цепочка крафта (4 шага):**
```
stick + cloth      → torch_unlit    (комбинировать в инвентаре)
torch_unlit + flint → torch          (комбинировать в инвентаре)
torch → zone_skeleton               → bone_key (зона меняется на zone_skeleton_burned)
bone_key → zone_cave_exit           → VICTORY
```

**Таймер:** 480 секунд (8 минут реального времени)
**Проигрыш:** таймер истёк

---

## TASK-01: Autoload синглтоны — файловые скелеты

Создай следующие файлы в `scripts/`. Это пустые скелеты — логика будет в следующих задачах.

**`scripts/EventBus.gd`**
```gdscript
extends Node
# Сигналы будут добавлены в TASK-02
```

**`scripts/GameManager.gd`**
```gdscript
extends Node
# Логика будет в TASK-03
```

**`scripts/CraftingSystem.gd`**
```gdscript
extends Node
# Логика будет в TASK-06
```

**`scripts/InventoryManager.gd`**
```gdscript
extends Node
# Логика будет в TASK-07
```

**`scripts/TimeManager.gd`**
```gdscript
extends Node
# Логика будет в TASK-08
```

**`scripts/SaveManager.gd`**
```gdscript
extends Node
# Для Phase 0 — заглушка, не реализовывать
func save_timer(_ts: int) -> void: pass
func load_timer() -> int: return 0
func save_inventory(_slots: Array) -> void: pass
func load_inventory() -> Array: return []
```

После создания файлов — запиши в `project.godot` раздел autoload (если файл существует):
```ini
[autoload]
EventBus="*res://scripts/EventBus.gd"
GameManager="*res://scripts/GameManager.gd"
CraftingSystem="*res://scripts/CraftingSystem.gd"
InventoryManager="*res://scripts/InventoryManager.gd"
TimeManager="*res://scripts/TimeManager.gd"
SaveManager="*res://scripts/SaveManager.gd"
```

✅ Критерий: все 6 файлов существуют, нет синтаксических ошибок.

---

## TASK-02: EventBus — все сигналы MVP

Замени содержимое `scripts/EventBus.gd`:

```gdscript
# EventBus.gd — Autoload
# Центральная шина событий. Все системы общаются только через неё.
extends Node

## Состояния игры
signal game_state_changed(new_state: int)

## Крафт
signal item_combined(item_a_id: String, item_b_id: String, result_id: String)
signal item_placed_on_zone(item_id: String, zone_id: String, result_id: String)
signal craft_failed(item_a_id: String, item_b_id: String)

## Инвентарь
signal item_added_to_inventory(item_id: String)
signal item_removed_from_inventory(item_id: String)
signal inventory_full()

## Таймер
signal case_timer_tick(seconds_remaining: float)
signal case_timer_expired()

## Кейс
signal case_victory(case_id: String)
signal case_fail(case_id: String, reason: String)

## UI
signal show_notification(text: String, color: String)
```

✅ Критерий: файл создан, синтаксис валиден.

---

## TASK-03: GameManager — State Machine

Замени содержимое `scripts/GameManager.gd`:

```gdscript
# GameManager.gd — Autoload
# Главный контроллер состояний игры.
extends Node

enum GameState {
    BOOT,
    MAIN_MENU,
    IN_CASE,
    PAUSED,
    VICTORY,
    FAIL
}

var current_state: GameState = GameState.BOOT
var active_case_id: String = ""

func _ready() -> void:
    # Подписка на события завершения кейса
    EventBus.case_victory.connect(_on_case_victory)
    EventBus.case_timer_expired.connect(_on_timer_expired)

func start_case(case_id: String) -> void:
    active_case_id = case_id
    change_state(GameState.IN_CASE)

func change_state(new_state: GameState) -> void:
    current_state = new_state
    EventBus.game_state_changed.emit(int(new_state))
    print("[GameManager] State: ", GameState.keys()[new_state])

func _on_case_victory(case_id: String) -> void:
    change_state(GameState.VICTORY)

func _on_timer_expired() -> void:
    change_state(GameState.FAIL)
    EventBus.case_fail.emit(active_case_id, "timer_expired")
```

✅ Критерий: файл создан. GameManager.current_state существует как свойство.

---

## TASK-04: data/items.json

Создай файл `data/items.json`. Только предметы нужные для C001 + результаты крафта:

```json
[
  {
    "id": "stick",
    "name": "Палка",
    "description": "Сухая деревянная палка.",
    "icon": "res://assets/icons/stick.png",
    "tags": ["wood", "primitive"]
  },
  {
    "id": "cloth",
    "name": "Тряпка",
    "description": "Кусок промасленной ткани.",
    "icon": "res://assets/icons/cloth.png",
    "tags": ["fabric", "primitive"]
  },
  {
    "id": "flint",
    "name": "Кремень",
    "description": "Острый камень. Даёт искры.",
    "icon": "res://assets/icons/flint.png",
    "tags": ["stone", "fire_starter"]
  },
  {
    "id": "torch_unlit",
    "name": "Факел (не зажжён)",
    "description": "Нужна искра.",
    "icon": "res://assets/icons/torch_unlit.png",
    "tags": ["light", "incomplete"]
  },
  {
    "id": "torch",
    "name": "Факел",
    "description": "Горит. Освещает путь.",
    "icon": "res://assets/icons/torch.png",
    "tags": ["light", "fire"]
  },
  {
    "id": "bone_key",
    "name": "Костяной ключ",
    "description": "Выточен из кости скелета. Подходит к замку.",
    "icon": "res://assets/icons/bone_key.png",
    "tags": ["key", "bone"]
  }
]
```

✅ Критерий: файл валидный JSON, содержит 6 предметов.

---

## TASK-05: data/recipes.json

Создай файл `data/recipes.json`. 4 рецепта для прохождения C001:

```json
[
  {
    "id": "R001",
    "type": "combine",
    "input_a": "stick",
    "input_b": "cloth",
    "output": "torch_unlit",
    "consumes_inputs": true,
    "hint": "Намотай тряпку на палку."
  },
  {
    "id": "R002",
    "type": "combine",
    "input_a": "torch_unlit",
    "input_b": "flint",
    "output": "torch",
    "consumes_inputs": true,
    "hint": "Ударь кремнем по факелу."
  },
  {
    "id": "R003",
    "type": "zone_interact",
    "input_item": "torch",
    "input_zone": "zone_skeleton",
    "output": "bone_key",
    "consumes_item": true,
    "zone_changes_to": "zone_skeleton_burned",
    "hint": "Огонь разрушает кости."
  },
  {
    "id": "R004",
    "type": "zone_interact",
    "input_item": "bone_key",
    "input_zone": "zone_cave_exit",
    "output": null,
    "consumes_item": true,
    "zone_changes_to": "zone_cave_exit_open",
    "triggers_victory": true,
    "hint": "Ключ подошёл к замку."
  }
]
```

✅ Критерий: файл валидный JSON, 4 рецепта, у R004 есть `"triggers_victory": true`.

---

## TASK-06: CraftingSystem

Замени содержимое `scripts/CraftingSystem.gd`:

```gdscript
# CraftingSystem.gd — Autoload
# Загружает рецепты из JSON. Обрабатывает крафт и взаимодействие с зонами.
extends Node

var _combine_recipes: Dictionary = {}   # ключ: "itemA+itemB" → рецепт
var _zone_recipes: Dictionary = {}      # ключ: "item+zone" → рецепт

func _ready() -> void:
    _load_recipes()

func _load_recipes() -> void:
    var file = FileAccess.open("res://data/recipes.json", FileAccess.READ)
    if not file:
        push_error("[CraftingSystem] Не найден файл data/recipes.json")
        return
    var data = JSON.parse_string(file.get_as_text())
    if not data is Array:
        push_error("[CraftingSystem] Неверный формат recipes.json")
        return
    for recipe in data:
        if recipe["type"] == "combine":
            var key = _make_combine_key(recipe["input_a"], recipe["input_b"])
            _combine_recipes[key] = recipe
        elif recipe["type"] == "zone_interact":
            var key = recipe["input_item"] + "+" + recipe["input_zone"]
            _zone_recipes[key] = recipe
    print("[CraftingSystem] Загружено рецептов: ", data.size())

## Попытка скомбинировать два предмета из инвентаря.
## Возвращает id результата или "" если рецепта нет.
func try_combine(item_a: String, item_b: String) -> String:
    var key = _make_combine_key(item_a, item_b)
    if _combine_recipes.has(key):
        var recipe = _combine_recipes[key]
        var result_id: String = recipe["output"]
        if recipe.get("consumes_inputs", true):
            InventoryManager.remove_item(item_a)
            InventoryManager.remove_item(item_b)
        InventoryManager.add_item(result_id)
        EventBus.item_combined.emit(item_a, item_b, result_id)
        print("[CraftingSystem] Крафт: ", item_a, " + ", item_b, " = ", result_id)
        return result_id
    else:
        EventBus.craft_failed.emit(item_a, item_b)
        print("[CraftingSystem] Нет рецепта: ", item_a, " + ", item_b)
        return ""

## Попытка использовать предмет на зоне.
## Возвращает словарь рецепта или {} если рецепта нет.
func try_zone_interact(item_id: String, zone_id: String) -> Dictionary:
    var key = item_id + "+" + zone_id
    if _zone_recipes.has(key):
        var recipe = _zone_recipes[key]
        if recipe.get("consumes_item", true):
            InventoryManager.remove_item(item_id)
        var output = recipe.get("output", "")
        if output != "" and output != null:
            InventoryManager.add_item(output)
        EventBus.item_placed_on_zone.emit(item_id, zone_id, output)
        if recipe.get("triggers_victory", false):
            EventBus.case_victory.emit(GameManager.active_case_id)
        print("[CraftingSystem] Зона: ", item_id, " → ", zone_id, " = ", output)
        return recipe
    print("[CraftingSystem] Нет зонального рецепта: ", item_id, " → ", zone_id)
    return {}

func _make_combine_key(a: String, b: String) -> String:
    var arr = [a, b]
    arr.sort()
    return arr[0] + "+" + arr[1]
```

✅ Критерий: все 4 рецепта работают. try_combine("stick", "cloth") возвращает "torch_unlit".

---

## TASK-07: InventoryManager

Замени содержимое `scripts/InventoryManager.gd`:

```gdscript
# InventoryManager.gd — Autoload
# Управляет инвентарём игрока. Максимум MAX_SLOTS предметов.
extends Node

const MAX_SLOTS: int = 6

var slots: Array[String] = []

func _ready() -> void:
    # Phase 0: стартовый инвентарь захардкожен
    slots = ["stick", "cloth", "flint"]
    print("[InventoryManager] Старт инвентарь: ", slots)

func add_item(item_id: String) -> bool:
    if slots.size() >= MAX_SLOTS:
        EventBus.inventory_full.emit()
        push_warning("[InventoryManager] Инвентарь полон, нельзя добавить: " + item_id)
        return false
    slots.append(item_id)
    EventBus.item_added_to_inventory.emit(item_id)
    print("[InventoryManager] Добавлен: ", item_id, " | Инвентарь: ", slots)
    return true

func remove_item(item_id: String) -> bool:
    var idx = slots.find(item_id)
    if idx == -1:
        push_warning("[InventoryManager] Предмет не найден: " + item_id)
        return false
    slots.remove_at(idx)
    EventBus.item_removed_from_inventory.emit(item_id)
    print("[InventoryManager] Удалён: ", item_id, " | Инвентарь: ", slots)
    return true

func has_item(item_id: String) -> bool:
    return item_id in slots

func get_all_items() -> Array[String]:
    return slots.duplicate()
```

✅ Критерий: стартовый инвентарь ["stick", "cloth", "flint"], add/remove работают.

---

## TASK-08: TimeManager

Замени содержимое `scripts/TimeManager.gd`:

```gdscript
# TimeManager.gd — Autoload
# ВАЖНО: Хранит момент ОКОНЧАНИЯ (Unix timestamp), а не остаток времени.
# Это позволяет таймеру корректно работать даже если приложение было закрыто.
extends Node

var _case_end_timestamp: int = 0
var _is_running: bool = false

func start_timer(duration_seconds: int) -> void:
    _case_end_timestamp = int(Time.get_unix_time_from_system()) + duration_seconds
    _is_running = true
    SaveManager.save_timer(_case_end_timestamp)
    print("[TimeManager] Таймер запущен. Конец в: ", _case_end_timestamp,
          " | Осталось: ", duration_seconds, "с")
    set_process(true)

func get_seconds_remaining() -> float:
    if not _is_running:
        return 0.0
    var now: float = Time.get_unix_time_from_system()
    return maxf(0.0, float(_case_end_timestamp) - now)

func stop_timer() -> void:
    _is_running = false
    set_process(false)

func _process(_delta: float) -> void:
    var remaining: float = get_seconds_remaining()
    EventBus.case_timer_tick.emit(remaining)
    if remaining <= 0.0:
        stop_timer()
        print("[TimeManager] Время вышло!")
        EventBus.case_timer_expired.emit()

func format_time(seconds: float) -> String:
    var mins: int = int(seconds) / 60
    var secs: int = int(seconds) % 60
    return "%02d:%02d" % [mins, secs]
```

✅ Критерий: get_seconds_remaining() возвращает корректное значение. При 0 — эмитит case_timer_expired.

---

## TASK-09: InventorySlot компонент (drag source)

Создай файл `scenes/case_ui/components/InventorySlot.gd`:

```gdscript
# InventorySlot.gd
# UI-слот инвентаря. Отображает предмет и является источником drag & drop.
extends PanelContainer

@export var item_id: String = ""

@onready var icon_texture: TextureRect = $VBoxContainer/IconTexture
@onready var label_name: Label = $VBoxContainer/LabelName

func setup(id: String) -> void:
    item_id = id
    # Загружаем данные предмета из items.json
    # Phase 0: показываем только id как текст
    label_name.text = id
    # TODO: загрузить иконку из items.json когда будут ассеты

## Godot Drag & Drop — что передаём при перетаскивании
func _get_drag_data(_pos: Vector2) -> Variant:
    if item_id.is_empty():
        return null
    # Создаём превью
    var preview_label = Label.new()
    preview_label.text = "[" + item_id + "]"
    set_drag_preview(preview_label)
    return {"item_id": item_id, "source_slot": self}
```

Создай тестовую сцену `scenes/case_ui/components/InventorySlot.tscn`:
```
[Узловая структура для InventorySlot.tscn]
PanelContainer (скрипт: InventorySlot.gd)
  └── VBoxContainer
        ├── IconTexture (TextureRect, expand=true, stretch_mode=keep_aspect)
        └── LabelName (Label, horizontal_alignment=center)
```

> **Примечание:** `.tscn` файлы создавай только если умеешь генерировать валидный Godot scene format. Если нет — создай только `.gd` файл и напиши комментарий `# TSCN: создать руками в Godot Editor`.

✅ Критерий: InventorySlot.gd создан, _get_drag_data возвращает Dictionary с item_id.

---

## TASK-10: InteractiveZone компонент (drop target)

Создай файл `scenes/case_ui/components/InteractiveZone.gd`:

```gdscript
# InteractiveZone.gd
# Интерактивная зона на экране кейса. Принимает предметы через drag & drop.
extends PanelContainer

@export var zone_id: String = ""
@export var zone_label: String = "Зона"
@export var current_state: String = "default"

@onready var label: Label = $Label

func _ready() -> void:
    label.text = zone_label

func setup(id: String, display_label: String, state: String = "default") -> void:
    zone_id = id
    zone_label = display_label
    current_state = state
    label.text = zone_label

## Godot Drag & Drop — принимаем любой предмет
func _can_drop_data(_pos: Vector2, data: Variant) -> bool:
    # Принимаем если это словарь с item_id
    if data is Dictionary and data.has("item_id"):
        return true
    return false

func _drop_data(_pos: Vector2, data: Variant) -> void:
    var item_id: String = data["item_id"]
    print("[InteractiveZone] Предмет '", item_id, "' брошен на зону '", zone_id, "'")
    var result: Dictionary = CraftingSystem.try_zone_interact(item_id, zone_id)
    if not result.is_empty():
        # Обновить отображение зоны если она изменилась
        var new_state: String = result.get("zone_changes_to", current_state)
        _change_state(new_state)

func _change_state(new_state: String) -> void:
    current_state = new_state
    # Визуальное изменение зоны
    match new_state:
        "zone_skeleton_burned":
            label.text = "Сожжённый скелет"
            modulate = Color(0.5, 0.5, 0.5)
        "zone_cave_exit_open":
            label.text = "Выход открыт!"
            modulate = Color(0.3, 1.0, 0.3)
        _:
            label.text = zone_label
            modulate = Color(1, 1, 1)
```

✅ Критерий: _can_drop_data и _drop_data реализованы, вызывают CraftingSystem.try_zone_interact.

---

## TASK-11: CaseUI — главный игровой экран

Создай `scenes/case_ui/CaseUI.gd`:

```gdscript
# CaseUI.gd
# Главный игровой экран. Управляет отображением кейса C001.
extends Control

# Ссылки на UI элементы (назначаются в редакторе или создаются динамически)
@onready var timer_label: Label = $TimerLabel
@onready var inventory_container: HBoxContainer = $InventoryContainer
@onready var zones_container: VBoxContainer = $ZonesContainer
@onready var notification_label: Label = $NotificationLabel

# Phase 0: данные кейса захардкожены
const CASE_ID: String = "C001"
const CASE_TIMER_SECONDS: int = 480

# Данные для комбинирования в инвентаре
var _selected_item: String = ""
var _inventory_slots: Array = []
var _zone_nodes: Dictionary = {}

func _ready() -> void:
    _connect_signals()
    _setup_case()

func _connect_signals() -> void:
    EventBus.case_timer_tick.connect(_on_timer_tick)
    EventBus.item_added_to_inventory.connect(_refresh_inventory)
    EventBus.item_removed_from_inventory.connect(_refresh_inventory)
    EventBus.craft_failed.connect(_on_craft_failed)
    EventBus.item_combined.connect(_on_item_combined)
    EventBus.item_placed_on_zone.connect(_on_zone_interacted)

func _setup_case() -> void:
    GameManager.start_case(CASE_ID)
    TimeManager.start_timer(CASE_TIMER_SECONDS)
    _setup_zones()
    _refresh_inventory("")

func _setup_zones() -> void:
    # Создаём зоны динамически
    var zone_data = [
        {"id": "zone_skeleton", "label": "💀 Скелет у стены"},
        {"id": "zone_cave_exit", "label": "🪨 Завал у выхода"}
    ]
    for zd in zone_data:
        var zone = preload("res://scenes/case_ui/components/InteractiveZone.gd")
        var zone_panel = PanelContainer.new()
        var zone_script = zone.new()
        # Используем простую кнопку как зону для Phase 0
        var btn = Button.new()
        btn.text = zd["label"]
        btn.set_meta("zone_id", zd["id"])
        btn.pressed.connect(_on_zone_button_pressed.bind(zd["id"]))
        zones_container.add_child(btn)
        _zone_nodes[zd["id"]] = btn

func _refresh_inventory(_item_id: String = "") -> void:
    # Очищаем и перестраиваем инвентарь
    for child in inventory_container.get_children():
        child.queue_free()
    await get_tree().process_frame  # ждём удаления
    var items = InventoryManager.get_all_items()
    for item_id in items:
        var btn = Button.new()
        btn.text = item_id
        btn.pressed.connect(_on_inventory_item_pressed.bind(item_id))
        if _selected_item == item_id:
            btn.modulate = Color(1.0, 0.8, 0.2)  # выделение жёлтым
        inventory_container.add_child(btn)

func _on_inventory_item_pressed(item_id: String) -> void:
    if _selected_item.is_empty():
        # Первый выбранный предмет
        _selected_item = item_id
        _show_notification("Выбран: " + item_id + ". Выбери второй предмет или зону.")
        _refresh_inventory("")
    elif _selected_item == item_id:
        # Снимаем выделение
        _selected_item = ""
        _refresh_inventory("")
    else:
        # Второй предмет — пробуем скомбинировать
        var result = CraftingSystem.try_combine(_selected_item, item_id)
        _selected_item = ""
        _refresh_inventory("")

func _on_zone_button_pressed(zone_id: String) -> void:
    if _selected_item.is_empty():
        _show_notification("Сначала выбери предмет в инвентаре.")
        return
    CraftingSystem.try_zone_interact(_selected_item, zone_id)
    _selected_item = ""

func _on_timer_tick(seconds_remaining: float) -> void:
    timer_label.text = TimeManager.format_time(seconds_remaining)
    # Красный таймер когда меньше 60 секунд
    if seconds_remaining < 60.0:
        timer_label.modulate = Color(1.0, 0.2, 0.2)

func _on_craft_failed(item_a: String, item_b: String) -> void:
    _show_notification("❌ " + item_a + " + " + item_b + " — ничего не получилось.")

func _on_item_combined(item_a: String, item_b: String, result: String) -> void:
    _show_notification("✅ Получено: " + result + "!")

func _on_zone_interacted(item_id: String, zone_id: String, result_id: String) -> void:
    var msg = "✅ " + item_id + " → зона"
    if result_id != "":
        msg += " | Получено: " + result_id
    _show_notification(msg)

func _show_notification(text: String) -> void:
    notification_label.text = text
    # Автоочистка через 3 секунды
    await get_tree().create_timer(3.0).timeout
    if notification_label.text == text:
        notification_label.text = ""
```

> **TSCN для CaseUI:** Создать в Godot Editor. Корень — Control, добавить:
> - Label (name: TimerLabel) — вверху по центру
> - HBoxContainer (name: InventoryContainer) — внизу, для слотов инвентаря
> - VBoxContainer (name: ZonesContainer) — в центре, для зон
> - Label (name: NotificationLabel) — над инвентарём

✅ Критерий: CaseUI.gd создан, все методы реализованы, подключения к EventBus сделаны.

---

## TASK-12: VictoryScreen

Создай `scenes/overlays/VictoryScreen.gd`:

```gdscript
# VictoryScreen.gd
extends Control

@onready var time_label: Label = $TimeLabel

func _ready() -> void:
    EventBus.case_victory.connect(_on_victory)
    hide()

func _on_victory(case_id: String) -> void:
    TimeManager.stop_timer()
    show()
    # TODO Phase 1: показать время прохождения

func _on_retry_pressed() -> void:
    get_tree().reload_current_scene()

func _on_next_pressed() -> void:
    # TODO Phase 1: загрузить следующий кейс
    get_tree().reload_current_scene()
```

✅ Критерий: VictoryScreen.gd создан, реагирует на EventBus.case_victory.

---

## TASK-13: FailScreen

Создай `scenes/overlays/FailScreen.gd`:

```gdscript
# FailScreen.gd
extends Control

@onready var reason_label: Label = $ReasonLabel

func _ready() -> void:
    EventBus.case_fail.connect(_on_fail)
    hide()

func _on_fail(case_id: String, reason: String) -> void:
    show()
    match reason:
        "timer_expired":
            reason_label.text = "Время вышло. Рассвет не наступил для тебя."
        _:
            reason_label.text = "Кейс провален."

func _on_retry_pressed() -> void:
    get_tree().reload_current_scene()
```

✅ Критерий: FailScreen.gd создан, реагирует на EventBus.case_fail.

---

## TASK-14: Main.gd — точка входа

Создай `Main.gd` (или в корне scenes/):

```gdscript
# Main.gd — точка входа игры
extends Node

func _ready() -> void:
    print("=== REALCHEMY Phase 0 Prototype ===")
    # Phase 0: сразу загружаем CaseUI
    var case_ui = load("res://scenes/case_ui/CaseUI.tscn")
    if case_ui:
        get_tree().change_scene_to_packed(case_ui)
    else:
        push_error("[Main] Не найдена сцена CaseUI.tscn")
        # Fallback: создаём CaseUI программно
        var ui_node = preload("res://scenes/case_ui/CaseUI.gd").new()
        add_child(ui_node)
```

✅ Критерий: Main.gd создан.

---

## TASK-15: Интеграционный тест — полный прогон

Это не код — это чеклист проверки что всё работает вместе.

Запусти Godot и проверь в Output log:

```
[ ] "[CraftingSystem] Загружено рецептов: 4" — JSON читается корректно
[ ] "[InventoryManager] Старт инвентарь: [stick, cloth, flint]" — инвентарь инициализирован
[ ] "[TimeManager] Таймер запущен." — таймер стартует
[ ] Нажать "stick" → нажать "cloth" → в логе "[CraftingSystem] Крафт: cloth + stick = torch_unlit"
[ ] torch_unlit появился в инвентаре, stick и cloth исчезли
[ ] Нажать "torch_unlit" → нажать "flint" → получить "torch"
[ ] Нажать "torch" → нажать зону "Скелет" → получить "bone_key"
[ ] Зона поменяла текст на "Сожжённый скелет"
[ ] Нажать "bone_key" → нажать зону "Завал" → Victory Screen появился
[ ] Таймер остановился
```

Если хотя бы 7 из 9 пунктов выполнены — Phase 0 завершена.

---

## ПОСЛЕ ЗАВЕРШЕНИЯ PHASE 0

Обнови `PROGRESS.md` и напиши мне:
1. Что работает
2. Что не работает и почему
3. Какие файлы .tscn нужно создать руками в Godot Editor

Следующий шаг: Phase 1 — JSON-driven кейсы, сохранения, аудио.
