# Realchemy — Project Constitution

## 🔴 ПЕРВОЕ ДЕЙСТВИЕ КАЖДОЙ СЕССИИ
Прочитай `PROGRESS.md` прежде чем делать что-либо.
Если файл не существует — создай его по шаблону из `TASKS_PHASE0.md`.

---

## Проект
2D mobile survival-крафт игра на Godot 4.x.
Полная архитектура: `docs/TDD_v01.md` — читай перед любой задачей по системе.

## Стек (строго)
- **Engine:** Godot 4.3+
- **Язык:** только GDScript. Никогда C#.
- **Данные:** JSON в `data/`. Никогда хардкод контента в .gd файлах.
- **Сохранения:** ConfigFile (.cfg). Никогда SQLite.

## Файловая структура (обязательна)
```
realchemy/
├── CLAUDE.md
├── PROGRESS.md          ← пишешь сам, обновляй после каждой задачи
├── docs/TDD_v01.md
├── data/                ← items.json, recipes.json, cases.json
├── scripts/             ← только Autoload-синглтоны
├── scenes/
│   ├── case_ui/
│   │   └── components/
│   └── overlays/
└── assets/
```

## Архитектурные правила
1. Сцены общаются ТОЛЬКО через `EventBus.gd` сигналы. Никогда напрямую.
2. Вся глобальная логика — в Autoload синглтонах из `scripts/`.
3. Рецепты — всегда из `data/recipes.json`. Никогда хардкодить в GDScript.
4. Таймер — хранить Unix timestamp окончания, не остаток секунд.

## GDScript стиль
```gdscript
# Переменные — snake_case
var item_id: String = ""
var slots: Array[String] = []

# Константы — UPPER_SNAKE_CASE
const MAX_SLOTS: int = 8

# Функции — snake_case, всегда типизировать возврат
func add_item(item_id: String) -> bool:
    pass

# Сигналы — snake_case, прошлое время
signal item_added(item_id: String)
```

## Правила работы
- После каждой выполненной задачи — обновляй `PROGRESS.md`
- Если задача заблокирована — запиши причину в `PROGRESS.md`, переходи к следующей
- Не трогай `.tscn` файлы сцен — только `.gd` скрипты и `data/*.json`
- Перед коммитом убедись что синтаксис GDScript валиден (нет tab/space смешивания)
- Не создавай файлы вне описанной структуры без явного указания

## Команды проекта
```bash
# Проверка синтаксиса GDScript (если Godot в PATH)
godot --headless --check-only scripts/CraftingSystem.gd

# Запуск тестов GUT (если установлен)
godot --headless -s addons/gut/gut_cmdln.gd -gdir=res://tests/
```
