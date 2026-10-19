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
| `hero_pose_34.png` | `_incoming/hero_anim/pose34/pose_1802_fixed.png` | Hero base pose: 3/4, lowered arm, slippers recolored to v7 a (rows 57–63 copied from `hero_v7_a.png`) | animations not yet approved |
| `room_princess_bedroom.png` | `_incoming/rooms/bedroom_v4/bedroom_v4_a_room.png` (rerender A 2001, glass cut out, left mullion restored) | Princess bedroom (left room of the suite) | live layers: `window_view_tower.png`, `window_clouds.png` + flames/lights in scene |
| `window_view_tower.png` | `_incoming/rooms/bedroom_v4/view_tower_2102.png` (center crop, lit windows painted out) | Shared window view for all suite windows | |
| `window_clouds.png` | `_incoming/rooms/bedroom_v4/clouds_2022.png` | Scrolling cloud strip behind window glass | |
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

---

## 2026-10-18 — Hero neutral pose, emote, bedroom layout v2 (not approved)

Spent **22** (balance 1921 → 1899).

**Neutral pose** (`_incoming/hero_anim/neutral/`): `edit_image_pro_flash`, method `text`, source `approved/hero_v7_a.png` (`upload:39eb2f26-d4ba-4f00-a8f2-992c2d80ee97`), 64×64, transparent. Cost 5 each.
| File | Seed | Job ID | Prompt |
|---|---|---|---|
| `neutral_1701.png` | 1701 | `d4d0ad53-a4bd-4a68-96ff-540a62dd78ac` | change only the pose: both arms hanging relaxed straight down along the sides of the body, hands open at the hips, standing straight and upright facing the viewer, feet slightly apart. Keep exactly the same face, slight smile, messy brown hair, blue and white striped pajamas, slippers, colors, outline, shading and the same height. |
| `neutral_1702.png` (my pick) | 1702 | `e0a4e9ce-c1fa-4382-a3cf-228ca7f437bb` | same as 1701 |
| `neutral_1703.png` | 1703 | `7cf3600a-abd2-4634-a4e6-f4116f53ecb2` | neutral standing pose for a game character: arms relaxed down at the sides, straight upright posture, body facing straight toward the viewer, symmetric stance. Keep the same young man: same face with a slight smile, same messy brown hair, same blue and white striped pajamas and slippers, same colors, outline, shading and size. |

**emote_scratch_head** (`_incoming/hero_anim/emote_scratch_head/`): `animate_character` mode `v3` on character `00659c7e-…` (hand-on-head pose), south, 6 frames + reference frame, action "sheepishly scratching the back of his head with one hand, slight confused smile, small head tilt, standing in place". Group `914003bb-7016-4945-a246-d8704b52dd38`. Cost 1. Frames came on a 92×92 canvas; cropped to 64×64 with feet aligned (`0–6.png`), raw in `raw_*.png`. Preview `emote_scratch_head.gif`.

**Bedroom layout v2** (`_incoming/rooms/hybrid_bedroom/`), `create_image_pixen`, cost 1 each:
| File | Size | Seed | Job ID | Note |
|---|---|---|---|---|
| `arch_floor_1711.png`, `arch_floor_1712.png` | 64×92 | 1711, 1712 | `89440ddb-b867-4c0d-8393-5f429691277c`, `f9291ea4-dd29-4742-ab01-2fdd484b6852` | rejected: corridor/steps + ivy |
| `arch_floor_1721.png` | 64×92 | 1721 | `2c42f908-94c6-4918-b17b-18e19c789491` | rejected: open doors, ivy |
| `arch_floor_1722.png` → `arch_floor.png` **(used)** | 64×92 | 1722 | `369f2646-dc9a-4d9a-93eb-ccd8f129f6b8` | dark opening with pale moonlight glow; ivy removed by script |
| `drapes_niche_1713.png` **(used)**, `drapes_niche_1714.png` | 88×184 | 1713, 1714 | `ee69fce3-c6fd-4faa-94c0-bab6fa8a13c4`, `72de6b2a-59d3-4295-b9e6-e32c9f6c74e6` | fit inside the niche between pillars |

Arch prompt 1721/1722: "doorway opening in a castle wall: a simple pointed gothic arch frame made of clean smooth cut lilac-grey stone blocks, front elevation, flat front view, the opening reaches the floor level, the inside of the opening is solid flat dark navy shadow with a faint pale blue glow in the middle, no vegetation, flat even lighting. 16-bit pixel art, dark colored outline, crisp pixels, no anti-aliasing, no blur. Avoid: ivy, vines, moss, plants, leaves, steps, stairs, corridor, door, perspective, background."

Script edits (0 generations): `torch_unlit.png` (flame rows cut), `sconce_unlit.png` (flame pixels replaced by dark glass). Fire = `CPUParticles2D` (TorchFlame, CandleFlame) + PointLight2D.

Layout (`game/tests/hybrid_bedroom.tscn`): two identical `window_narrow` at x 105 and 362 (y 170) with view layers; drapes in the center niche (457, 198); bows at y 96 over both windows and the niche; torch (401,170) and sconce (513,170) on the niche pillars; arch on the floor (548, 246, bottom at the floor line y≈292). Screenshot: `hybrid_bedroom_v2.png`. The static v7 a next to the hero was removed from `room_suite`.

---

## 2026-10-18 — Hero 3/4 pose, bedroom v3 «integration», sketch → rerender (not approved)

Spent **70** (balance 1899 → 1829). Owner feedback: neutral poses 1701–1703 rejected (face the camera); bedroom v2 looked «pasted on».

**Hero 3/4 pose** (`_incoming/hero_anim/pose34/`, sheet `hero_pose_variants.png`): `edit_image_pro_flash` text, source `approved/hero_v7_a.png`, 64×64, cost 5 each.
| File | Seed | Job ID |
|---|---|---|
| `pose_1801.png` | 1801 | `80761a54-bcd0-4ef0-b33f-a8e05ec4405c` |
| `pose_1802.png` (my pick) | 1802 | `22c5605a-460f-44b4-acb9-db178f00a50b` |
| `pose_1803.png` | 1803 | `a1a70ee0-9b51-4551-836e-5751e21054a7` |
Prompt 1801/1802: "change only one arm: the raised arm that scratches the back of the head is lowered and hangs relaxed down along the side of the body. Keep everything else exactly the same: the same three-quarter view, the same stance and leg position, the other hand resting on the hip, the same face with the slight smile, the same messy brown hair, blue and white striped pajamas, slippers, colors, outline, shading and size." 1803: "same character in the same relaxed three-quarter standing pose, but the hand is no longer on his head: that arm now hangs loosely down by his side with the hand open near the thigh. Keep the other hand on the hip, the same slight smile, the same face, messy brown hair, blue and white striped pajamas, slippers, colors, outline, shading and size."

**Bedroom v3 pieces** (`_incoming/rooms/hybrid_bedroom/`), `create_image_pixen`, cost 1 each:
| File | Size | Seed | Job ID | Note |
|---|---|---|---|---|
| `window_recess_1811.png`, `window_recess_1812.png` | 80×132 transp. | 1811, 1812 | `3fb16620-6bf3-4bf2-b89b-da4aae0e71db`, `ed3f8164-dfd5-4274-b2a9-86296fb34e23` | rejected: no real depth, opaque glass |
| `window_wall_1821.png` | 96×144 opaque | 1821 | `f3b46218-7575-4329-a887-237f46a35231` | beige stone, rejected |
| `window_wall_1822.png` → `window_recessed.png` **(used)** | 96×144 opaque | 1822 | `439d5482-dfad-41a8-a162-af8152685835` | lilac masonry patch, deep reveal, sill on corbels; black opening made transparent, masonry cut to an oval with an ordered-dither edge by script; `window_recessed_view.png` = night view inside the openings |
| `cobwebs6_1813.png` → `web_*.png` | 384×96 transp. | 1813 | `83a4b29c-1116-4e82-ad5a-3ae4636c3d54` | cut into 7 (corner, hanging, round_big, torn, small, joint, sag), tinted lilac-grey, alpha ×0.72 |
Window-wall prompt (1821/1822): "a rectangular patch of rough dusty lilac-grey castle stone wall with one tall narrow gothic pointed arch window set deep into the middle of it, front elevation, flat front view: very thick wall, deep stone reveals stepping inwards on both sides and around the arch, heavy protruding stone windowsill, thin dark stone mullion and tracery, the frame casts soft shadows into the deep reveal, the window opening itself is pure flat black with nothing inside. + style block. Avoid: glass, sky, moon, curtains, perspective, wallpaper, glow."

Script work (0 generations): `box_v3.png` = box_1511 with the center niche cut into a dark passage (x 414–501, from the arch to the floor, dithered navy); contact shadows `shadow_window.png`, `shadow_drapes.png`, `shadow_torch.png` (dilated + blurred silhouettes, dark violet α≈0.5). Godot: `tests/cobweb_sway.gdshader` (whole-texel sideways sway growing from the anchor) + materials `cobweb_sway_{tl,tr,top}.tres`.

Scene `game/tests/hybrid_bedroom_v3.tscn` (instanced as `Bedroom` in `room_suite.tscn`): passage with half-tied drapes (457,199) — the old small arch removed; two recessed windows at x 362 and 548 (symmetric to the passage); two identical torches (`torch_unlit` + CPUParticles2D flame + PointLight2D) on the passage pillars (401, 513); bows at y 74; 6 cobwebs on real corners (room corners, vault gap, pillar/arch joint, between left-bay capitals) with sway materials; moon light on the floor under the windows, blue glow in the passage. Screenshot `bedroom_v3_assembled.png`.

**Sketch → rerender** (`create_image_pro`, 640×360, cost **25** each, 1 candidate): the only Tier 1 tool that takes a 640×360 reference; no strength control (influence set by the `usage` text). Sketch = in-game render of v3 without the hero, downscaled ×1/3 → `bedroom_v3_sketch.png` (`upload:3072b009-d489-4157-a372-d551e990206f`).
| File | Seed | Job ID | Reference / style |
|---|---|---|---|
| `rerender_a_1901.png` | 1901 | `ef546c87-5414-497d-a637-d5a95d6ebf20` | sketch, usage "layout and composition: keep the positions of walls, pillars, windows, curtains, torches and the passage, but redraw everything as one coherent painting"; style_image = `approved/room_princess_boudoir.png` |
| `rerender_b_1902.png` | 1902 | `a0b4bda3-47e1-4616-af4d-03c9bf3caf98` | sketch, usage "loose rough guide for where things are in the room; feel free to improve shapes, depth, lighting and integration" |
Prompt (both): "gothic vampire castle bedroom interior at night, diorama view of the back wall facing the viewer: on the left an empty bay with faded torn pink rose wallpaper between stone pillars and a wide empty floor area; on the right a dark open passage between two stone pillars closed by heavy burgundy velvet curtains on a rod, tied back halfway with gold tassels; two identical tall narrow gothic windows deeply set into thick stone walls with heavy sills, moonlit night sky with clouds and castle towers outside; two lit wall torches on the pillars flanking the passage; three small neat pink bows above the windows and the passage; dusty cobwebs in the upper corners; dark wooden plank floor. Cool lilac moonlight against warm torch light. + §4 style block. No people, no furniture."
Comparison: `bedroom_v3_rerender.png` (sketch | A | B). Both rerenders come out at 25 colors.

---

## 2026-10-18 — Hero 3/4 animations, bedroom v4, volumetric bows (not approved, except the pose)

Spent **62** (balance 1829 → 1767): step 1 = 7, step 2 = 52, step 3 = 3. Status: `pose_1802` **APPROVED** (as `approved/hero_pose_34.png`); poses 1801/1803 **REJECTED**; everything else pending review.

**0. Slippers fix** (0 gen): `pose34/pose_1802_fixed.png` = `pose_1802.png` with rows 57–63 (x 8–45) copied from `approved/hero_v7_a.png`; preview ×6 `pose34/hero_slippers_fix.png` (v7 a | 1802 | fixed).

**1. Hero animation** (`_incoming/hero_anim/v34/`), character `866a2fb0-794b-40be-8cd5-c99e3a9480c2` (`create_character` v3, reference `pose_1802_fixed.png` = `upload:d43fb180-5741-4f0b-b32c-ca403fc3c733`, 4 directions, view `low top-down`; description "young man with messy brown hair, slight smile, blue and white vertical striped button-up pajamas with matching trousers, blue soft slippers, adult proportions, relaxed three-quarter stance with one hand on the hip"). Cost 1. Rotations `rot/*.png` — south keeps the 3/4 pose.

| Animation | Mode | Group | Cost | Status |
|---|---|---|---|---|
| walk south/north/east (template `walking-6-frames`) → `walk_south_tpl/`, `walk_north/`, `walk_east/` | template | `ac76626e-c119-44de-8d6b-4872d624c3ab` | 3 | east used; south/north rejected (feet shuffle in place) |
| `walk_south_v3/` — "walking toward the viewer with clear alternating steps, each leg lifts and moves forward, arms swing slightly, relaxed", 6 frames | v3 | `6094891b-28f9-412b-9e67-b4e5b7c20df2` | 1 | used |
| `walk_north_v3/` — "walking away from the viewer with clear alternating steps, each leg lifts and moves forward, arms swing slightly, relaxed", 6 frames | v3 | `5c161e4c-a247-46a9-b6b8-2fb3c5fa5cef` | 1 | used |
| `idle_south/` — "standing relaxed in place, gentle breathing, chest rises and falls slightly, tiny head movement", 4 frames | v3 | `20897c5c-7617-4345-8302-fd2e24adce3b` | 1 | used |

v3 frames come on a 92×92 canvas; cropped to 64×64 with feet and body center aligned to the rotation (`raw_*.png` kept). Slipper colors checked in all used frames — not darkened, no recolor needed. West = east with `flip_h`. `emote_scratch_head` (from the previous character) on key **E**. Godot: `tests/hero_anim_frames.tres`, `tests/room_suite.gd`. Preview `v34/hero_walk.gif`.

**2. Bedroom v4** (`_incoming/rooms/bedroom_v4/`), `create_image_pro` 640×360, cost 25 each. Reference = `rerender_a_1901.png` (`upload:d39dd0e7-b359-429d-b556-c9d8f792e33c`, usage "room layout and composition: keep the walls, pillars, vaults, floor and the positions of the windows, torches and the central passage; apply the changes from the description"), style_image = `approved/room_princess_boudoir.png` (`upload:4f86cc5e-c24d-45f1-af69-841f92a833e5`).

| File | Seed | Job ID |
|---|---|---|
| `bedroom_v4_a_2001.png` (A, closer to the brief: dark arch) | 2001 | `876dd9da-4ea2-4656-85e1-aceea9b89a2a` |
| `bedroom_v4_b_2002.png` (B, wider arch with a grey-lit interior) | 2002 | `8b1a0370-310a-4c7d-97ab-ba0de792f69b` |

Prompt (both): "gothic vampire castle bedroom interior at night, diorama view of the back wall facing the viewer. Keep the room layout of the reference: on the left an empty bay with faded torn pink rose wallpaper between stone pillars and a completely empty wooden floor for a future bed; the left side wall may be visible. In the middle-right part a dark open pointed stone archway passage that starts at the floor, with soft cool moonlight glowing inside it, no curtains in the archway. Two identical tall narrow gothic windows on both sides of the archway showing the full moon and clouds, each window neatly framed by heavy burgundy velvet curtains on both sides, tied back, the curtains do not cover the glass. Two lit wall torches on the pillars beside the archway. Dusty cobwebs in the upper corners. The right edge of the image is open and continues into the next room, no right side wall. Dark wooden plank floor with moonlight beams from the windows. No bows, no ribbons, no furniture, no people, nothing on the floor. + §4 style block."

Live layers (pixen, 1 each): `sky_raw_2021.png` (256×160, seed 2021, job `25e6ab52-d1ac-4b5b-943c-56e50149fc07`; came with a window frame — inner part cropped to `sky_window.png` 190×134), prompt "night sky backdrop seen from a castle window: deep blue-violet night sky with soft dithered gradient getting lighter toward the bottom, a big bright full moon in the upper left area, a few small stars, distant dark silhouettes of gothic castle towers and spires along the bottom edge. + style. Avoid: clouds, window frame, interior, text."; `clouds_2022.png` (256×64 transparent, seed 2022, job `90a93f11-cb72-43d6-8c18-11faf37c701e`), prompt "a horizontal strip of soft wispy night clouds, pale lilac and blue-grey moonlit clouds with lighter rims, scattered across the strip, transparent gaps between the clouds. + style. Avoid: sky background, moon, stars, buildings."

Script work: glass made transparent by flood fill from seeds inside each lancet (`bedroom_v4_{a,b}_room.png`). Scene `game/tests/bedroom_v4.tscn`: SkyBG + SkyL/SkyR + scrolling Clouds (`tests/scroll_region.gd`) behind the room; particle flames + flickering PointLight2D (`tests/light_flicker.gd`) over the baked torches (400/515, 140); pulsing moon-beam light; arch glow; 2 swaying cobwebs; arch trigger (walk up into the arch → boudoir) in `room_suite.gd`. Screenshots `bedroom_v4_a.png`, `bedroom_v4_b.png`.

**3. Volumetric bows** (pixen 48×48 transparent, view `side`, cost 1 each) — status: **reserve** (owner decision; not used in scenes): on the pillars they still look pasted on (too saturated against the room; the 3/4 reads almost frontal); the front one above the arch is tolerable.

| File | Direction | Seed | Job ID | Note |
|---|---|---|---|---|
| `bow_front_2011.png` → `bow_front.png` | south | 2011 | `c8c64127-a29e-458a-9766-f3670ef9d17f` | good volume, folds, tails |
| `bow_34left_2012.png` → `bow_34left.png` | south-west | 2012 | `9cc5881d-3c45-4f53-8e66-d72826125b99` | the model drew a column too; bow cut out by saturation |
| `bow_34right_2013.png` → `bow_34right.png` | south-east | 2013 | `cf5ccfee-6e95-410e-a93e-cffe1fe11ad2` | ragged after cut-out; right pillar uses mirrored 34left |

Prompts: front — "one voluminous pink satin ribbon bow hanging on a flat wall, seen from the front: puffy rounded loops with soft fabric folds and creases, a knotted center, two long ribbon tails hanging down with a slight twist, soft drop shadow falling on the wall behind it, light from the upper left. + style. Avoid: flat icon, wall texture, background."; 3/4 — "one voluminous pink satin ribbon bow tied around a round stone column, seen in three-quarter view from the left (right): the bow turns away to the right (left) following the curve of the column, puffy loops with fabric folds, the near loop larger than the far loop, two long ribbon tails hanging down, soft shadow on the column, light from the upper left. + style. Avoid: column, background, flat icon." Contact shadows `shadow_bow_*.png` by script. Screenshot `bows_test.png`; the `BowsTest` node in `bedroom_v4.tscn` is hidden.

---

## 2026-10-18 — Hero cleanup, bedroom approved, dressing room v1

Spent **56** (balance 1767 → 1711): window view 2, dressing shell 2, gate 2, dressing rerender 50. Hero cleanup 0.

**Hero cleanup** (0 gen, script `_incoming/hero_anim/v34/clean/hero_cleanup.py`): for each direction the head of one best frame (idle 0, walk_south 2, walk_north 0, walk_east 0) is fixed (stray orange pixels in the left hair → hair color; ear on south/idle redrawn as 1×2 skin + outline) and transplanted into every frame at the frame's bob offset; detached fist removed in walk_east frames 1 and 4. Output `clean/<anim>/<i>.png`, sheets `clean/hero_<anim>.png` + `clean/hero_<anim>.aseprite` (Aseprite CLI). Compare `hero_cleanup_compare.png` (before/after, ×6); `hero_walk.gif` rebuilt from clean frames. Status: pending review (not in approved/).

**Bedroom — APPROVED** (variant A, `bedroom_v4_a_2001.png`): left mullion restored from A (x 342–349); window view replaced by a tower view; cool fill light on the empty left bay (`Lights/LeftFill`, #8fa6e8, energy 0.35). Approved files listed in the table above. Screenshot `rooms/bedroom_v4/bedroom_final.png`. Variant B `bedroom_v4_b_2002.png` — rejected.

Window view (pixen 256×160, cost 1 each), prompt: "night view from a high castle tower window, filling the whole image edge to edge: deep blue-violet night sky with a soft dithered gradient, a big bright full moon in the upper left, a few small stars, far below dark silhouettes of crenellated castle battlements and pointed slate tower roofs along the bottom, beyond them a distant dark forest on the horizon line with faint mist. + style. Avoid: window frame, curtains, interior, walls around the view, lit windows, houses, clouds, text."
| File | Seed | Job ID | Status |
|---|---|---|---|
| `view_tower_2101.png` | 2101 | `a36dc3b2-0c9e-4e7c-b794-6725102de724` | rejected (drew a window frame, lit windows) |
| `view_tower_2102.png` → `approved/window_view_tower.png` | 2102 | `ebf7a5e7-e2fd-4e05-857a-0413b9db0b16` | approved (curtain edges cropped, lit windows painted out) |

**Dressing room v1** (`_incoming/rooms/dressing/`), pending review.
Sketch pieces (pixen, cost 1 each):
| File | Seed | Job ID | Note |
|---|---|---|---|
| `shell_2111.png` | 2111 | `85d52758-f8b2-4af5-ad5f-4cc2a432cc38` | rejected (stairs, curtain) |
| `shell_2112.png` | 2112 | `3d239d00-b109-42a0-9d28-1a2a983e5c6c` | used as sketch base (open left, side wall right) |
| `gate_2121.png` | 2121 | `99d51ffa-e38f-4699-a503-75684c39d60d` | used: gated spiral staircase with padlock |
| `gate_2122.png` | 2122 | `77167e87-0ea9-41f6-a912-a9eed6ae4009` | rejected (open wooden door, ivy) |
Shell prompt: "bare empty stone room shell in a gothic castle, unfurnished, diorama view, back wall facing the viewer straight-on with dusty lilac-grey stone pillars and faded torn pink rose wallpaper panels, dark wood wainscoting, dark wooden plank floor with depth in the lower third, vaulted ceiling edge at top, a solid stone side wall on the RIGHT edge of the image, the LEFT edge of the image is open and continues into the next room with no side wall, plain bare walls and plain bare floor, soft even ambient light. + style. Avoid: bed, furniture, wardrobe, desk, table, chair, curtains, windows, doors, arches, stairs, bows, ribbons, candles, torches, glow, characters, text, blurry, photorealistic." Gate prompt: "a doorway in a castle wall standing on the floor, front elevation: a pointed gothic stone arch frame of clean cut lilac-grey stone, through the opening a dark stone spiral staircase winding upward is visible, the opening is closed by a black wrought iron gate with vertical bars and curled scrollwork, a heavy old iron padlock hangs on the gate, flat even lighting. + style. Avoid: ivy, plants, wooden door, perspective, background, glow."
Sketch `dressing_sketch.png` = shell_2112 + window_narrow + view + drapes_1613 + gate_2121 + 2 torches.

Rerender (`create_image_pro` 640×360, cost 25 each), reference = sketch (`upload:a6d77839-8012-45cf-be73-48bb821c8270`, usage "room layout and composition: keep the walls, pillars, vaults, floor and the positions of the window with curtains, the two torches and the gated staircase doorway; redraw everything as one coherent painting"), style_image = boudoir (`upload:9668c9da-4821-4322-90fa-39bbc64d8ca2`).
| File | Seed | Job ID | Note |
|---|---|---|---|
| `dressing_v1_a_2201.png` | 2201 | `81d08ecf-7a22-4286-b42b-1ca6d96f7c6b` | 3 torches (one extra on the left pillar), bright window, gate on the right |
| `dressing_v1_b_2202.png` | 2202 | `82e270f6-28b2-4db3-8cff-c77e3150209c` | 2 torches as asked, window with moonbeam on the floor, gate on the right; darker, closer to the bedroom |
Prompt (both): "gothic vampire castle dressing room interior at night, diorama view of the back wall facing the viewer. Keep the room layout of the reference. The LEFT edge of the image is open and continues into the next room, no left side wall; a solid stone side wall closes the RIGHT edge. In the right part of the back wall a pointed stone doorway standing on the floor, about one and a half times the height of a person, through it a dark stone spiral staircase winds upward, the doorway is closed by a black wrought iron gate locked with a heavy old padlock. The middle of the back wall between two stone pillars is a large empty wall space for a future wardrobe and writing desk. On the left part of the back wall one small gothic window showing the moonlit night sky, neatly framed by burgundy velvet curtains tied back on both sides. Two lit wall torches mounted symmetrically on the two pillars. Faded torn pink rose wallpaper, dusty lilac-grey stone, dark wood wainscoting, dark wooden plank floor, a few cobwebs in the upper corners. No bows, no ribbons, no furniture, no people, nothing on the floor. Cool lilac moonlight against warm torch light. + §4 style block."
Live layers: glass cut out (`dressing_v1_{a,b}_room.png`), shared tower view + clouds behind, particle flames + flickering lights over the baked torches, pulsing moonbeam, 2 swaying cobwebs. Scenes `tests/dressing_v1_a.tscn`, `tests/dressing_v1_b.tscn` (room_suite currently uses B). Screenshots `dressing_v1_a.png`, `dressing_v1_b.png`.
