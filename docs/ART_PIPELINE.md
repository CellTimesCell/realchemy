# Арт-пайплайн и промпты (v1.0)

## 1. Стиль — «16 бит, как на Sega»
Ориентир: эпоха Sega Genesis / Mega Drive и поздних 16-битных квестов — насыщенные, но ограниченные цвета, чёткие тёмные контуры, ручной дизеринг, детальные фоны и «сочные» предметы.

Мы **вдохновляемся** железом, но не эмулируем его ограничения буквально:

| Параметр | Настоящая Genesis | Realchemy |
|---|---|---|
| Разрешение | 320×224 | **480×270** (ровно ×4 до 1920×1080, ×2 до 960×540) |
| Цвета | 512 возможных, ~61 на экране | **Общая палитра проекта 48 цветов**, до 16 на один спрайт |
| Контур | обычно тёмный цветной | тёмный цветной (не чистый чёрный), 1 px |
| Свет | — | всегда сверху-слева |

Палитра фиксируется файлом `game/assets/palette.png` (+ `.gpl` для Aseprite). Всё, что попадает в игру, сводится к ней скриптом.

## 2. Размеры ассетов
| Тип | Размер (px) | Примечание |
|---|---|---|
| Иконка предмета/вещества | 32×32 | в инвентаре, крупно 2× в энциклопедии |
| Зона (огонь, море, наковальня) | 64×64 или 96×64 | анимированные 4–8 кадров |
| Фон кейса | 480×270 | 2–3 слоя для параллакса |
| Персонаж (если будет) | 32×48 | idle 4 кадра |
| Иконки UI | 16×16 | |
| Эффекты (искры, пар, шипение) | делаются частицами Godot, не спрайтами | |

## 3. Конвейер генерации
```
1. Промпт (шаблоны ниже) → генерация
     • PixelLab — для предметов, персонажей, анимаций (настоящая сетка)
     • Общий генератор — для концептов и фонов
2. tools/pixelize.py  → удалить фон → уменьшить фильтром Nearest до целевого размера
                      → свести к палитре проекта → PNG в assets/_incoming/
3. Aseprite (руками или через MCP) → почистить шум, контур, лишние пиксели
4. Перенос в game/assets/... + запись в docs/ASSETS.md (источник, промпт, дата)
```
Правило: одна сессия — одна группа ассетов в одном стиле (например, все минералы). Первый удачный результат сохраняется как **эталон стиля** и подаётся референсом в следующие генерации.

## 4. Базовый стиль-блок (добавлять к каждому промпту)
```
16-bit pixel art, Sega Genesis era style, limited palette, crisp pixels,
1px dark colored outline, light from top-left, subtle dithering,
clean readable silhouette, no anti-aliasing, no blur
```
**Негатив** (если генератор поддерживает):
```
photorealistic, 3d render, smooth gradients, anti-aliasing, blurry,
text, watermark, signature, noisy pixels, inconsistent pixel size
```

## 5. Шаблоны промптов

### 5.1 Иконка предмета / вещества
```
[СТИЛЬ-БЛОК], game inventory icon of {предмет на английском},
{2–3 визуальных признака: материал, цвет, форма},
centered, single object, 3/4 view, plain flat {magenta #FF00FF} background,
fits in 32x32 pixel grid
```
Пример: `... game inventory icon of a chunk of limestone, pale grey-beige rock with tiny fossil shell imprints, rough edges, ...`

Для PixelLab короче: описание + параметры `size: 32`, `outline: single color black` или `selective`, `shading: medium`, `detail: medium`, `view: high top-down` / `side`.

### 5.2 Вещество в сосуде (жидкости, порошки)
```
[СТИЛЬ-БЛОК], game icon, small clay bowl containing {вещество},
{цвет и текстура: e.g. white crumbly powder / murky green liquid with bubbles},
centered, plain flat magenta background
```
Один сосуд для всех жидкостей/порошков → единообразие и экономия генераций.

### 5.3 Фон кейса
```
[СТИЛЬ-БЛОК], side-view adventure game background, 16:9, {место},
{время суток и погода}, {3–5 узнаваемых деталей окружения},
empty foreground area at the bottom for UI, atmospheric, rich color,
layered depth: distant / middle / near
```
Пример: `... a rocky tropical shore after a shipwreck, late afternoon, broken ship hull on the reef, driftwood and crates on the sand, palm trees, ...`

### 5.4 Зона взаимодействия
```
[СТИЛЬ-БЛОК], game interactable object, {campfire / tide pool / flat anvil stone},
front 3/4 view, plain magenta background, designed for 4-frame loop animation
```

### 5.5 Персонаж (если решим показывать героя)
```
[СТИЛЬ-БЛОК], game character sprite, {описание: пол, возраст, одежда, предмет в руках},
full body, standing idle pose, front 3/4 view, 32x48 pixel scale, plain magenta background
```
Анимацию делать в PixelLab (скелетные кадры) или руками в Aseprite, а не генерацией каждого кадра отдельно — иначе персонаж «плывёт».

### 5.6 Карточка энциклопедии / UI-рамка
```
[СТИЛЬ-БЛОК], game UI panel frame, aged parchment with brass alchemical corners,
9-slice friendly, empty center, plain magenta background
```

## 6. Шрифт
Пиксельный шрифт **с кириллицей и латиницей** (и испанскими символами, если будет ES). Проверять лицензию на коммерческое использование, хранить лицензию рядом со шрифтом.

## 7. Steam и ИИ-контент
При публикации в Steam нужно раскрыть использование ИИ-генерации в анкете. Вести `docs/ASSETS.md` с источником каждого ассета с первого дня — потом это сэкономит много времени.
