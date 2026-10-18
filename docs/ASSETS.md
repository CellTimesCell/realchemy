# ASSETS — asset registry

Source of every asset: tool, prompt, parameters, cost. Needed for the AI-generation disclosure on Steam (see `docs/ART_PIPELINE.md` §7).

Cost is in PixelLab Tier 1 subscription generations (2000/month, resets on the 18th).

`game/assets/_incoming/` is git-ignored. Approved assets are copied to `game/assets/approved/` and committed.

## Approved (`game/assets/approved/`)
| File | Source | Role | Note |
|---|---|---|---|
| `count_adult_front_b.png` | `_incoming/style_test/round3/count_adult_front_b.png` | Count, front view; **style reference for all characters** | |
| `hero_v7_a.png` | `_incoming/style_test/round6/hero_v7_a.png` | Hero base, front view | light slightly cooler than the count — align at T-26 |
| `room_princess_boudoir.png` | `_incoming/rooms/princess_chamber/pano_center_a.png` | Boudoir — center room of the princess suite | |
| `bg_mortar_closeup_v3.png` | `_incoming/style_test/round2/bg_mortar_closeup_v3.png` | Close-up reference: rendering and light | **sleeves must be redone** (pink bathrobe → striped pajamas) |

---

## 2026-10-18 — Style test, round 1 (T-25)

Folder: `game/assets/_incoming/style_test/`. Spent **12 generations** (budget ≤ 25). Balance after: 1988.

Common style suffix: `16-bit Sega Genesis style, limited palette, dark colored outline, light from top-left`.

### Hero in pink bathrobe with wash basin
Tool: PixelLab MCP `create_character`, mode `standard`, size 32 (48×48 canvas, figure ~24–28 px), 4 directions, view `high top-down`, shading `medium`, detail `medium`. Cost: 1 per variant.

Prompt (both variants):
> young alchemist hero in a fluffy pink bathrobe and slippers, holding a metal washbasin in both hands, messy hair, 16-bit Sega Genesis style, limited palette, dark colored outline, light from top-left

| Files | Variant | PixelLab ID | Cost |
|---|---|---|---|
| `hero_bathrobe_a_{south,east,north,west}.png` | outline `single color outline`, proportions `chibi` | `3997d5c1-ba34-47c7-ae71-abe055f8c194` | 1 |
| `hero_bathrobe_b_{south,east,north,west}.png` | outline `selective outline`, proportions `cartoon` | `d020bb72-5afa-4999-90e7-270f672cf79c` | 1 |

### Vampire count
Tool and parameters as for the hero.

Prompt:
> old funny vampire count, very nearsighted, thick round glasses, sleepy half-closed eyes, long dark cape with red lining, pale skin, slightly hunched, 16-bit Sega Genesis style, limited palette, dark colored outline, light from top-left

| Files | Variant | PixelLab ID | Cost |
|---|---|---|---|
| `vampire_count_a_{south,east,north,west}.png` | `single color outline`, `chibi` | `5c853393-fa46-453a-a1ca-0fef5f819b3c` | 1 |
| `vampire_count_b_{south,east,north,west}.png` | `selective outline`, `cartoon` | `f08cdee2-fdd0-4a53-8601-3060cc942620` | 1 |

### Glowing mushrooms icon
Tool: PixelLab MCP `create_image_pixen`, 32×32, `no_background: true`, detail `medium`. (`create_1_direction_object` costs 10–25 generations — not used for icons.)

| File | Prompt | Parameters | Job ID | Cost |
|---|---|---|---|---|
| `icon_glow_mushrooms_a.png` | 16-bit Sega Genesis style game inventory icon of a small cluster of glowing bioluminescent mushrooms, cyan-green glowing caps, pale stems, centered, single object, limited palette, dark colored outline, light from top-left | outline `single color outline`, seed 101 | `0b4a4ae3-4f07-4dda-936a-956b82c5a6e9` | 1 |
| `icon_glow_mushrooms_b.png` | 16-bit Sega Genesis style game inventory icon of three glowing mushrooms, soft violet-blue luminous caps with bright spots, centered, single object, limited palette, dark colored outline, light from top-left | outline `selective outline`, seed 202 | `b4ae2e55-305a-4179-b006-5d79edf626d8` | 1 |

### Tileset: castle stone floor ↔ carpet
Tool: PixelLab MCP `create_topdown_tileset`, mode `standard`, 16×16 tiles, 16 tiles (Wang, corner-based), transition_size 0.25, view `high top-down`, outline `selective`, shading `medium`, detail `medium`. Cost: **4**.

- lower: `grey castle stone floor, large worn flagstones, dark mortar lines`
- upper: `dark red castle carpet with gold trim pattern`
- transition: `carpet edge with gold fringe over stone`

Files: `tileset_castle_stone_carpet.png` (64×64 sheet), `tileset_castle_stone_carpet.json` (metadata: corners and bounding_box per tile — slice by those, not by grid). ID `3428faab-6e38-4695-8a14-cb7849c1d38f`; base tile IDs: stone `877889db-3f13-473d-965d-87f9069afc5b`, carpet `3da23744-700a-4dce-acee-026ac9d5a795`.

### Close-up background: hands, mortar, candle
Tool: PixelLab MCP `create_image_pixen`, 480×272 canvas (sides must be multiples of 4), cropped 1 px top and bottom to 480×270 (Pillow). Originals kept as `*_raw.png`. View `side`. Cost: 1 per variant.

| File | Prompt | Parameters | Job ID | Cost |
|---|---|---|---|---|
| `bg_mortar_closeup_a.png` | 16-bit Sega Genesis style close-up scene: two hands grinding herbs with a pestle in a stone mortar on a wooden workbench, lit by a single candle, warm candlelight, dark background, limited palette, dark colored outlines, crisp pixels, no anti-aliasing | detail `medium`, seed 303 | `e319ed1e-1802-4a91-8dcb-3858b940c04b` | 1 |
| `bg_mortar_closeup_b.png` | 16-bit Sega Genesis style close-up: two hands holding a pestle and crushing powder in a heavy grey stone mortar, on an old wooden workbench, a lit candle on the left casting warm light, deep blue shadows, limited palette, dark colored outlines, crisp pixels | detail `highly detailed`, seed 404 | `f1231358-445b-4847-ac18-856b0200c954` | 1 |

### Notes
- Colors before palette reduction: icons 49–61, backgrounds 70–77, hero ~37, count ~19.
- Standard-mode characters at size 32 come out ~24–28 px tall on a 48×48 canvas.

---

## 2026-10-18 — Style test, round 2 (T-25)

Folder: `game/assets/_incoming/style_test/round2/`. Budget ≤ 8, estimate 6–7, spent **7** (balance 1988 → 1981).

New style — `docs/ART_PIPELINE.md` §1, §4. The §4 style block was appended to every prompt (for characters without `atmospheric depth`):
> vibrant modern 16-bit pixel art, storybook fairy-tale mood, rich saturated colors, warm key light against cool purple-blue shadows, soft dithered gradients, atmospheric depth, slightly exaggerated whimsical shapes, dark colored outline, crisp pixels, no anti-aliasing, no blur

"v3", "b2", "v2" are version labels, not `mode: "v3"`.

### Hero v3
`create_character` standard, size 32 (48×48 canvas), 4 directions, view `high top-down`, outline `single color outline`, shading/detail `medium`, proportions `cartoon`. ID `7d5ef73f-e64e-4e53-86e2-e93bc3221b37`. Cost 1.
Files: `hero_bathrobe_v3_{south,east,north,west}.png`.
> young alchemist hero in a bright pink fluffy bathrobe with belt, pink slippers, holding a round metal wash basin in front with both hands, messy hair, determined funny face. + style block

### Count b2
`create_character` standard, size 32, 4 directions, view `high top-down`, outline `selective outline`, shading/detail `medium`, proportions `cartoon`. ID `439cb267-40fa-410f-9578-bfeeb391d6ba`. Cost 1.
Files: `vampire_count_b2_{south,east,north,west}.png`.
> old funny vampire count with white grey hair, wearing a long striped nightcap, very thick round glasses, sleepy half-closed eyes, slightly hunched, long dark cape with red lining, pale skin. + style block

### Tileset v2
`create_topdown_tileset` standard, 16×16, 16 tiles, transition_size 0.25, view `high top-down`, outline `selective`, shading/detail `medium`. ID `fb1e6db6-d86e-40a5-aecd-08fb2c82e02d`; base tile IDs: stone `aaf8a76a-3acc-4bf2-a80f-2b053e0c0196`, carpet `e3eaedda-b0f7-4e1a-8c24-7999d64a9a21`. Cost 4.
Files: `tileset_castle_stone_carpet_v2.png` (64×64), `tileset_castle_stone_carpet_v2.json`.
- lower: `large irregular worn castle flagstones with cool purple-grey tones, soft dithered shading, dark colored mortar`
- upper: `dark muted burgundy carpet with thin gold trim, subtle woven texture`
- transition: `thin gold-trimmed carpet edge over purple-grey stone`

(No style block: the tool has only terrain descriptions, no general prompt field.)

### Close-up background v3
`create_image_pixen` 480×272 → cropped to 480×270 (Pillow, 1 px top/bottom), view `side`, outline `selective outline`, detail `highly detailed`, seed 505. Job ID `aa8326f0-7a70-422f-aabf-b479f36eee9c`. Cost 1.
Files: `bg_mortar_closeup_v3.png`, `bg_mortar_closeup_v3_raw.png`.
> close-up scene: cartoony chunky hands in fluffy PINK BATHROBE sleeves grinding with a pestle in a stone mortar on a wooden workbench, warm candle light against cool purple-blue shadows of a castle stone wall, whimsical. + style block

### Notes
- Colors: background 74 (limit ~48), hero 36, count 28 (limit ~24), tileset 41.
- Background matches the target mood (used as drawing/color reference from round 3 on). Hero reads as pajamas rather than a fluffy robe, basin too small. Count has no nightcap. Tileset came out acid violet instead of purple-grey, carpet nearly black, flagstones small.

---

## 2026-10-18 — Style test, round 3: adult proportions (T-25)

Folder: `game/assets/_incoming/style_test/round3/`. Budget ≤ 4, estimate 4, spent **4** (balance 1981 → 1977).

Front view only (no 4-direction rotation until the front view is approved). Tool: PixelLab MCP `create_image_pixen`, 64×64, `no_background: true`, direction `south`, outline `single color outline`, detail `highly detailed`. Cost 1 per image. Pixen has no negative prompt field, so the "Avoid" list is part of the prompt text. Variants differ by `view` and seed.

Style block (§4) and avoid list, appended verbatim to both prompts:
> vibrant modern 16-bit pixel art, storybook fairy-tale mood, rich saturated colors, warm key light against cool purple-blue shadows, soft dithered gradients, atmospheric depth, slightly exaggerated whimsical shapes, dark colored outline, crisp pixels, no anti-aliasing, no blur. Avoid: chibi, big head, super-deformed, cute toy-like, funko pop, stubby limbs.

### Hero, adult, front view — CANCELLED
The female hero is cancelled (2026-10-18 decision): the hero is now a young man, see round 4. Files kept for reference only.

Prompt:
> adult woman in her late 20s, realistic proportions, 1:5 head-to-body ratio, tall and slim, visible legs, wearing a long knee-length fluffy pink bathrobe with a tied belt, white towel wrapped like a turban on her head, pink slippers, holding a large round metal wash basin in front with both hands, tired but determined funny expression, detailed clothing folds. + style block + avoid list

| File | Parameters | Job ID | Cost |
|---|---|---|---|
| `hero_adult_front_a.png` | view `low top-down`, seed 611 | `b5a28aac-4ebb-48f4-844a-2c31d601b394` | 1 |
| `hero_adult_front_b.png` | view `side`, seed 612 | `18adb119-0004-4a3e-9aff-d9d2bb34a218` | 1 |

### Count, adult, front view
Prompt:
> very old tall thin vampire count, realistic proportions, 1:5 head-to-body ratio, hunched posture, long bony fingers, messy white hair, extremely thick round glasses, sleepy squinting eyes, long black cape with deep red lining, old-fashioned black suit, comedic but dignified. + style block + avoid list

| File | Parameters | Job ID | Cost |
|---|---|---|---|
| `count_adult_front_a.png` — **REJECTED** (chibi) | view `low top-down`, seed 621 | `e4a7cc78-4f9d-41d7-af28-1950e7f97d6a` | 1 |
| `count_adult_front_b.png` — **APPROVED** front view (hunched posture kept) | view `side`, seed 622 | `a46317f1-6d3d-443c-a96b-babf2b55cab8` | 1 |

### Notes
- Figure height (alpha bbox): hero 61/61 px, count 58/59 px — taller than the 52–56 px target; needs ~4–6 px of downscale/crop or a smaller prompt-side figure.
- Colors: hero 60/54, count 72/55 (limit ~24) — palette reduction required.
- Proportions: closer to adult than rounds 1–2, but heads are still ~1:3.5, not 1:5. Count a is effectively chibi (big head, short legs); count b is the closest to the brief (hunched, bony, long limbs).

---

## 2026-10-18 — Style test, round 4: hero v5, male (T-25)

Folder: `game/assets/_incoming/style_test/round4/`. Budget ≤ 4, estimate 4, spent **4** (balance 1977 → 1973).

Decisions recorded this round: count = `round3/count_adult_front_b.png` (approved); `count_adult_front_a.png` rejected; female hero cancelled, the hero is now a man.

**All four hero v5 variants are REJECTED** (2026-10-18): the count b is more detailed and lively than any of them, so the styles don't match. `round3/count_adult_front_b.png` is now the **style reference for all characters**.

Front view only. Tool: PixelLab MCP `create_image_pixen`, 64×64, `no_background: true`, direction `south`, outline `single color outline`, detail `highly detailed`. Cost 1 per image. Two variants per colorway, differing by `view` and seed.

Suffix appended verbatim to both prompts (§4 style block + avoid list):
> vibrant modern 16-bit pixel art, storybook fairy-tale mood, rich saturated colors, warm key light against cool purple-blue shadows, soft dithered gradients, atmospheric depth, slightly exaggerated whimsical shapes, dark colored outline, crisp pixels, no anti-aliasing, no blur. Avoid: chibi, big head, super-deformed, cute toy-like, funko pop, stubby limbs, holding objects.

### Colorway A — blue/white stripes
> adult man in his late 20s, realistic proportions, about 1:4 head-to-body ratio, slim, visible legs, wearing classic button-up pajamas with vertical BLUE and white stripes, soft slippers, messy bedhead hair, sleepy confused but determined expression, empty hands relaxed at sides, detailed fabric folds. + suffix

| File | Parameters | Job ID | Cost |
|---|---|---|---|
| `hero_v5_blue_a.png` | view `side`, seed 711 | `d74d9fe6-cbba-4045-88df-487c29c276f1` | 1 |
| `hero_v5_blue_b.png` | view `low top-down`, seed 712 | `b0e93096-da41-485e-97cd-2b4a798e7e7f` | 1 |

### Colorway B — sage green/cream stripes
> adult man in his late 20s, realistic proportions, about 1:4 head-to-body ratio, slim, visible legs, wearing classic button-up pajamas with vertical muted sage GREEN and cream stripes, soft slippers, messy bedhead hair, sleepy confused but determined expression, empty hands relaxed at sides, detailed fabric folds. + suffix

| File | Parameters | Job ID | Cost |
|---|---|---|---|
| `hero_v5_green_a.png` | view `side`, seed 721 | `d45b2b0c-4a5e-4103-b065-ff77e8eb0180` | 1 |
| `hero_v5_green_b.png` | view `low top-down`, seed 722 | `8d26bf8c-d426-4f8a-bc3e-e7423d4e7175` | 1 |

### Scale check (0 generations)
- `scale_check_floor.png` — 640×360 floor composed with Pillow from `round2/tileset_castle_stone_carpet_v2.png` by Wang corners (stone with a carpet rectangle); no new generation.
- Temporary scene `game/tests/scale_check.tscn` (Node2D + 3 Sprite2D: floor, count b at (288,180), hero green_a at (352,180)), built via godot-ai MCP, run at 640×360 → 1920×1080 (integer ×3).
- `scale_check.png` — game framebuffer screenshot via godot-ai, 1920×1080.

### Notes
- Figure height (alpha bbox): blue_a 63, blue_b 62, green_a 61, green_b 60 px (target 52–56). Colors: 53 / 55 / 38 / 28 (limit ~24).
- blue_a: bearded, big head, cheerful rather than sleepy. blue_b: most adult and sleepy, but wears jeans instead of pajama trousers. green_a: full pajama set, sleepy-confused face, closest to the brief (used in the scale check), reads somewhat young. green_b: stripes drift toward blue-grey.

---

## 2026-10-18 — Style test, round 5: hero v6, matched to the count (T-25)

Folder: `game/assets/_incoming/style_test/round5/`. Budget ≤ 6. The planned 2 + 2 variants would cost 12, because no 1-generation MCP tool takes a style image (pixen and pixflux don't, Bitforge is not exposed in MCP); `create_image_pro_flash` with `style_image` costs 5. The owner chose **1 + 1 = 6**. Spent **6** (balance 1973 → 1967).

Style reference: `round3/count_adult_front_b.png`, uploaded via `get_upload_url` (`upload:00230c06-1abd-44bb-bf01-30223d63ae30`, kept 3 days).

Prompt (identical for both variants, verbatim):
> middle-aged man in his mid 40s, clean-shaven face, no beard, no stubble, slight wrinkles around tired half-closed eyes, receding messy bedhead hair with a little grey at the temples, three-quarter view, sleepy slouched posture, one hand scratching his messy hair, other hand holding up slipping pajama trousers, blue and white vertical striped button-up pajamas with matching striped trousers, soft slippers, comedic, same rendering, lighting and detail level as the reference. vibrant modern 16-bit pixel art, storybook fairy-tale mood, rich saturated colors, warm key light against cool purple-blue shadows, soft dithered gradients, atmospheric depth, slightly exaggerated whimsical shapes, dark colored outline, crisp pixels, no anti-aliasing, no blur. Avoid: chibi, big head, super-deformed, cute toy-like, funko pop, stubby limbs, stiff symmetric pose, flat shading, holding objects, beard, stubble, young face, teenager.

| File | Tool and parameters | Job ID | Cost |
|---|---|---|---|
| `hero_v6_styleref_a.png` — **REJECTED as a base** (style right, character wrong; brief changed to a young man) | `create_image_pro_flash`, 64×64, `no_background: true`, seed 811, `style_image` = count b with usage "style reference only: match its rendering, outline, shading, detail level, lighting and color treatment; do not copy the character", `style_options` all true (palette, detail, outline, shading). No view/outline/detail params in this tool. | `2b89f3ba-71bb-41cf-8b83-cf65a0096806` (image `f4f693a8-d943-5eef-8f83-4173e5cb52d0`) | 5 |
| `hero_v6_noref_a.png` | `create_image_pixen` with the count b parameters: 64×64, `no_background: true`, direction `south`, view `side`, outline `single color outline`, detail `highly detailed`, seed 812 | `bec1f071-450a-4c69-bbac-e6bd448df82b` | 1 |

### Notes
- Figure height: styleref 61 px, noref 63 px (count b 59). Colors: 53 / 42 (count b 55).
- styleref: rendering, warm rim light and slouch match the count closely; both actions read (scratching head, holding trousers). Reads older than mid-40s (mostly grey hair).
- noref: clean-shaven, receding hair, both actions present, but flatter and more saturated cyan, stiffer pose, thicker outline, with a red/cyan fringe on the right edge — does not match the count's style.

---

## 2026-10-18 — Style test, round 6: hero v7, young man (T-25)

Folder: `game/assets/_incoming/style_test/round6/`. Budget 10, estimate 10, spent **10** (balance 1967 → 1957).

New brief: a young man (~25). `round5/hero_v6_styleref_a.png` is no longer the base.

Tool: PixelLab MCP `create_image_pro_flash`, 64×64, `no_background: true`, `style_image` = `round3/count_adult_front_b.png` (`upload:00230c06-1abd-44bb-bf01-30223d63ae30`, same upload as v6) with usage "style reference only: match its rendering, outline, shading, detail level, lighting and color treatment; do not copy the character", `style_options` all true. Cost 5 per image.

Prompt (identical for both variants, verbatim):
> young adult man about 25 years old, adult face (not a teenager), clean-shaven, full thick messy bedhead hair, dark brown, no receding hairline, no bald spot, standing upright with good posture, relaxed confident stance, one hand sheepishly scratching the back of his head, friendly slightly bemused expression, eyes open, light smile, blue and white vertical striped button-up pajamas with matching striped trousers, soft slippers, three-quarter view, same rendering, lighting and detail level as the reference. vibrant modern 16-bit pixel art, storybook fairy-tale mood, rich saturated colors, warm key light against cool purple-blue shadows, soft dithered gradients, atmospheric depth, slightly exaggerated whimsical shapes, dark colored outline, crisp pixels, no anti-aliasing, no blur. Avoid: hunched, slouched, sad face, tired droopy eyes, old, receding hairline, bald spot, grey hair, beard, stubble, teenager, anime, chibi, big head, stiff symmetric pose, flat shading, holding objects.

| File | Seed | Job ID (image ID) | Cost |
|---|---|---|---|
| `hero_v7_a.png` — **APPROVED** hero base (owner's pick: slight smile, looks better) | 911 | `6fad7638-2aa7-42f6-ac81-1966abd83b6b` (`4fba0097-340e-51c8-a1d5-1e76feb9f7e5`) | 5 |
| `hero_v7_b.png` — **REJECTED** | 912 | `3aa9c97e-6f69-4ef0-80c3-72f7cbc6930f` (`7d79baf2-287a-56b8-aa14-10ab0f1f7b47`) | 5 |

### Notes
- Figure height: a 63 px, b 62 px (count b 59, target 52–56). Colors: a 62, b 45.
- Decision: heights are NOT reduced — the count is hunched, so the difference is natural. The hero's light is slightly cooler than the count's; align it during palette reduction (T-26), no extra generations.
- a: upright, scratching head, smiling; the face leans youthful/anime and the light is cooler than the count's.
- b: thick messy dark-brown hair, adult face, relaxed stance with the other hand on the hip, warm rim light — closest to the count's rendering.

### Tileset 32px (round 6)
Tool: PixelLab MCP `create_topdown_tileset`, mode `standard`, tile 32×32 (new map tile size, see `ART_PIPELINE.md` §2), 16 tiles, transition_size 0.25, view `high top-down`, outline `selective`, shading `medium`, detail `medium`. Cost **4** (balance 1957 → 1953).
ID `160bda84-159b-4e5d-9295-38fe82076c91`; base tile IDs: stone `a666f687-239f-41ea-a40e-c978456fbfb8`, carpet `2c55bf1f-c955-4e73-b03d-3ab10e7c930f`.
Files: `round6/tileset_castle_stone_carpet_32.png` (128×128 sheet, 38 colors), `round6/tileset_castle_stone_carpet_32.json`.
- lower: `large worn flagstones, desaturated cool grey with a slight lavender tint, dark mortar, subtle cracks`
- upper: `deep muted burgundy castle carpet with thin gold trim`
- transition: `carpet edge with small gold fringe`

### Scale check (round 6, 0 generations)
- `round6/scale_check_floor_32.png` — 20×11 tiles (640×352) composed with Pillow by Wang corners: stone with a carpet rectangle (vertices x 6–14, y 4–9).
- `game/tests/scale_check.tscn` updated via godot-ai: floor at (0,4) (centered vertically, 4 px of clear color top and bottom), count b at (288,208), hero v7 a at (352,208), both on the carpet.
- `round6/scale_check.png` — game framebuffer, 1920×1080 (640×360 ×3).
- Result: the characters are ≈ 2 tiles tall as planned. Stone is now grey-lavender, but reads as small bricks rather than large flagstones and repeats visibly; carpet is a flat dark burgundy with almost no texture, the gold fringe shows mainly on the bottom edge.

---

## 2026-10-18 — Room `princess_chamber`, stage A: empty shell (pipeline §3.4)

Folder: `game/assets/_incoming/rooms/princess_chamber/`. Budget 2, estimate 2, spent **2** (balance 1953 → 1951).

Tool: PixelLab MCP `create_image_pixen`, 640×360, `no_background: false`, view `high top-down`, outline `selective outline`, detail `highly detailed`. Cost 1 per image. Pixen has no negative prompt field, so the "Avoid" list is part of the prompt text.

Prompt (identical for both variants, verbatim):
> EMPTY interior of a gothic vampire castle tower bedchamber, no furniture, no people, steep top-down three-quarter view showing the floor and the lower part of the walls, dark carved stone walls, two tall pointed gothic tracery windows with full moon and night sky, pink ribbons and bows clumsily tied on the dark gothic stone, faded rose wallpaper patches, round decorative mosaic floor pattern in the center, worn wooden floor planks near the walls, carved wooden door on the left wall, edge of a painted vaulted ceiling at the top, dust and cobwebs in the corners, cool blue-teal moonlight streaming through the windows onto the floor, large clear empty floor area for furniture and characters. vibrant modern 16-bit pixel art, storybook fairy-tale mood, rich saturated colors, warm key light against cool purple-blue shadows, soft dithered gradients, atmospheric depth, slightly exaggerated whimsical shapes, dark colored outline, crisp pixels, no anti-aliasing, no blur. Avoid: furniture, bed, table, chair, characters, text, blurry, photorealistic.

| File | Seed | Job ID | Cost | Colors |
|---|---|---|---|---|
| `shell_a.png` | 1001 | `9c637068-398e-442c-b8f9-9b474a782e54` | 1 | 56 |
| `shell_b.png` | 1002 | `0c8d0765-8d48-404e-a765-fd3269016c5c` | 1 | 77 |

### Notes
- shell_a: no furniture; ribbons and bows, rose wallpaper, cobwebs, tracery windows with moon, painted vault edge — all present. But walls fill ~75% of the frame and the floor is a strip at the bottom; the door is in the centre, not on the left wall; three windows instead of two; two mosaic circles at the edges instead of one in the centre.
- shell_b: **contains a bed** (violates "no furniture"); four windows, door in the centre, a wall sconce with a candle; floor also only the bottom ~third. Moonlight on the mosaic reads nicely.
- In both the camera is a low 3/4 corner view, not the steep top-down asked for — little walkable floor.

## Room `princess_chamber`, stage B: scale and light (0 generations)

`game/tests/scale_check.tscn` rebuilt via godot-ai (old floor tiles and the count removed):
- `ShellA`, `ShellB` — Sprite2D backgrounds at (0,0), switched with `visible`.
- `Shadow` — Sprite2D with a radial `GradientTexture2D` (64×64, dark violet α 0.6 → 0), scale (0.6, 0.22) → ~38×14 px oval at (320,320).
- `Hero` — `round6/hero_v7_a.png` at (320,290).
- `Night` — CanvasModulate `#3a3558`.
- `MoonLight` — PointLight2D, radial gradient 256 px, `texture_scale` 2.2, color `#c9b6ff`, energy 1.1, at (460,190) (window side).
- `CandleLight` — PointLight2D, same gradient, `texture_scale` 0.7, color `#ffa257`, energy 1.3, at (284,300) next to the hero.

Screenshots (game framebuffer 1920×1080, ×3): `scale_a.png` (shell_a), `scale_b.png` (shell_b).

Result: lighting reads well (cold lilac moon against a warm candle spot). Scale problem: the door is ~190 px tall vs the 63 px hero (~3×), so the room reads oversized/the hero tiny, and there is little open floor to walk on.

---

## 2026-10-18 — Room `princess_chamber`, A1: panorama center section

Plan change (owner): shell_a cleanup (36–54 generations via 256×256 Pro Flash inpaint tiles) is NOT done — Tier 1 tools can't inpaint/outpaint 640×360 directly and `unzoom_image` does not zoom out a scene. Instead: a 1280×360 panorama from three 640×360 pixen parts (left edge / center / right edge, theatre-stage perspective), seams hidden behind foreground column sprites. This entry is the center only.

Budget 2, estimate 2, spent **2** (balance 1951 → 1949). Folder: `game/assets/_incoming/rooms/princess_chamber/`.

Tool: PixelLab MCP `create_image_pixen`, 640×360, `no_background: false`, view `high top-down`, outline `selective outline`, detail `highly detailed`. Cost 1 per image.

Prompt (identical for both, verbatim):
> EMPTY interior of a gothic vampire castle tower bedchamber, center section, theatre stage diorama view, the far back wall seen strictly straight-on (frontal, no corners visible), a small carved wooden door in the exact center of the back wall, one tall pointed gothic tracery window on each side of the door with full moon and night sky, carved stone columns at the left and right edges of the frame, dark carved stone walls with faded rose wallpaper panels, symmetrical decoration: exactly one neat pink bow centered above each window and even identical pink ribbon garlands between the columns, mirrored left and right, painstaking but tacky decoration, worn wooden floor planks with a round mosaic pattern in the center, the door is small, about one quarter of the image height, floor fills the lower half of the image, a few cobwebs only in the top corners, cool blue-teal moonlight from the windows falling onto the floor, no furniture, no people, nothing on the floor. vibrant modern 16-bit pixel art, storybook fairy-tale mood, rich saturated colors, warm key light against cool purple-blue shadows, soft dithered gradients, atmospheric depth, slightly exaggerated whimsical shapes, dark colored outline, crisp pixels, no anti-aliasing, no blur. Avoid: furniture, bed, table, chair, characters, ribbons on the floor, bows on the floor, side walls, corners, chaotic decoration, text, blurry, photorealistic.

| File | Seed | Job ID | Cost | Colors |
|---|---|---|---|---|
| `center_a.png` | 1101 | `6a0b4fee-9e3d-4fe6-ada0-9ef8da357207` | 1 | 70 |
| `center_b.png` | 1102 | `b7c6961f-9d81-4ce1-bddc-8af3eca07c75` | 1 | 66 |

### Notes
- center_a: came out as a **diptych** — a separate dark left panel (curtains, sconces, one window) at x≈0–255, and the requested frontal center at x≈262–640: door in the middle, one window each side, columns at the edges, one bow above each window + an even garland, mosaic circle, nothing on the floor, cobwebs only in the top corners. Door ≈ 100 px with frame (leaf ≈ 90 px) → ~1.45–1.6× the 63 px hero. Floor ≈ lower 30%, not half.
- center_b: one continuous frontal hall, door off-center (x≈428–488, ≈108 px with finial), five windows, big bows on columns and walls (not the "one per window" rule), cobwebs at column bases, a large column in the middle foreground. Floor ≈ lower 30%.

### Scale check (0 generations)
`game/tests/scale_check.tscn`: `ShellA`/`ShellB` now use `center_a`/`center_b`; hero v7 a next to the door — (398,224) on A, (404,230) on B — shadow under the feet, candle light beside him, moon light at (540,200).
Screenshots 1920×1080: `scale_center.png` (center_a), `scale_center_b.png` (center_b).

---

## 2026-10-18 — Room `princess_chamber`, 1920×360 panorama: step 1, center

New layout (owner): 3 screens; windows only on the outer far wall, the door only on the right side wall. `center_a.png` is rejected as the center (door on the window wall); only its style, scale and bow rules are kept.

Budget for the whole panorama ≤ 8 (estimate 7–8). Step 1 spent **2** (balance 1949 → 1947). Files named `pano_center_*` so the earlier `center_*` are not overwritten.

Tool: PixelLab MCP `create_image_pixen`, 640×360, `no_background: false`, view `high top-down`, outline `selective outline`, detail `highly detailed`. Cost 1 per image.

Prompt (identical for both, verbatim; the part before "CENTER SECTION" is the shared prefix planned for all panorama parts):
> EMPTY interior of a gothic vampire castle tower bedchamber at night, theatre stage diorama view, the wall-floor line at about 60% of the image height, worn wooden floor planks, dark carved stone walls with faded rose wallpaper panels, cool blue-teal moonlight from the windows falling onto the floor, symmetrical painstaking but tacky decoration: exactly one neat pink bow centered above each window and even identical pink ribbon garlands between the columns, a few cobwebs only in the top corners, no furniture, no people, nothing on the floor. CENTER SECTION: the far outer wall seen strictly straight-on (frontal, no corners, no side walls visible), three tall pointed gothic tracery windows evenly spaced with full moon and night sky, carved stone columns at the left and right edges of the frame, round mosaic pattern on the floor in the center, large empty floor space, no door. vibrant modern 16-bit pixel art, storybook fairy-tale mood, rich saturated colors, warm key light against cool purple-blue shadows, soft dithered gradients, atmospheric depth, slightly exaggerated whimsical shapes, dark colored outline, crisp pixels, no anti-aliasing, no blur. Avoid: door, furniture, bed, table, chair, curtains, characters, ribbons on the floor, bows on the floor, side walls, corners, split panels, diptych, chaotic decoration, text, blurry, photorealistic.

| File | Seed | Job ID | Cost | Colors |
|---|---|---|---|---|
| `pano_center_a.png` — **APPROVED as the BOUDOIR** (center room of the suite, as is: sconce bay + 3-window bay with mosaic) | 1201 | `f78c41af-e2a5-420e-af27-271423e648ed` | 1 | 82 |
| `pano_center_b.png` — **REJECTED** | 1202 | `0929d7c4-c232-4ea6-98b2-de14425bb50e` | 1 | 50 |

### Notes
- Both came out split again despite "split panels, diptych" in the avoid list — pixen at 640×360 tends to draw two bays.
- pano_center_a: left bay x≈0–250 (one window, rose wallpaper, two wall sconces, side wall with a door-like panel) + right bay x≈255–640 with three windows, one bow above each, even garlands, mosaic; the right bay is a slightly curved apse, not strictly frontal. Wall-floor line ≈ y 250. Windows ≈ 155 px tall (center_a ≈ 110).
- pano_center_b: two box-like bays — left x≈0–270 (two windows, curtain edge on the far left), right x≈290–640 (three windows with candles between, one bow above each, garlands, mosaic, short side-wall stubs). Wall-floor line ≈ y 225. Windows ≈ 120 px.
- Stopped before edges and columns (agreed rule: no edge generations if the center doesn't work).
- Decision (owner): the 1920×360 panorama is dropped. The princess chamber becomes a SUITE (enfilade) of three 640×360 rooms connected by arches: bedroom | boudoir (`pano_center_a`) | dressing room.

---

## 2026-10-18 — Room `princess_chamber` as a SUITE: bedroom and dressing room

Budget 4, estimate 4, spent **4** (balance 1947 → 1943). Tool: `create_image_pixen` 640×360, `no_background: false`, view `high top-down`, outline `selective outline`, detail `highly detailed`. Shared prompt prefix + room part + §4 style block + avoid list (exact text in the job records below; prefix = "EMPTY interior of a gothic vampire castle tower bedchamber at night, theatre stage diorama view, the wall-floor line at about 70% of the image height, worn wooden floor planks, dark carved stone walls and columns with faded rose wallpaper panels, cool blue-teal moonlight, warm orange torch light, symmetrical painstaking but tacky decoration: neat pink bows and even identical pink ribbon garlands between the columns, a few cobwebs only in the top corners, no furniture, no people, nothing on the floor.").

| File | Room part of prompt | Seed | Job ID |
|---|---|---|---|
| `suite_bedroom_a.png` | BEDROOM: a deep empty alcove in the back wall framed by heavy dark burgundy drapes, empty space inside the alcove for a future canopy bed, one wall torch with a warm flame, rose wallpaper, on the RIGHT side of the image an open gothic pointed archway passage to the next room with a glimpse of blue moonlight through it. Avoid: bed, furniture, table, chair, characters, ribbons on the floor, bows on the floor, chaotic decoration, text, blurry, photorealistic. | 1301 | `e2654a59-0893-4187-82c4-e2d2a882201b` |
| `suite_bedroom_b.png` | same | 1302 | `bc39f7b1-74e8-4d2a-ae1a-74636e92eb43` |
| `suite_dressing_a.png` | DRESSING ROOM: on the LEFT side of the image an open gothic pointed archway passage to the next room with a glimpse of blue moonlight through it, a small carved wooden door in the back wall leading to a spiral staircase, the door is small, about one quarter of the image height, one wall torch with a warm flame, large empty wall space and floor space for a future wardrobe and writing desk, no windows. Avoid: furniture, wardrobe, desk, table, chair, characters, ribbons on the floor, bows on the floor, chaotic decoration, text, blurry, photorealistic. | 1401 | `8b9ce243-a255-4571-99f5-3bdd78764818` |
| `suite_dressing_b.png` | same | 1402 | `59ed6d05-7376-4fda-8a28-68ac28c1890d` |

Notes: bedroom_a — empty curtained alcove, rose-wallpaper bay with torches, moonlit arch on the right, a foreground balustrade with bows on its posts. bedroom_b — several curtained alcoves, many bows, a bed corner at bottom-left (furniture leaked in). dressing_a — arch on the left, open moonlit door + second door + spiral stairs, small rug, doors ≈140 px (too big), 256 colors. dressing_b — stairs in the left arch, big open door, carved door on the right, a small table (furniture leaked in), doors ≈135–170 px.

Scene `game/tests/room_suite.tscn` + `room_suite.gd` (runs without errors; screenshots `suite_bed.png`, `suite_boudoir.png`, `suite_dressing.png`, 1920×1080): bedroom_a | boudoir (pano_center_a) | dressing_a at x 0/640/1280, hero v7 a with shadow, arrow-key walking, camera slides 0.4 s between rooms, CanvasModulate night, 3 moon lights + 7 torch/sconce lights.

---

## 2026-10-18 — Experiment 1: hero animation (not approved)

Folder: `game/assets/_incoming/hero_anim/`. Spent **5** generations.

- Character: `create_character` mode `v3`, `reference_image_url` = `approved/hero_v7_a.png` (`upload:39eb2f26-d4ba-4f00-a8f2-992c2d80ee97`), `n_directions: 4`, view `low top-down`, 64×64. ID `00659c7e-2e4b-4a22-b2d8-6c20c8c2018b`. Cost 1. Description: "young man, short full brown hair, no beard, slight smile, blue-and-white vertical striped button-up pajamas with matching trousers, soft slippers, adult proportions 1:5, upright posture". Files: `rot/{south,east,north,west}.png`.
- `animate_character` template `walk`, directions south/north/east, 6 frames each (group `9f4cbc0a-0b60-44df-b9cb-691b0978229c`). Cost 3. Files: `walk_{south,north,east}/0–5.png`. West = east with `flip_h`.
- `animate_character` template `breathing-idle`, south, 4 frames (group `5d222397-1ac2-4410-9d9a-f37aa46a1bed`). Cost 1. Files: `idle_south/0–3.png`.
- Godot: `game/tests/hero_anim_frames.tres` (SpriteFrames), `Hero/Anim` AnimatedSprite2D in `room_suite.tscn`, logic in `room_suite.gd`.
- Comparison: `hero_anim_compare.png` (rows: v7 a + idle, walk south, walk east, walk north, walk west mirrored; bottom: in-game idle next to static v7 a, in-game walk west).
- Notes: identity (face, hair, pajamas, slippers) holds. The reference pose (hand on the back of the head) is baked into the rotations, so in walk south/north the arm stays up and the legs barely stride; walk east strides well but the arm is hidden. Walk frames are ~59 px tall vs 63 px for v7 a and slightly narrower.

## 2026-10-18 — Experiment 2: hybrid bedroom (not approved)

Folder: `game/assets/_incoming/rooms/hybrid_bedroom/`. Spent **17** generations, all `create_image_pixen` (1 each). For these pieces the §4 style block was used WITHOUT "warm key light against cool purple-blue shadows" (conflicts with the flat/even lighting requirement; light comes from Godot).

**Room box** (640×360, view `high top-down`, outline `selective`, detail `highly detailed`):
| File | Seed | Job ID | Result |
|---|---|---|---|
| `box_1501.png`, `box_1502.png`, `box_1503.png` | 1501–1503 | `31416707-7351-448c-ad67-b15d3735c469`, `8579cc1f-07e2-4282-96ff-a46c34a4ddcb`, `128d4665-c71c-4453-86fe-6792eb000773` | prompt with "bedroom" → beds, candles, bows, curtains, doors leaked in |
| `box_1511.png` **(used)**, `box_1512.png` | 1511, 1512 | `931dc805-b92b-4ee8-a8ae-d005310f8646`, `ebf40582-a583-4edb-98d6-31d017df74cf` | 1511 fully empty (two bays, the right one split by pillars into 3 niches); 1512 has bows, sconces, a curtain |
| `box_1513.png` | 1513 (view `side`) | `77703a22-8e01-4fb3-adc9-bfe941078f78` | almost empty (one candle, small bows) |

Prompt 1501–1503 (owner's text):
> empty gothic castle bedroom interior, diorama view, back wall facing the viewer straight-on, short side walls, dark wooden plank floor with depth, vaulted ceiling edge at top, faded torn pink rose wallpaper on the back wall between stone pillars, dusty lilac-grey stone, dark wood, completely empty: no windows, no doors, no arches, no furniture, no bows, no candles, no torches, nothing on the floor, soft even light. + style block. Avoid: windows, doors, arches, furniture, bed, curtains, bows, ribbons, candles, torches, glow, strong shadows, characters, text, blurry, photorealistic.

Prompt 1511–1513:
> bare empty stone room shell in a gothic castle, unfurnished, diorama view, one single wide back wall facing the viewer straight-on, short side walls at the left and right edges, dark wooden plank floor with depth in the lower third, vaulted ceiling edge at top, faded torn pink rose wallpaper panels on the back wall between dusty lilac-grey stone pillars, dark wood wainscoting, plain bare walls and plain bare floor, soft even ambient light. + style block. Avoid: bed, furniture, table, nightstand, bench, chair, curtains, drapes, windows, doors, arches, bows, ribbons, candles, torches, lamps, glow, strong shadows, characters, text, blurry, photorealistic.

**Kit pieces** (transparent background unless noted; all prompts end with the reduced style block and an Avoid list — exact text in the job records):
| File | Size | Seed | Job ID | Note |
|---|---|---|---|---|
| `window_narrow_1601.png` → `window_narrow.png` | 48×108 | 1601 | `517f5657-6a29-4f6b-bc88-622b83ca3895` | panes came out transparent |
| `window_wide_1602.png` → `window_wide.png` | 84×112 | 1602 | `e86fe67c-af6f-4775-b8f1-225ff83a493b` | glass made transparent by script (bluish pixels removed) |
| `window_view_1603_raw.png` → `window_view.png` | 256×128 opaque | 1603 | `576b3a90-1316-4c53-8301-39f4de3426dc` | came with a frame; cropped to the sky (165×91). Per-window view layers `window_*_view.png` = view pixels only inside each window's openings |
| `arch_narrow_1604.png` | 64×100 | 1604 | `0ed13423-5d0a-47fa-b118-ecc34499c5a0` | rejected: open doors + ivy inside |
| `arch_narrow_1611.png` **(used)** | 64×100 | 1611 | `460d9108-5cfa-44e4-b533-c791a71e400f` | dark opening, some ivy |
| `arch_wide_1612.png` | 104×104 | 1612 | `055380e2-2a51-4e7d-9eef-448c5d373e15` | clean, dark |
| `drapes_1613.png` | 160×160 | 1613 | `7caac8a1-d612-4659-938b-bd4c48524b2c` | burgundy, gold tiebacks, rod |
| `torch_1614.png` | 32×48 | 1614 | `df01ef70-e769-4a58-8b67-bba665dc1cd1` | drew a small flame despite "unlit" |
| `sconce_1615.png` | 32×48 | 1615 | `78108650-e041-440d-a5ef-b69cb41d98f4` | small lit candle despite "unlit" |
| `cobwebs_1616.png` → `cobweb_corner/small/hanging.png` | 192×64 | 1616 | `48fca1e1-90fa-436d-ad84-058f3478183c` | cut into 3 by script |
| `bow_1617.png` | 32×32 | 1617 | `4620093e-9be0-41bd-a738-55b3a9cc4869` | symmetric |

Scene `game/tests/hybrid_bedroom.tscn` (box_1511 + view layers behind 2 windows + drapes in the center niche of the right bay + narrow arch to the boudoir + torch, sconce, 3 bows, 3 cobwebs + 5 PointLight2D) is instanced as `Bedroom` in `room_suite.tscn` instead of `suite_bedroom_a`. Screenshots: `game_hybrid_bedroom.png`, `game_boudoir.png`, `hybrid_vs_boudoir.png`.
