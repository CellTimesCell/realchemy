# Инструменты и окружение (проверено 17.10.2026)

Машина разработки: Lenovo LOQ 15 (Windows). Команды — для PowerShell.
Раздел 0 — сводка версий. Перед установкой всё равно сверяй с официальной страницей.

## 0. Матрица версий и совместимости

| Компонент | Версия | Дата | Совместимость / заметки |
|---|---|---|---|
| **Godot** | **4.7.2 stable** | 18.08.2026 | Рабочая версия проекта |
| Godot 4.8 | beta 1 | 15.10.2026 | Не брать до stable. Переход планируем после выхода (см. §7) |
| Export Templates | 4.7.2 | — | Должны **точно** совпадать с версией редактора. В 4.7 можно качать только нужные платформы |
| **JDK** | **17** (Eclipse Temurin) | — | Официальная документация Godot: OpenJDK 17. Новее (21) часто ломает Gradle |
| Android target SDK | **API 36** (Android 16) | обяз. с 31.08.2026 | Требование Google Play для новых приложений и обновлений |
| Android Studio | последняя stable | — | Нужна ради SDK, ADB и эмулятора |
| **Node.js** | **20 LTS или новее** | — | Нужен для mcp-devices (≥20) и godot-mcp (≥18) |
| Python | 3.12+ | — | Скрипты пайплайна (Pillow) |
| uv | последняя | — | Нужен для godot-ai |
| **godot-ai** (MCP-плагин) | **v3.2.5** (установлен) | 03.09.2026 | **Требует Godot 4.7+** — совпадает с нашей версией. 46 инструментов. Сервер закреплён: `godot-ai==3.2.5`. ⚠️ Кнопку **Update** в доке не нажимать — ведёт на 4.x (см. §4.1) |
| Coding-Solo/godot-mcp | npm latest | — | Node 18+, UID-функции требуют Godot 4.4+ |
| **codebase-memory-mcp** | **0.12.1** | 2026 | У тебя стоит 0.9.0 — обновить |
| **GUT** (тесты) | **9.7.1** (установлен) | — | Версия именно под Godot 4.7 |
| **GodotSteam** | **4.22** | 22.08.2026 | Сборка под Godot 4.7.2. Репозиторий на Codeberg |
| Google Play Billing (плагин) | master | — | Поддерживает Godot 4.2+ |
| **Aseprite** | **1.3.18** | 22.07.2026 | Для обоих Aseprite-MCP нужна 1.3+ |
| Furnace Tracker | 0.6.8.x | — | Музыка в стиле Sega Genesis |
| **mcp-devices** (бывш. claude-in-mobile) | **4.2.0** | 08.2026 | Проект переименован. Node 20+, ADB |

## 1. Обязательный софт

| # | Программа | Зачем |
|---|---|---|
| 1 | **Godot 4.7.2** (godotengine.org → Download → Archive → 4.7.2). Лежит в `C:\Realchemy\engine\` (в git не попадает) | Движок |
| 2 | **Export Templates 4.7.2** — Editor → Manage Export Templates (Android + Windows) | Сборки |
| 3 | **Git** (git-scm.com) + приватный репозиторий на GitHub | История, откат |
| 4 | **Claude Code** — обновить: `claude update` | Основной разработчик |
| 5 | **JDK 17** (adoptium.net, Temurin 17) + переменная `JAVA_HOME` | Android-экспорт |
| 6 | **Android Studio** → SDK Manager: Platform **API 36**, Build-Tools, Platform-Tools, Command-line Tools, NDK; Device Manager: эмулятор | Сборка и тест |
| 7 | **Node.js 20 LTS+** (nodejs.org) | MCP-серверы на npm |
| 8 | **Python 3.12+**, затем `pip install pillow` | Скрипты пайплайна |
| 9 | **Aseprite 1.3.18** (Steam или aseprite.org, платный). Бесплатная замена — LibreSprite (но MCP под неё не гарантированы) | Пиксель-арт |

Опционально: VS Code + `godot-tools`, ImageMagick.

## 2. Звук (16-бит)
| Программа | Зачем |
|---|---|
| **Furnace Tracker** (бесплатный) | Музыка с эмуляцией чипа Sega Genesis (YM2612) |
| **jsfxr / ChipTone** (в браузере) | Ретро-звуки: шипение, искры, «плоп», победа |
| **Audacity** | Обрезка, нормализация, экспорт `.ogg` |

## 3. Godot-аддоны
С версии 4.7 встроенный каталог называется **Asset Store** (раньше Asset Library), в нём есть рейтинги.

| Аддон | Версия | Фаза | Зачем |
|---|---|---|---|
| **GUT** | 9.7.1 | 0 | Тесты ChemistryEngine и таймеров — Claude проверяет себя сам |
| **godot-ai** | 3.2.5 | −1 | Связь Claude ↔ живой редактор |
| **GodotSteam GDExtension** | 4.22 | 3 | Steam: достижения, облачные сохранения |
| **Godot Google Play Billing** | master | 2 | Разовая покупка в Android |

## 4. MCP-серверы

Принцип экономии токенов: **постоянно подключены только 2** (godot-ai + codebase-memory). Остальные включать на время конкретной задачи.

### 4.1 Godot — основной: `hi-godot/godot-ai` (v3.2.5, Godot 4.7+)

> ⚠️ **Кнопку Update в доке Godot AI не нажимать** — она обновляет на ветку 4.x. Переход на 4.x — только после закрытия issues [#1105](https://github.com/hi-godot/godot-ai/issues/1105) и [#1107](https://github.com/hi-godot/godot-ai/issues/1107). До тех пор обновляемся вручную в пределах 3.x: Godot закрыт → удалить `game/addons/godot_ai` целиком → положить папку из `godot-ai-plugin.zip` нужного релиза (сверить `.sha256`) → в `~/.claude.json` поменять `godot-ai==X.Y.Z` в args сервера `godot-ai`.

Работает с **живым** редактором: 46 инструментов (сцены, узлы, скрипты, сигналы, UI, анимации, частицы).
```powershell
# 1. Установить uv
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
# 2. Скачать релиз с github.com/hi-godot/godot-ai/releases
#    распаковать в C:\Realchemy\game\addons\godot_ai\  (внутри должен быть plugin.cfg)
#    НЕ распаковывать новую версию поверх старой — сначала удалить старую папку
# 3. Godot: Project → Project Settings → Plugins → включить Godot AI
# 4. В доке Godot AI нажать "Configure" напротив Claude Code — он сам пропишет MCP
#    (по умолчанию в user scope; для настройки только этого проекта:
#     Editor Settings → Plugins → godot_ai/mcp_client_scope = project, затем Configure ещё раз)
# 5. В папке проекта запустить `claude` и один раз одобрить сервер
```
Ручной вариант, если кнопка не сработала:
```powershell
claude mcp add --scope user --transport http godot-ai http://127.0.0.1:8000/mcp
```

### 4.2 Godot — запасной/лёгкий: `Coding-Solo/godot-mcp`
Запуск проекта, отладочный вывод, создание сцен. Работает **без открытого редактора** — подходит для ночных прогонов.
```powershell
claude mcp add godot -e GODOT_PATH="C:\Realchemy\engine\Godot_v4.7.2-stable_win64_console.exe" -- cmd /c npx @coding-solo/godot-mcp
```
Одновременно держать включённым **только один** из 4.1/4.2.

### 4.3 Индексация кода: `DeusData/codebase-memory-mcp` (0.12.1)
Граф проекта (функции, вызовы, зависимости) — Claude ищет по графу вместо чтения файлов целиком.
```powershell
codebase-memory-mcp update          # 0.9.0 → 0.12.x
codebase-memory-mcp config set auto_index true
```
Заявлено 159 языков через tree-sitter, но **GDScript явно не подтверждён** — проверяем в T-06. Если `.gd` не попадут в граф — ведём `docs/CODEMAP.md` вручную.

### 4.4 Арт — PixelLab (официальный MCP, платный)
**План:** Tier 1 «Pixel Apprentice» (~$12/мес, 2000 генераций). Фоны 640×360 — через `create_image_pixen`: на Tier 1 до 512×512 **по площади** (262 144 px ≥ 230 400 px) — ответ поддержки 18.10.2026. Tier 2 (5000/мес) — только если упрёмся в лимит. Подписка — с фазы 1 (T-25). До этого — бесплатные 40 генераций на пробу стиля (MCP на пробе недоступен).
✅ Вызовы через API/MCP входят в лимит подписки (см. ниже).
Альтернатива/дополнение: **Retro Diffusion** — плагин для Aseprite, разовая покупка, генерирует локально на своей видеокарте без лимитов.
Настоящий пиксель-арт: предметы, персонажи в 4/8 направлениях, анимации, тайлсеты.
```powershell
claude mcp add --transport http pixellab https://api.pixellab.ai/mcp --header "Authorization: Bearer ВАШ_ТОКЕН"
```
- **MCP требует активную платную подписку** (на бесплатной пробе — только веб и расширение Aseprite). Готовый конфиг с подставленным токеном — на pixellab.ai/mcp (выбрать Claude Code). Это удалённый HTTP-сервер, ничего ставить не надо; для stdio-клиентов — мост `npx mcp-remote@latest`.
- Инструменты MCP: `create_character` (4/8 направлений), `animate_character` (walk/run/idle), `create_topdown_tileset` (Wang-тайлы с переходами, цепочки террейнов), `create_sidescroller_tileset`, `create_isometric_tile`, `create_map_object` (прозрачный фон, подгонка под стиль карты; **файлы удаляются через 8 ч — сразу сохранять**), `create_image_pixflux` (палитра картинкой) / `create_image_pixen` (крупные холсты) / `create_image_pro` (лучшее качество, несколько кандидатов), `edit_image`, `inpaint_image`, `animate_image`, `get_image` (результат по job id).
- Для нас ключевые: `create_topdown_tileset` → TileSet карты замка; `create_character` + `animate_character` → герой и граф; `create_image_pixflux` с палитрой проекта → иконки сразу в нашей палитре.
- API напрямую: api.pixellab.ai/v1/docs, Python SDK `pixellab-python` (PixFlux, BitForge, скелетная/текстовая анимация, inpaint, поворот) — для пакетных скриптов в `tools/`.
- **Оплата (ответ поддержки PixelLab, 18.10.2026):** MCP, API, сайт и расширение Aseprite тратят **один общий лимит** — сначала месячные генерации тарифа (Pixel Artisan: 5000), после — баланс кредитов. Стоимость в генерациях разная у разных инструментов (персонажи, анимации и тайлсеты дороже) → перед большими сериями проверять цену, следить за остатком, кредиты сверх лимита не докупать без согласия Александра.
Токен — pixellab.ai/account. Никогда не коммитить токен в git. Тарифы проверить на сайте перед подпиской.

### 4.4b Арт — Retro Diffusion (проверено 18.10.2026)
Два разных продукта с **разными моделями** (результаты не совпадают):
| | Облако retrodiffusion.ai | Расширение для Aseprite |
|---|---|---|
| Где работает | на их серверах | локально на видеокарте, офлайн |
| Цена | оплата за генерацию: ~$0.015 (RD Fast) … $0.18 (RD Pro), анимации $0.07–0.25, тайлсеты ~$0.10; кредиты не сгорают, стартовые бесплатно | разово: Lite $20 / Full $65 |
| Claude Code | **официальный MCP** (см. ниже) | API/MCP нет — только руками в Aseprite |
| Размеры | 16×16 … 384×384 | разные, крупное (720×1024) не рекомендуется |
| Анимация | есть | по сути нет (только через облако за кредиты) |

Подключение облака (ключ `rdpk-...` из Developer Tools на retrodiffusion.ai, в git не коммитить):
```powershell
claude mcp add --transport http retro-diffusion https://mcp.retrodiffusion.ai/mcp --header "Authorization: Bearer rdpk-ВАШ_КЛЮЧ"
```
Полезные инструменты: `estimate_inference_cost` (бесплатно), **`fix_pixel_art` (бесплатно — чистит любую ИИ-картинку до нормальной пиксельной сетки, пригодится и для выхода PixelLab)**, свои стили (`create_user_style`).
Решение: локальное расширение пока не покупаем (нет автоматизации, автор переводит его в отдельный редактор). Облако — сравнить с PixelLab на пробе стиля (T-25).

### 4.5 Арт — Aseprite MCP (Aseprite 1.3+)
Вариант A — headless, 76 инструментов, редактор открывать не нужно:
```powershell
npm install -g @letsagents/aseprite-mcp
claude mcp add aseprite -e ASEPRITE_PATH="C:\Program Files\Aseprite\Aseprite.exe" -- cmd /c aseprite-mcp
```
Вариант B — рисует в открытом Aseprite в реальном времени (нужно расширение):
```powershell
claude mcp add aseprite -- uvx aseprite-mcp   # github.com/giangdvdotdev/aseprite-mcp
```

### 4.6 Тест на Android: `mcp-devices` 4.2.0 (бывший claude-in-mobile)
Ставит сборку на эмулятор/телефон через ADB, жмёт, делает скриншоты.
```powershell
npm i -g mcp-devices @mcp-devices/plugin-android
mcp-devices install android
mcp-devices doctor                 # проверка Node, ADB
claude mcp add mobile -- cmd /c mcp-devices
```
Старая команда `npx claude-in-mobile@latest` из июля устарела.

### 4.7 Позже
- **Higgsfield MCP** — видео для трейлера и TikTok (фаза 3).
- Генераторы общего назначения (Nano Banana / Gemini и т.п.) — концепты, фоны, арт для страниц магазинов.

### 4.8 Скиллы Claude Code для Godot
Существуют наборы сообщества (например, `fenixnix/Godot-Skills`: формат .tscn, GDScript, autoload, сериализация), но они очень молодые и малоизвестные. **Не ставим.** Вместо этого по ходу разработки пишем свои скиллы в `.claude/skills/` (например, «добавить реакцию», «добавить кейс», «обработать ИИ-спрайт»).

> Все MCP, кроме PixelLab, — проекты сообщества. Перед установкой смотреть дату последнего коммита и issues.

### 4.9 Чистка анимаций персонажей: `tools/anim_cleanup.py`
PixelLab рисует каждый кадр анимации заново, поэтому лицо и глаза «плывут». Скрипт берёт голову из одного лучшего кадра каждого направления, чинит её (пиксели в волосах, ухо) и переносит во все кадры направления с их вертикальным смещением; заодно убирает оторванные кластеры пикселей.
```
python -I tools/anim_cleanup.py game/assets/_incoming/hero_anim/v34            # → v34/clean/
```
Настройка — словарь `SETS` (папка, число кадров, лучший кадр); координаты уха/кисти подобраны под героя. Гонять на всех будущих анимациях персонажей. Листы для ручной правки: Aseprite CLI (`Aseprite.exe -b <кадры> --sheet x.png --sheet-type horizontal --save-as x.aseprite`).

### 4.10 Пиксельные шрифты (кандидаты, не утверждено)
Все — SIL OFL 1.1 (коммерческое использование разрешено, шрифт нельзя продавать отдельно, лицензия кладётся рядом). Скачаны из `github.com/google/fonts/tree/main/ofl/`: `pressstart2p` (Press Start 2P), `pixelifysans` (Pixelify Sans), `tiny5` (Tiny5). Лежат в `game/assets/_incoming/fonts/<family>/` вместе с `OFL.txt`. Сравнение — ART_PIPELINE §6.

## 5. Настройки проекта Godot (фаза −1)
| Настройка | Значение |
|---|---|
| Renderer | Compatibility |
| Display → Window → Viewport | 640 × 360 |
| Window override (для ПК) | 1920 × 1080 |
| Stretch Mode / Aspect | `canvas_items` / `expand` |
| Scale Mode | `integer` |
| Rendering → Textures → Default Texture Filter | `Nearest` |
| Snap 2D transforms / vertices to pixel | вкл |
| Android: Target SDK | **36** |
| Android: Min SDK | 24 (Android 7.0) — проверить по шаблону |

Нюанс 4.7: новое «nearest-neighbor масштабирование вьюпорта» работает **только для 3D**. Для нашего 2D пикселя всё делается настройками выше.

## 6. Что полезного добавили в Godot 4.7 (используем)
- `Tween.tween_await()` — твин ждёт сигнал. Удобно для цепочек «реакция → эффект → текст».
- Смещения/повороты/масштаб у `Control` без конфликта с контейнерами — анимация карточек инвентаря.
- `AtlasTexture` с тайлингом в `TextureRect` — экономия на UI-рамках.
- Настройка сплэш-экрана Android прямо в экспорте; скачивание шаблонов только для нужных платформ.
- Поиск в `PopupMenu` — для длинных списков (энциклопедия).

## 7. Godot 4.8 — что ждём и когда переходить
Сейчас beta 1 (15.10.2026), дата stable не объявлена. Полезное для нас:
- **Редактор сам скачивает и настраивает Android SDK и Java** — проще сборка.
- `auto_font_size` у `Label`/`RichTextLabel` — текст подгоняется под размер (локализация RU/EN/ES).
- Редактирование узлов прямо в запущенной игре.
- Подчёркивание ошибок GDScript точно в нужном месте.

Ломающие изменения нас почти не задевают (нельзя наследовать собственный внутренний класс; на Android `OS.alert()` теперь блокирующий).
**Правило перехода:** вышла 4.8 stable + godot-ai, GUT и GodotSteam выпустили совместимые версии → переходим в отдельной ветке, гоняем тесты, мержим.

## 8. Ночные прогоны
Ноутбук остаётся включённым → Claude Code берёт задачи из `TASKS.md`, после каждой гоняет GUT-тесты (`godot --headless`), пишет `PROGRESS.md`, коммитит. Задачи, требующие решения человека, помечает `[?]` и пропускает.

## 9. Публикация (справка)
Steam — $100 за игру, обязательна анкета об использовании ИИ-контента. Google Play — $25 разово, target API 36. iOS — $99/год + Mac, отложено.
