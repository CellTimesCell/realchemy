# ⚗️ REALCHEMY — Technical & Game Design Document
### Версия 0.1 | Статус: Pre-Production | Платформа: Android → PC/Steam

---

## 📋 ОГЛАВЛЕНИЕ

1. [Аудит исходного документа](#1-аудит)
2. [Концепция и Core Loop](#2-core-loop)
3. [Архитектура Godot 4.x](#3-архитектура)
4. [Системы игры](#4-системы)
5. [Схемы данных JSON](#5-данные)
6. [Расширенная файловая структура](#6-файлы)
7. [Android-специфика](#7-android)
8. [Backend (отложено до v1.1)](#8-backend)
9. [Фазы разработки](#9-фазы)
10. [Что кодировать первым (Prototype Sprint)](#10-первые-шаги)

---

## 1. АУДИТ ИСХОДНОГО ДОКУМЕНТА

### ✅ Оставляем как есть
| Решение | Причина |
|---|---|
| Godot 4.x + GDScript | Правильный выбор. Лучший 2D-движок для мобильного MVP |
| JSON для контента | Контент отделён от кода — масштабируется на 50+ кейсов |
| Zone-Based UI | Убирает боль с хитбоксами, ускоряет разработку в 3x |
| Git/GitHub | Стандарт, без вариантов |

### ⚠️ Изменить / Уточнить
| Что | Проблема | Решение |
|---|---|---|
| SQLite для сохранений | Godot 4 имеет нативный `ConfigFile` и `FileAccess`. SQLite — overkill для MVP, требует плагин | Использовать `ConfigFile` (.cfg) для прогресса, JSON для инвентаря. SQLite — только если появятся сотни записей |
| FastAPI Backend | Для MVP — это лишний стек. Не трогать пока не появится реальная проблема читерства | Убрать из MVP полностью. Вернуться в v1.1 |
| PostgreSQL | То же — не нужен без Backend | Убрать из MVP |
| "Пререндер или ИИ-генерация фонов" | Слишком размыто. Нужно решить заранее | Midjourney → PNG-фон → Godot TextureRect. Зафиксировать разрешение: **1080×2340** (стандарт Android) |

### ❌ Критические пробелы (не было в документе)
- Нет описания **Core Loop** — что делает игрок каждые 30 секунд?
- Нет **State Machine** — как игра переходит между экранами?
- Нет архитектуры **таймера реального времени** (самая сложная часть!)
- Нет **системы аудио**
- Нет **визуального фидбека** (без него игра ощущается мёртвой)
- Нет **схем данных** (что конкретно лежит в items.json?)
- Нет **плана фаз** — разработка без фаз = хаос

---

## 2. КОНЦЕПЦИЯ И CORE LOOP

### Elevator Pitch
> Алхимия выживания. У тебя есть реальные 3 часа, чтобы не умереть. Каждый кейс — конкретная задача (сбежать, выжить, спасти). Каждая секунда настоящая.

### Core Gameplay Loop (30 секунд)

```
[Открыть кейс]
      ↓
[Прочитать задачу + таймер]
      ↓
[Осмотреть активные зоны на экране]
      ↓
[Перетащить предмет из инвентаря на зону / на другой предмет]
      ↓
[Получить результат: новый предмет / изменение зоны / провал]
      ↓
[Повторять пока не выполнено условие победы или не истёк таймер]
      ↓
[Victory Screen / Fail Screen → следующий кейс или retry]
```

### Эмоциональная дуга кейса
```
Интрига (читаю задачу) → Паника (вижу таймер) → Открытие (нашёл рецепт) → Облегчение / Триумф
```

### Типы кейсов (примеры)
| ID | Название | Суть | Таймер |
|---|---|---|---|
| C001 | Пещера вампира | Выбраться до рассвета, используя окружение | 8 мин |
| C002 | Зимний лес | Не замёрзнуть, разжечь костёр из подручного | 12 мин |
| C003 | Затонувший корабль | Открыть люк, пока не кончился воздух | 5 мин |
| C004 | Отравленный колодец | Создать антидот из трав вокруг | 15 мин |

### Условия победы (типы)
- `collect` — собрать конкретный предмет
- `place` — положить предмет в целевую зону
- `survive` — пережить таймер (ничего не делать нельзя)
- `escape` — открыть выход (серия взаимодействий)

---

## 3. АРХИТЕКТУРА GODOT 4.X

### Принцип: Singleton + Signal Bus

Вся глобальная логика — в **Autoload-синглтонах**. Сцены общаются только через **EventBus** (сигналы), не напрямую.

```
Autoloads (Project → Project Settings → Autoload):
├── GameManager.gd       ← главный контроллер состояний
├── TimeManager.gd       ← реальное время, таймеры кейсов
├── CraftingSystem.gd    ← логика крафта и рецептов
├── InventoryManager.gd  ← состояние инвентаря
├── SaveManager.gd       ← чтение/запись прогресса
├── AudioManager.gd      ← музыка и SFX
└── EventBus.gd          ← все сигналы игры (шина событий)
```

### State Machine (GameManager)

```
States:
  BOOT → MAIN_MENU → CASE_SELECT → LOADING → IN_CASE → PAUSED → VICTORY / FAIL → CASE_SELECT
                                                    ↑___________________________________|
```

```gdscript
# GameManager.gd
enum GameState {
    BOOT,
    MAIN_MENU,
    CASE_SELECT,
    LOADING,
    IN_CASE,
    PAUSED,
    VICTORY,
    FAIL
}

var current_state: GameState = GameState.BOOT

func change_state(new_state: GameState) -> void:
    current_state = new_state
    EventBus.game_state_changed.emit(new_state)
```

### EventBus.gd (полный список сигналов MVP)

```gdscript
# EventBus.gd — Autoload
extends Node

# Состояния
signal game_state_changed(new_state)

# Крафт
signal item_combined(item_a_id: String, item_b_id: String, result_id: String)
signal item_placed_on_zone(item_id: String, zone_id: String)
signal craft_failed(item_a_id: String, item_b_id: String)

# Инвентарь
signal item_added_to_inventory(item_id: String)
signal item_removed_from_inventory(item_id: String)

# Таймер
signal case_timer_tick(seconds_remaining: float)
signal case_timer_expired()

# Кейс
signal case_victory(case_id: String, time_taken: float)
signal case_fail(case_id: String, reason: String)

# UI
signal show_tooltip(text: String)
signal hide_tooltip()
```

---

## 4. СИСТЕМЫ ИГРЫ

### 4.1 Real-Time Timer System ⚠️ (Самое важное)

**Проблема:** Если хранить "осталось N секунд" — при закрытии приложения таймер остановится. Игрок закроет игру и вернётся через час — таймер не сдвинется.

**Решение:** Хранить не остаток, а **момент окончания** (Unix timestamp).

```gdscript
# TimeManager.gd
extends Node

var case_end_timestamp: int = 0  # Unix time когда кейс истекает

func start_case_timer(duration_seconds: int) -> void:
    # Записываем момент ОКОНЧАНИЯ, а не длительность
    case_end_timestamp = int(Time.get_unix_time_from_system()) + duration_seconds
    SaveManager.save_timer(case_end_timestamp)
    set_process(true)

func get_seconds_remaining() -> float:
    var now = Time.get_unix_time_from_system()
    return max(0.0, float(case_end_timestamp) - now)

func _process(_delta: float) -> void:
    var remaining = get_seconds_remaining()
    EventBus.case_timer_tick.emit(remaining)
    if remaining <= 0.0:
        set_process(false)
        EventBus.case_timer_expired.emit()

func resume_from_save() -> void:
    # Вызывается при запуске игры
    case_end_timestamp = SaveManager.load_timer()
    if case_end_timestamp > 0:
        if get_seconds_remaining() <= 0:
            EventBus.case_timer_expired.emit()  # Пока играл был мёртв
        else:
            set_process(true)
```

### 4.2 Crafting System

**Логика:** Рецепт — это пара предметов → результат. Порядок не важен (A+B = B+A).

```gdscript
# CraftingSystem.gd
extends Node

var recipes: Dictionary = {}  # загружается из recipes.json

func load_recipes() -> void:
    var file = FileAccess.open("res://data/recipes.json", FileAccess.READ)
    var data = JSON.parse_string(file.get_as_text())
    for recipe in data:
        # Ключ — отсортированная пара, чтобы A+B = B+A
        var key = _make_key(recipe["input_a"], recipe["input_b"])
        recipes[key] = recipe

func try_combine(item_a: String, item_b: String) -> Dictionary:
    var key = _make_key(item_a, item_b)
    if recipes.has(key):
        var recipe = recipes[key]
        EventBus.item_combined.emit(item_a, item_b, recipe["output"])
        return recipe
    else:
        EventBus.craft_failed.emit(item_a, item_b)
        return {}

func try_place_on_zone(item_id: String, zone_id: String) -> Dictionary:
    var key = "ZONE:" + zone_id + "+" + item_id
    if recipes.has(key):
        var recipe = recipes[key]
        EventBus.item_placed_on_zone.emit(item_id, zone_id)
        return recipe
    return {}

func _make_key(a: String, b: String) -> String:
    var arr = [a, b]
    arr.sort()
    return arr[0] + "+" + arr[1]
```

### 4.3 Inventory System

```gdscript
# InventoryManager.gd
extends Node

var slots: Array[String] = []  # item_id или ""
const MAX_SLOTS: int = 8

func add_item(item_id: String) -> bool:
    if slots.size() < MAX_SLOTS:
        slots.append(item_id)
        EventBus.item_added_to_inventory.emit(item_id)
        SaveManager.save_inventory(slots)
        return true
    return false  # инвентарь полон

func remove_item(item_id: String) -> void:
    slots.erase(item_id)
    EventBus.item_removed_from_inventory.emit(item_id)
    SaveManager.save_inventory(slots)

func has_item(item_id: String) -> bool:
    return item_id in slots
```

### 4.4 Zone Interaction System

Зоны — это `Area2D` или просто `Button`-подобные UI-элементы (рекомендую `TextureButton` в Godot).

```gdscript
# InteractiveZone.gd — прикрепляется к каждой зоне на сцене кейса
extends Panel

@export var zone_id: String = ""
@export var zone_label: String = "Зона"
@export var accepts_items: Array[String] = []  # какие предметы принимает (пусто = любые)

signal item_dropped_here(item_id: String, zone_ref)

func _can_drop_data(_pos: Vector2, data: Variant) -> bool:
    if accepts_items.is_empty():
        return true
    return data["item_id"] in accepts_items

func _drop_data(_pos: Vector2, data: Variant) -> void:
    item_dropped_here.emit(data["item_id"], self)
    CraftingSystem.try_place_on_zone(data["item_id"], zone_id)
```

### 4.5 Save System

```gdscript
# SaveManager.gd
extends Node

const SAVE_PATH = "user://save.cfg"
var config = ConfigFile.new()

func save_timer(timestamp: int) -> void:
    config.set_value("active_case", "end_timestamp", timestamp)
    config.save(SAVE_PATH)

func load_timer() -> int:
    config.load(SAVE_PATH)
    return config.get_value("active_case", "end_timestamp", 0)

func save_inventory(slots: Array) -> void:
    config.set_value("inventory", "slots", slots)
    config.save(SAVE_PATH)

func load_inventory() -> Array:
    config.load(SAVE_PATH)
    return config.get_value("inventory", "slots", [])

func save_case_progress(case_id: String, status: String) -> void:
    # status: "locked" / "available" / "completed"
    config.set_value("cases", case_id, status)
    config.save(SAVE_PATH)

func load_all_case_progress() -> Dictionary:
    config.load(SAVE_PATH)
    var result = {}
    for key in config.get_section_keys("cases"):
        result[key] = config.get_value("cases", key)
    return result
```

### 4.6 Audio System

```gdscript
# AudioManager.gd
extends Node

@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var sfx_player: AudioStreamPlayer = $SFXPlayer

var sfx_library: Dictionary = {}
var music_library: Dictionary = {}

func _ready() -> void:
    _load_audio()

func _load_audio() -> void:
    sfx_library = {
        "craft_success": preload("res://assets/audio/sfx/craft_success.ogg"),
        "craft_fail":    preload("res://assets/audio/sfx/craft_fail.ogg"),
        "item_pickup":   preload("res://assets/audio/sfx/item_pickup.ogg"),
        "timer_warning": preload("res://assets/audio/sfx/timer_warning.ogg"),
        "victory":       preload("res://assets/audio/sfx/victory.ogg"),
        "fail":          preload("res://assets/audio/sfx/fail.ogg"),
    }
    music_library = {
        "main_menu":  preload("res://assets/audio/music/main_menu_ambient.ogg"),
        "in_case":    preload("res://assets/audio/music/tension_loop.ogg"),
    }

func play_sfx(id: String) -> void:
    if sfx_library.has(id):
        sfx_player.stream = sfx_library[id]
        sfx_player.play()

func play_music(id: String, fade_in: float = 1.0) -> void:
    if music_library.has(id):
        music_player.stream = music_library[id]
        music_player.play()
        # Tween для fade-in
        var tween = create_tween()
        music_player.volume_db = -60.0
        tween.tween_property(music_player, "volume_db", 0.0, fade_in)
```

### 4.7 Visual Feedback System

Без визуального фидбека игра ощущается как мёртвая таблица. Обязательный минимум:

```gdscript
# FeedbackManager.gd (или часть UI-сцены)

# 1. SHAKE экрана при провале
func shake_screen(duration: float = 0.3, strength: float = 10.0) -> void:
    var tween = create_tween()
    var camera = get_tree().get_first_node_in_group("camera")
    var origin = camera.offset
    for i in range(int(duration * 30)):
        tween.tween_property(camera, "offset",
            origin + Vector2(randf_range(-strength, strength),
                             randf_range(-strength, strength)), 0.03)
    tween.tween_property(camera, "offset", origin, 0.05)

# 2. FLASH предмета при успешном крафте
func flash_item(item_node: Node2D) -> void:
    var tween = create_tween()
    tween.tween_property(item_node, "modulate", Color(2, 2, 2, 1), 0.1)
    tween.tween_property(item_node, "modulate", Color(1, 1, 1, 1), 0.2)

# 3. POPUP текст ("+Факел", "Рецепт неизвестен!")
func show_popup(text: String, position: Vector2, color: Color = Color.WHITE) -> void:
    var label = Label.new()
    label.text = text
    label.modulate = color
    label.position = position
    add_child(label)
    var tween = create_tween()
    tween.tween_property(label, "position:y", position.y - 60, 0.8)
    tween.parallel().tween_property(label, "modulate:a", 0.0, 0.8)
    tween.tween_callback(label.queue_free)
```

---

## 5. СХЕМЫ ДАННЫХ JSON

### `data/items.json`
```json
[
  {
    "id": "stick",
    "name": "Палка",
    "description": "Обычная деревянная палка. Основа многих вещей.",
    "icon": "res://assets/icons/stick.png",
    "tags": ["wood", "primitive", "tool_base"],
    "weight": 1,
    "stackable": true,
    "max_stack": 5
  },
  {
    "id": "torch",
    "name": "Факел",
    "description": "Горит 10 минут реального времени.",
    "icon": "res://assets/icons/torch.png",
    "tags": ["light", "fire", "consumable"],
    "weight": 2,
    "stackable": false,
    "max_stack": 1,
    "timed_effect": {
      "type": "light",
      "real_duration_seconds": 600
    }
  },
  {
    "id": "cloth",
    "name": "Тряпка",
    "description": "Кусок ткани. Перевяжет рану или пропитается смолой.",
    "icon": "res://assets/icons/cloth.png",
    "tags": ["fabric", "primitive"],
    "weight": 1,
    "stackable": true,
    "max_stack": 3
  }
]
```

### `data/recipes.json`
```json
[
  {
    "id": "R001",
    "type": "combine",
    "input_a": "stick",
    "input_b": "cloth",
    "output": "torch_unlit",
    "consumes": ["stick", "cloth"],
    "description": "Заготовка факела",
    "hint": "Надо что-то воспламеняющее...",
    "discovery_xp": 10
  },
  {
    "id": "R002",
    "type": "combine",
    "input_a": "torch_unlit",
    "input_b": "flint",
    "output": "torch",
    "consumes": ["torch_unlit", "flint"],
    "description": "Рабочий факел",
    "hint": null,
    "discovery_xp": 20
  },
  {
    "id": "R003",
    "type": "zone_interact",
    "input_a": "ZONE:skeleton",
    "input_b": "torch",
    "output": "bone_ash",
    "consumes": ["torch"],
    "zone_changes_to": "skeleton_burned",
    "description": "Сжечь скелет факелом",
    "hint": "Огонь очищает.",
    "discovery_xp": 30
  }
]
```

### `data/cases.json`
```json
[
  {
    "id": "C001",
    "title": "Пещера вампира",
    "subtitle": "Выберись до рассвета",
    "description": "Ты заперт в пещере. Вампир спит. У тебя есть время, но не много.",
    "background": "res://assets/backgrounds/vampire_cave.png",
    "ambience": "cave_drip",
    "music": "tension_dark",
    "timer_real_seconds": 480,
    "unlock_requires": null,
    "starting_inventory": ["stick", "cloth", "flint"],
    "zones": [
      {
        "id": "skeleton",
        "label": "Скелет у стены",
        "icon": "res://assets/icons/zone_skeleton.png",
        "initial_state": "intact",
        "states": {
          "intact": { "accepts": ["torch", "bone_saw"] },
          "skeleton_burned": { "accepts": [] }
        }
      },
      {
        "id": "cave_exit",
        "label": "Завал",
        "icon": "res://assets/icons/zone_rocks.png",
        "initial_state": "blocked",
        "states": {
          "blocked": { "accepts": ["bone_key", "explosion"] },
          "open": { "accepts": [] }
        }
      }
    ],
    "victory_condition": {
      "type": "place",
      "item": "bone_key",
      "zone": "cave_exit"
    },
    "fail_conditions": [
      { "type": "timer_expired", "message": "Рассвет не наступил для тебя." }
    ],
    "rewards": {
      "next_case": "C002",
      "unlock_item": "bone_ash"
    }
  }
]
```

### `user://save.cfg` (пример содержимого)
```ini
[active_case]
case_id="C001"
end_timestamp=1720000000

[inventory]
slots=["stick", "torch", "bone_ash"]

[cases]
C001="completed"
C002="available"
C003="locked"

[settings]
sfx_volume=0.8
music_volume=0.6
```

---

## 6. РАСШИРЕННАЯ ФАЙЛОВАЯ СТРУКТУРА

```
realchemy/
│
├── project.godot
├── .gitignore
├── README.md
│
├── assets/
│   ├── backgrounds/          ← PNG фоны кейсов (1080×2340)
│   │   ├── vampire_cave.png
│   │   └── winter_forest.png
│   ├── icons/                ← PNG иконки предметов (128×128, прозрачный фон)
│   │   ├── stick.png
│   │   ├── torch.png
│   │   └── ...
│   ├── ui/                   ← UI-элементы, рамки, кнопки
│   │   ├── panel_dark.png
│   │   ├── slot_empty.png
│   │   └── ...
│   ├── audio/
│   │   ├── music/            ← .ogg треки (loop)
│   │   └── sfx/              ← .ogg звуки действий
│   └── fonts/
│       ├── title_font.ttf    ← Заголовки (атмосферный шрифт)
│       └── body_font.ttf     ← Текст интерфейса (читаемый)
│
├── data/
│   ├── items.json
│   ├── recipes.json
│   └── cases.json
│
├── scripts/                  ← Autoload-синглтоны
│   ├── GameManager.gd
│   ├── TimeManager.gd
│   ├── CraftingSystem.gd
│   ├── InventoryManager.gd
│   ├── SaveManager.gd
│   ├── AudioManager.gd
│   └── EventBus.gd
│
├── scenes/
│   ├── autoloads/            ← Узлы синглтонов (если нужны Node-children)
│   ├── main_menu/
│   │   ├── MainMenu.tscn
│   │   └── MainMenu.gd
│   ├── case_select/
│   │   ├── CaseSelect.tscn
│   │   └── CaseSelect.gd
│   ├── case_ui/              ← Главный игровой экран
│   │   ├── CaseUI.tscn
│   │   ├── CaseUI.gd
│   │   ├── components/
│   │   │   ├── InventorySlot.tscn
│   │   │   ├── InteractiveZone.tscn
│   │   │   ├── TimerDisplay.tscn
│   │   │   └── DragPreview.tscn
│   ├── overlays/
│   │   ├── VictoryScreen.tscn
│   │   ├── FailScreen.tscn
│   │   ├── PauseMenu.tscn
│   │   └── CraftResultPopup.tscn
│   └── settings/
│       ├── Settings.tscn
│       └── Settings.gd
│
└── tests/                    ← GUT (Godot Unit Test) тесты
    ├── test_crafting.gd
    └── test_timer.gd
```

---

## 7. ANDROID-СПЕЦИФИКА

### Разрешение и масштабирование
```
# Project Settings → Display → Window:
Viewport Width:  1080
Viewport Height: 2340
Stretch Mode:    canvas_items
Stretch Aspect:  expand
```

### Touch Input
Godot 4 обрабатывает тач-ввод автоматически, но drag-and-drop нужно настроить:

```gdscript
# В InventorySlot.gd
func _get_drag_data(_pos: Vector2) -> Variant:
    var preview = preload("res://scenes/case_ui/components/DragPreview.tscn").instantiate()
    preview.set_item(item_id)
    set_drag_preview(preview)
    return { "item_id": item_id, "source_slot": self }
```

### Android Export Checklist
- [ ] Установить Android Export Template в Godot
- [ ] Настроить keystore (хранить в `.gitignore`!)
- [ ] Минимальный SDK: **Android 8.0 (API 26)**
- [ ] `AndroidManifest.xml` → `uses-permission VIBRATE` (для тактильного фидбека)
- [ ] Иконка приложения: 512×512 PNG
- [ ] Отключить `Export with Debug` для релиза

### Рекомендуемые плагины Godot (Asset Library)
| Плагин | Зачем |
|---|---|
| **GUT** (Godot Unit Testing) | Тесты крафт-логики без запуска игры |
| **Phantom Camera** | Плавные переходы камеры + shake |

---

## 8. BACKEND (ОТЛОЖЕНО ДО v1.1)

**Не трогаем до MVP.** Возвращаемся когда:
- [ ] 100+ активных пользователей
- [ ] Появились первые жалобы на читерство (подмена времени)
- [ ] Нужны облачные сохранения

**Тогда:**
- FastAPI (Python) + Uvicorn → верификация timestamp
- PostgreSQL → лидерборды, облачный прогресс
- Хостинг: **Railway.app** или **Fly.io** (бесплатный tier для старта)

---

## 9. ФАЗЫ РАЗРАБОТКИ

### Phase 0: Prototype (2–3 недели)
**Цель:** Подтвердить что механика работает и интересна.

Deliverables:
- [ ] 1 кейс (C001 "Пещера вампира"), захардкоженный
- [ ] Drag & drop инвентарь (4 слота)
- [ ] 2 зоны на экране
- [ ] 3 рецепта работают
- [ ] Таймер с реальным временем (без сохранений)
- [ ] Victory / Fail экраны (без анимаций)

**Успех Phase 0:** Ты сам прошёл кейс и почувствовал напряжение от таймера.

---

### Phase 1: MVP (4–6 недель)
**Цель:** Первая версия на Android, 5 кейсов.

Deliverables:
- [ ] 5 кейсов с разными механиками
- [ ] JSON-данные полностью отделены от кода
- [ ] Система сохранений (ConfigFile)
- [ ] Реальный таймер с persist при закрытии приложения
- [ ] 8-слотовый инвентарь с полным drag & drop
- [ ] AudioManager + 5 SFX + 2 музыкальных трека
- [ ] Visual feedback (popup, flash, shake)
- [ ] Экран выбора кейсов с locked/available/completed
- [ ] Экран настроек (громкость)
- [ ] APK для тестирования

**Успех Phase 1:** 5 человек из твоего окружения прошли 2+ кейса без объяснений.

---

### Phase 2: Content & Polish (6–8 недель)
**Цель:** 20 кейсов, магазин намёков, визуальный стиль.

Deliverables:
- [ ] 20 кейсов
- [ ] Система намёков (кнопка "Намёк" — смотреть рекламу или платить)
- [ ] Анимации переходов между сценами
- [ ] Система достижений (локальная)
- [ ] Туториал (первый кейс ведёт за руку)
- [ ] Онбординг (объяснение механики drag & drop)
- [ ] Полный визуальный стиль (шрифты, палитра, иконки)
- [ ] Google Play Store listing

---

### Phase 3: Launch (4 недели)
**Цель:** 50 кейсов, релиз, монетизация.

Deliverables:
- [ ] 50 кейсов
- [ ] Лидерборды (по скорости прохождения кейса)
- [ ] Backend v1 (FastAPI + PostgreSQL)
- [ ] Облачные сохранения
- [ ] IAP (покупка пакетов кейсов или косметики)
- [ ] PC/Steam порт

---

## 10. ЧТО КОДИРОВАТЬ ПЕРВЫМ (Prototype Sprint)

### Порядок разработки Phase 0

**День 1–2: Скелет проекта**
1. Создать проект Godot 4, настроить разрешение (1080×2340)
2. Добавить Autoloads: EventBus, GameManager (пустые)
3. Создать главную сцену `Main.tscn` → загружает `CaseUI.tscn`

**День 3–5: Инвентарь + Drag & Drop**
1. `InventorySlot.tscn` с иконкой предмета
2. `DragPreview.tscn` — что тащим
3. `InventoryManager.gd` с hardcoded стартовыми предметами: ["stick", "cloth", "flint"]

**День 6–8: Крафт**
1. `CraftingSystem.gd` с hardcoded рецептами (3 штуки)
2. `InteractiveZone.tscn` — 2 зоны на экране C001
3. Соединить: бросить предмет на зону → вызвать CraftingSystem

**День 9–10: Таймер**
1. `TimeManager.gd` с Unix-timestamp логикой
2. `TimerDisplay.tscn` — UI отображение (формат MM:SS)
3. Тест: закрыть и открыть приложение → таймер продолжил отсчёт ✓

**День 11–12: Victory / Fail**
1. `VictoryScreen.tscn` и `FailScreen.tscn`
2. Подписаться на `EventBus.case_victory` и `EventBus.case_timer_expired`
3. Кнопка "Играть снова"

**День 13–14: Первый полный прогон**
1. Пройти C001 от начала до конца
2. Записать что мешает, что непонятно
3. Исправить критическое

---

## 📎 ТЕХНИЧЕСКИЙ СТЕК — ФИНАЛЬНАЯ ТАБЛИЦА

| Компонент | Технология | Версия | Статус |
|---|---|---|---|
| Game Engine | Godot | 4.3+ | MVP |
| Язык | GDScript | — | MVP |
| Данные контента | JSON | — | MVP |
| Сохранения | ConfigFile (.cfg) | — | MVP |
| Аудио | Godot AudioStreamPlayer | — | MVP |
| Тесты | GUT Plugin | — | MVP |
| VCS | Git + GitHub | — | MVP |
| CI/CD | GitHub Actions (export APK) | — | Phase 1 |
| Backend | FastAPI + Uvicorn (Python) | — | Phase 3 |
| DB Backend | PostgreSQL | — | Phase 3 |
| Хостинг | Railway.app / Fly.io | — | Phase 3 |

---

*Документ живёт в репозитории: `/docs/TDD_v01.md`*
*Обновляется при каждом завершении фазы.*
*Версия: 0.1 | Дата: 2026*
