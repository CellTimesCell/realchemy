# PROGRESS — журнал сессий

Формат записи: дата · задача · что сделано · как проверено · проблемы · следующий шаг.

---

## 2026-10-17 · Документация v1.0
- Собраны README, CLAUDE.md, TASKS.md, docs/ (GAME_DESIGN, DATA_SCHEMA, TOOLING, ART_PIPELINE) на основе прошлых обсуждений (фев 2025 – окт 2026).
- Ключевое новое решение: химия опирается на реальную науку, длительность таймеров берётся из реальных процессов.
- Открытые вопросы — в README.
- Следующий шаг: T-01 (установка софта) и ответы на открытые вопросы.

## 2026-10-17 · Проверка версий
- Сверены версии всего стека, добавлена матрица совместимости в `docs/TOOLING.md` §0.
- Остаёмся на Godot 4.7.2 stable; 4.8 в beta 1 — переход после stable по правилу из §7.
- Обновления: godot-ai v3.0.7 (требует 4.7+), GUT 9.7.0, GodotSteam 4.22, codebase-memory 0.12.1, Aseprite 1.3.18, claude-in-mobile → mcp-devices 4.2.0.
- Google Play требует target API 36 с 31.08.2026. Node.js 20+ обязателен.

## 2026-10-17 · T-04 каркас проекта
- Создан `game/project.godot` (4.7, Compatibility, 480×270, canvas_items/expand/integer, Nearest, snap to pixel, landscape), структура папок, корневой `.gitignore`.
- Аддоны: GUT 9.7.1 → `game/addons/gut` (включён), godot-ai 3.2.1 → `game/addons/godot_ai` (включить после установки uv).
- Не проверено: открытие проекта в редакторе (нужен Godot 4.7.2).
- В корне лежат исходники Aseprite, а не программа — нужна готовая сборка.

## 2026-10-17 · T-04 проверено
- Проект открылся в Godot 4.7.2.stable без ошибок, панель GUT появилась (плагин работает). Создана папка game/.godot (кэш, в git не идёт).

## 2026-10-17 · T-01 установка софта (через tools/setup.ps1 + setup2.ps1)
- Установлено и проверено: Git 2.55.0, Node 24.20 / npm 11.19, Python 3.12.10 + Pillow 13.0, Temurin JDK 17.0.20 (JAVA_HOME), uv 0.13.1, ADB 37.0.1 (ANDROID_HOME), Claude Code 2.1.302 (C:\Users\fishm\.local\bin, добавлен в PATH), Aseprite (C:\Program Files\Aseprite).
- MCP подключены к Claude Code (user scope): codebase-memory-mcp 0.12.1 (из .local\bin) ✓, mobile (mcp-devices) ✓.
- Мусор: старая копия codebase-memory-mcp 0.9.0 в AppData\Local\Programs\codebase-memory-mcp — удалить вручную.
- Осталось: в Android SDK доставить платформу API 36, NDK, Command-line Tools, CMake; шаблоны экспорта Godot; включить плагин godot-ai.

## 2026-10-17 · T-06 индексация codebase-memory-mcp
- Проект проиндексирован (codebase-memory-mcp 0.12.1, проект `C-Realchemy`, mode full): 3838 узлов, 12038 рёбер.
- `.gd` попадают в граф: 218 файлов (`game/addons/godot_ai` — 132, `game/addons/gut` — 86), ~2900 функций. Собственных `.gd` проекта пока нет.
- Исключены как надо: `engine/`, `game/.godot`, исходники Aseprite, furnace, `_to_delete`.
- Частичный парсинг (best-effort) в 8 файлах, напр. `godot_ai/mcp_dock.gd`, `godot_ai/plugin.gd`, `gut/error_tracker.gd` — это код аддонов, на наш код не влияет.

## 2026-10-17 · T-03 архив
- Из истории GitHub-репозитория CellTimesCell/realchemy (коммит 2ce7cbb, 05.04.2026) восстановлены в docs/archive/: TDD v0.1, TASKS_PHASE0, CLAUDE.md, PROGRESS.md (с префиксом 2026-04_). GDD v2 (Unity) в репозитории не было.
- Удалённый репозиторий: https://github.com/CellTimesCell/realchemy (ветка main, сейчас пустое дерево, 5 коммитов истории).

## 2026-10-17 · Индекс без аддонов
- Добавлен `.cbmignore` (`game/addons/`) — штатный механизм исключений codebase-memory-mcp. После переиндексации: 105 узлов, файлов аддонов в графе 0.

## 2026-10-17 · T-02 репозиторий
- `git init` в C:\Realchemy, ветка `main`, remote `origin` = https://github.com/CellTimesCell/realchemy. Локальная ветка поставлена поверх `origin/main` (mixed reset), 5 старых коммитов сохранены, без force push.
- Добавлен `.gitattributes` (`* text=auto eol=lf`). `.gitignore` проверен `git check-ignore`: engine/, _to_delete/, furnace-*/, Aseprite-*/, game/.godot/ отсекаются.
- Коммит `fe1ffdc` «docs+scaffold: …»: 560 файлов (33 проекта, включая docs/archive, + 527 аддонов godot_ai/gut), ~5 МБ. Push `40ce7bb..fe1ffdc` — fast-forward, локальная и удалённая ветки совпадают.
- Git identity задан локально для репозитория (Alex, GitHub noreply из истории) — глобального не было.
- Следующий шаг: T-07 (GUT-тест из командной строки).

## 2026-10-17 · T-07 GUT из командной строки
- Тест-пустышка `game/tests/test_smoke.gd`: GUT жив + базовое разрешение проекта 480×270.
- Команда запуска записана в CLAUDE.md §4.1 (Godot console, `--headless`, `gut_cmdln.gd`, `-gdir=res://tests -ginclude_subdirs -gexit`). Пути с прямыми слэшами — работает и в PowerShell, и в Bash.
- Проверено: 2/2 passed, exit 0; с временным падающим тестом — exit 1 (файл удалён).
- Следующий шаг: T-08 👤 (Android-экспорт) или T-09 (`tools/validate_data.py`).

## 2026-10-17 · T-05 связь с редактором через godot-ai
- Плагин godot-ai включён в редакторе (`project.godot`: plugin.cfg + служебный autoload `_mcp_game_helper`). В Claude Code сервер `godot-ai` зарегистрирован (user scope), статус Connected.
- Проверено (MCP по HTTP 127.0.0.1:8000, т.к. сессия Claude стартовала до настройки): `editor_state` → Godot 4.7.2-stable (official), проект «Realchemy»; `scene_get_hierarchy` → «No scene open», 0 узлов (сцен в проекте ещё нет — ожидаемо). Доступно 49 инструментов.
- Версии: аддон 3.2.1 = сервер 3.2.1 (uv-пакет). «3.4.9» в serverInfo — это версия библиотеки FastMCP, а не godot-ai (сервер не передаёт свою версию). Расхождения нет.

## 2026-10-17 · godot-ai: версии и `_mcp_game_helper`
- Прочитаны release notes 3.2.2–4.3.0. 4.x — ломающий релиз (только `godot-ai attach` по stdio с аутентификацией, голый HTTP не работает; миграция только с 3.2.5; требуется Godot 4.7+ — 4.7.2 подходит). Открыты Windows-баги #1105, #1107. Обновление отложено до решения Александра.
- `_mcp_game_helper` вырезается из экспорта самим плагином (`export/mcp_export_plugin.gd`, регистрируется и в headless). Решение записано в CLAUDE.md §3; проверить на первой сборке в T-08.

## 2026-10-17 · godot-ai 3.2.1 → 3.2.5
- Аддон заменён целиком (старая папка удалена, распаковано из `godot-ai-plugin.zip` релиза v3.2.5, SHA-256 сверен). `~/.claude.json`: сервер закреплён на `godot-ai==3.2.5`. `docs/TOOLING.md`: версии + запрет кнопки Update (ведёт на 4.x; 4.x — после закрытия #1105 и #1107). GUT 2/2 зелёные. Коммит `a854af9`, запушен (`b13a022..a854af9`).
- **Связь с редактором НЕ проверена.** `session_manage(list)` → 0 сессий, `editor_state` → `PLUGIN_DISCONNECTED`: редактор Godot не запущен.
- Работают процессы, оставшиеся от старой версии, оба **3.2.1**: HTTP-сервер на 127.0.0.1:8000/9500 (`uvx --from godot-ai==3.2.1 ... --pid-file .../godot_ai_server.pid`, запустил ещё старый редактор в 17:25 и он пережил закрытие) и `godot-ai attach` текущей сессии Claude (запущен до правки конфига). Сначала их нужно остановить, потом открыть Godot и перезапустить Claude, и проверить заново: `session_manage(list)` → plugin_version и server_version = 3.2.5.
- Старый сервер 3.2.1 остановлен (дерево uv 14640 → godot-ai.exe 12056 → python 18796). На 8000/9500 никто не слушает (LISTENING — 0). В `godot_ai_server.pid` остался PID уже несуществующего процесса 18796. `attach` текущей сессии Claude (uv 8024 / godot-ai.exe 16624, 3.2.1) не трогали — он завершится при перезапуске Claude.
- Следующий шаг: открыть Godot → перезапустить Claude → `session_manage(list)`, проверить plugin_version = server_version = 3.2.5.
- Повторная проверка (22:04): `session_manage(list)` → 0 сессий, версии 3.2.5 **не подтверждены**. Godot не запущен, Claude не перезапускался. `attach` 3.2.1 этой сессии (PID 15248) после остановки старого сервера сам поднял новый HTTP-сервер **3.2.1** на 8000/9500 (pythonw 5612 → 7740, `-m godot_ai --transport streamable-http`, в 22:01). Пока жива сессия Claude со старым `attach`, порт будет снова занимать 3.2.1.
- Правильный порядок: закрыть Claude Code (старый `attach` и сервер, который он поднял, должны завершиться; если 7740 остался — остановить) → открыть Godot (плагин 3.2.5 поднимет сервер 3.2.5) → запустить `claude` (`attach` 3.2.5 по новому пину) → `session_manage(list)`.
- Проверка 2026-10-18 (00:2x): версии 3.2.5 **снова не подтверждены**. Claude перезапущен — `attach` теперь **3.2.5** (uvx 22172 → godot-ai.exe 15064, `--from godot-ai==3.2.5`), старых процессов 3.2.1 нет. Но Godot не запущен, на 8000/9500 никто не слушает → MCP `godot-ai` в сессии Claude не поднялся (CONNECT_TIMEOUT 30 с), `session_manage(list)` вызвать нельзя.
- Следующий шаг: открыть редактор Godot (проект `game/`), дождаться, пока плагин поднимет сервер на 8000/9500, затем перезапустить Claude (или `/mcp` → reconnect godot-ai) и вызвать `session_manage(list)`.
- **Подтверждено 2026-10-18:** `session_manage(op="list")` → 1 сессия `game@304b` (Godot 4.7.2-stable, `C:/Realchemy/game/`, editor_pid 7756, `server_launch_mode: uvx`, is_active): **plugin_version = 3.2.5, server_version = 3.2.5**. Сервер — pythonw 11692 на 127.0.0.1:8000/9500. Вызов шёл напрямую по MCP HTTP: в сессии Claude `godot-ai` остался в CONNECT_TIMEOUT (Claude стартовал раньше редактора) — для работы через инструменты нужен `/mcp` → reconnect.

## 2026-10-18 · Решения по дизайну (GAME_DESIGN v1.1)
- Ответы Александра на открытые вопросы внесены: горизонталь, юмор + наука под капотом (`flavor`/`science_note`), два слоя (карта сверху + крупный план: верстак/добыча/осмотр), 3 уровня сложности на одном графе (`modes`), реальное время только помогает (провал — только Real Chemist), EN → ES, PixelLab Tier 1 с фазы 1.
- Первый кейс — «Замок близорукого графа» (Дракула), «Берег» — второй.
- Обновлены: docs/GAME_DESIGN.md (v1.1), README.md (решения), docs/ART_PIPELINE.md (размеры двух слоёв), docs/DATA_SCHEMA.md (v1.1 поля), TASKS.md (фаза 0 и 1 перестроены, T-11…T-30).

## 2026-10-18 · Управление и арт-план
- Управление на телефоне: игрок выбирает тап-чтобы-идти или виртуальный джойстик (GAME_DESIGN §3.1, T-20).
- PixelLab: план — Tier 2 «Pixel Artisan» (512×512, 5000/мес) с фазы 1, генерация через API/MCP. Открыт вопрос: входит ли API в лимит подписки.

## 2026-10-18 · PixelLab: тариф
- Ответы поддержки PixelLab: MCP/API/сайт/Aseprite — общий лимит; create_character (4 напр.) = 1, animate_character = 1/направление, topdown_tileset = 1–4; create_image_pixen на Tier 1 — до 512×512 по площади.
- Оценка кейса: ~100–110 генераций начисто, ~300–450 с переделками (ART_PIPELINE §3.2). Решение: **Tier 1 «Pixel Apprentice»** с фазы 1.

## 2026-10-18 · PixelLab Tier 1 куплен
- Александр оформил подписку PixelLab Tier 1 «Pixel Apprentice» (2000 генераций/мес, общий лимит для сайта, Aseprite и MCP).
- MCP подключать в **user scope** (токен не должен попасть в репозиторий через `.mcp.json`).
- Следующее: проба стиля Дракулы (T-25) — можно начать раньше фазы 1, бюджет пробы ≤ 25 генераций.

## 2026-10-18 · T-09 `tools/validate_data.py`
- Только stdlib (jsonschema не установлен). Запуск: `python tools/validate_data.py [--data game/data]`, exit 0 — нет ошибок (предупреждения допустимы), 1 — есть ошибки.
- Проверяет: substances (name, phase, tags по `tags.json`, is_zone/is_tool), reactions (ссылки inputs/outputs/consumes, `tag:` по `tags.json`, consumes ⊆ inputs, инструменты не расходуются, zone = вещество с `is_zone`, `game_seconds` ≥ 0, `fx`, `modes`, **обязательные `science_note` и `flavor`**, `verified:false` → предупреждение со списком), cases (id = имя файла, title/story, start_items/item_pool/zones/goals, `limit.type`, `deadline` только `real`, уникальность и тип hotspots, hints).
- Тексты принимаются в обоих форматах: `"loc:key"` (v1.1) и `{lang: text}` (v1.0). Ключи `loc:` сверяются с `i18n/en.csv`, если он есть (появится в T-15). Нет `tags.json` → теги не проверяются (предупреждение).
- Тесты: `python -m unittest discover -s tools/tests` — 14 тестов validate_data, OK. На реальной `game/data` сейчас exit 1: нет substances.json/reactions.json — ожидаемо до T-16.

## 2026-10-18 · T-10 `tools/pixelize.py`
- Pillow 13 (уже стоит). `python tools/pixelize.py SRC --size 32x32 [--keep-bg] [--palette FILE] [--out DIR]`: ключ-цвет #FF00FF → прозрачность (допуск 60) → центр-кроп под пропорции → Nearest → альфа 0/255 → палитра без дизеринга → `game/assets/_incoming/<имя>.png`. Предупреждает, если в спрайте > 16 цветов.
- Палитра: `.png` или `.gpl`; по умолчанию `game/assets/palette.png` — её пока нет (T-26), шаг пропускается с предупреждением.
- Тесты: 10 тестов pixelize, всего 24/24 OK. Сквозной прогон: 1024×1024 на пурпурном → 32×32 с прозрачным фоном; 1920×1080 → 480×270 (`--keep-bg`).
- Ограничение: Nearest берёт один пиксель из блока — на «шумной» ИИ-картинке может выхватить случайный цвет. Если будет мешать — добавить режим «мода блока» или прогонять через `fix_pixel_art` (Retro Diffusion).
