# ASSETS — asset registry

Source of every asset: tool, prompt, parameters, cost. Needed for the AI-generation disclosure on Steam (see `docs/ART_PIPELINE.md` §7).

Cost is in PixelLab Tier 1 subscription generations (2000/month, resets on the 18th).

`game/assets/_incoming/` is git-ignored; approved style references will be committed separately.

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

### Hero, adult, front view
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
| `count_adult_front_a.png` | view `low top-down`, seed 621 | `e4a7cc78-4f9d-41d7-af28-1950e7f97d6a` | 1 |
| `count_adult_front_b.png` | view `side`, seed 622 | `a46317f1-6d3d-443c-a96b-babf2b55cab8` | 1 |

### Notes
- Figure height (alpha bbox): hero 61/61 px, count 58/59 px — taller than the 52–56 px target; needs ~4–6 px of downscale/crop or a smaller prompt-side figure.
- Colors: hero 60/54, count 72/55 (limit ~24) — palette reduction required.
- Proportions: closer to adult than rounds 1–2, but heads are still ~1:3.5, not 1:5. Count a is effectively chibi (big head, short legs); count b is the closest to the brief (hunched, bony, long limbs).
