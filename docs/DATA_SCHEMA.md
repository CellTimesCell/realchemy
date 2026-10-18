# Схемы данных (v1.0)

Все игровые данные — JSON в `game/data/`. Скрипт `tools/validate_data.py` проверяет ссылки (каждый ID в реакции существует, у каждой реакции есть `science_note`).

## substances.json
```json
{
  "limestone": {
    "name": {"en": "Limestone", "ru": "Известняк"},
    "formula": "CaCO3",
    "phase": "solid",
    "tags": ["mineral", "alkaline_source"],
    "icon": "res://assets/sprites/items/limestone.png",
    "codex": {"en": "...", "ru": "Осадочная порода из раковин древних морских организмов."}
  }
}
```
| Поле | Тип | Обяз. | Примечание |
|---|---|---|---|
| `name` | {lang: str} | да | локализация |
| `formula` | str | нет | для смесей/предметов можно `null` |
| `phase` | enum | да | `solid`, `powder`, `liquid`, `gas`, `paste`, `object` |
| `tags` | [str] | да | список в `tags.json` |
| `is_zone` | bool | нет | огонь, море, солнце — не берутся в инвентарь |
| `is_tool` | bool | нет | не расходуется при реакции (нож, камень) |

## reactions.json
```json
{
  "calcination": {
    "inputs": ["limestone"],
    "zone": "fire",
    "conditions": {"temperature": "burning"},
    "outputs": ["quicklime", "co2_smoke"],
    "duration": {"real_note": "несколько часов в печи", "game_seconds": 600},
    "consumes": ["limestone"],
    "fx": "fire",
    "science_note": {"ru": "При сильном нагреве известняк распадается на оксид кальция и углекислый газ."},
    "verified": true
  }
}
```
| Поле | Примечание |
|---|---|
| `inputs` | ID веществ или `"tag:flammable"` для реакций по тегу |
| `zone` | ID зоны или `null` |
| `duration.game_seconds` | `0` = мгновенно; `> 60` = уходит в реальный таймер |
| `consumes` | что исчезает (инструменты не исчезают) |
| `fx` | тип эффекта: `fire`, `fizz`, `steam`, `spark`, `organic`, `electric`, `success` |
| `verified` | `false` — ждёт проверки человеком |

Приоритет поиска: точный рецепт → рецепт по тегам → «неудачная комбинация» с объяснением из `failures.json`.

## cases/<id>.json
```json
{
  "id": "shipwreck_shore",
  "title": {"ru": "Берег после кораблекрушения"},
  "story": {"ru": "..."},
  "background": "res://assets/backgrounds/shore.png",
  "start_items": ["flint", "steel_knife", "dry_grass", "driftwood", "clay", "seawater"],
  "item_pool": [],
  "zones": ["fire", "sea", "sun", "flat_stone"],
  "goals": [{"item": "fresh_water", "count": 1}, {"item": "signal_smoke", "count": 1}],
  "limit": {"type": "real_time", "seconds": 10800},
  "hints": [{"ru": "Пар можно поймать на холодной поверхности."}]
}
```
`limit.type`: `none` | `real_time` | `actions`.

## save (user://save.json)
```json
{
  "version": 1,
  "unlocked_cases": [],
  "codex": [],
  "active_case": {"id": "...", "started_at": 1792000000, "inventory": {}, "processes": [{"reaction": "calcination", "ends_at": 1792000600}]}
}
```
Все времена — Unix seconds (UTC).

## v1.1 — дополнения (18.10.2026)
**reactions.json** — новые поля:
| Поле | Пример | Зачем |
|---|---|---|
| `modes` | `["cozy","classic","real"]` | в каких уровнях сложности доступна реакция; Cozy-ярлыки помечаются `["cozy"]` |
| `flavor` | `"loc:rx_fried_meat_flavor"` | смешной текст результата (ключ локализации) |
| `science_note` | `"loc:rx_fried_meat_science"` | реальный факт, теперь тоже ключ локализации |
| `action` | `"grind"`, `"heat"`, `"mine"` | какую анимацию рук проигрывать в крупном плане |

**cases/<id>.json** — новые поля:
| Поле | Зачем |
|---|---|
| `map` | путь к сцене карты (TileMapLayer) |
| `hotspots` | точки интереса: `{id, pos, type: "pickup"/"craft"/"mine"/"inspect", payload}` |
| `deadline` | `{mode: "real", seconds}` — только для Real Chemist |

**save** — новое поле `difficulty`: `"cozy"` / `"classic"` / `"real"`.

Все строки для игрока — ключи локализации (`loc:...`), сами тексты в `game/data/i18n/*.csv` (EN первым).
