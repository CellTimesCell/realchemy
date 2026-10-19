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

### Языки (решение 19.10.2026)
- **en** — основной и пока единственный язык игры.
- **es** (ES-419) — позже, отдельной колонкой в том же CSV.
- **ru** — нет. Русские строки в игровых данных не хранить; поля вида `{"ru": ...}` в примерах выше устарели — вместо них ключ `loc:...`.
- Формат CSV: первая колонка `keys`, затем `en` (`game/data/i18n/strings.csv`). Ключи: `UI_*` — интерфейс и хотспоты, `HS_*` — особые подписи хотспотов, `SAY_*` — реплики героя, `LETTER_*` — письма и записки.

## v1.2 — персонажи и предметы сцены (19.10.2026)

### data/character_reactions.json
```json
{
  "reactions": { "<character>": { "<reaction>": {"anim": "react_cheer", "emote": "sparkle"} } },
  "events":    { "<character>": { "<EventBus signal>": "<reaction>" } }
}
```
- `anim` — имя анимации в SpriteFrames персонажа (пусто — только значок); `emote` — имя значка из `data/emotes.json`.
- Событие — имя сигнала `EventBus`; аргументы сигнала игнорируются.

### data/emotes.json
```json
{
  "icons": {
    "<icon>": {
      "flip": true,
      "shade": false,
      "places": [ {"anchor": "temple_face", "offset": [6, -2], "scale": 1.0, "frame_shift": 0} ]
    }
  },
  "characters": {
    "<character>": { "face_side": "right", "anim_head_offset": {"<anim>": [0, 18]} }
  }
}
```
- `anchor`: `head_top` | `forehead` | `temple_face` | `temple_back` (лицо — сторона, куда смотрит персонаж; маркеры `Temple_L/R` — по неотражённому спрайту).
- `offset` — центр значка от точки, px; `x` положительный = к лицу (зеркалится при flip).
- `scale` — 1 (пиксель-арт), не меньше 0,5. `flip` — отражать сам значок, когда персонаж смотрит влево. `shade` — ступенчатая тень на верх лица (gloom). Несколько `places` — несколько копий (sparkle), `frame_shift` сдвигает кадр копии.
- `face_side` — куда смотрит неотражённый спрайт; `anim_head_offset` — смещение головы в анимации (присед).

### data/interactables.json (`components/interactable.gd`)
```json
{
  "<id>": {
    "pose": "interact_mid",
    "anim": "states",
    "closable": false,
    "sfx": {"start": "creak", "end": "open", "close": "close", "locked": "locked"},
    "fx": "dust", "fx_once": true,
    "item": {"id": "orange", "count": 3, "color": "#f08a20", "letter": "o"},
    "line_key": "SAY_ORANGE_TAKEN", "empty_line_key": "SAY_ORANGE_EMPTY",
    "locked": false, "locked_line_key": "",
    "prompt_after": "", "prompt_after_empty": "UI_INSPECT"
  }
}
```
- `pose` — поза героя: `interact_low` | `interact_mid` | `interact_high` | пусто.
- `anim` — анимация предмета: `none` | `states` (текстуры закрыт → приоткрыт → открыт из сцены) | `slide` (выезжает `moving_part`, тело меняет текстуру на «пустой проём»).
- `sfx` — имена звуков `AudioManager` (open, close, locked, pickup, creak, chirp).
- `fx` — `dust` | пусто; `fx_once` — только при первом открытии.
- `item` — найденный предмет: `id` уходит в `EventBus.item_found`, `count` — сколько раз можно взять, `color`/`letter` — плейсхолдер вылетающего значка.
- `line_key` / `empty_line_key` / `locked_line_key` — ключи строк (en, `data/i18n/strings.csv`).
- `prompt_after` — подсказка после открытия; `prompt_after_empty` — когда предметы кончились.
- Узлы (спрайт, текстуры состояний, выдвижная часть, точка эффекта, содержимое) задаются в сцене экспортами компонента.
