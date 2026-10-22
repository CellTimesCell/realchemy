# ASSETS — asset registry

Source of every asset: tool, prompt, parameters, cost. Needed for the AI-generation disclosure on Steam (see `docs/ART_PIPELINE.md` §7).

Cost is in PixelLab Tier 1 subscription generations (2000/month, resets on the 18th).

`game/assets/_incoming/` is git-ignored. Approved assets are copied to `game/assets/approved/` and committed.

## References
| File | Source | Use |
|---|---|---|
| `docs/reference/bedroom_ref_alexander.png` | **Alexander, his own generation** (21.10.2026) | style / composition reference for bedroom props (may be fed to generators; ART_PIPELINE §3.4) |

## Approved (`game/assets/approved/`)
| File | Source | Role | Note |
|---|---|---|---|
| `count_adult_front_b.png` | `_incoming/style_test/round3/count_adult_front_b.png` | Count, front view; **style reference for all characters** | |
| `hero_v7_a.png` | `_incoming/style_test/round6/hero_v7_a.png` | Hero base, front view | light slightly cooler than the count — align at T-26 |
| `room_princess_boudoir.png` | `_incoming/rooms/princess_chamber/pano_center_a.png` | Boudoir — center room of the princess suite | **legacy** (21.10.2026): enfilade background, used in `princess_suite.tscn` until the one-room-per-screen rooms replace it |
| `hero_pose_34.png` | `_incoming/hero_anim/pose34/pose_1802_fixed.png` | Hero base pose: 3/4, lowered arm, slippers recolored to v7 a (rows 57–63 copied from `hero_v7_a.png`) | animations not yet approved |
| `room_princess_bedroom.png` | `_incoming/rooms/bedroom_v4/bedroom_v5_room.png` (rerender A 2001; v2: whole window openings cut, tracery moved to its own layer) | Princess bedroom (left room of the suite) | live layers: `window_view_tower.png`, `window_clouds.png` + flames/lights in scene |
| `window_view_tower.png` | `_incoming/rooms/bedroom_v4/view_tower_2102.png` (center crop, lit windows painted out) | Shared window view for all suite windows | |
| `window_clouds.png` | `_incoming/rooms/bedroom_v4/clouds_2022.png` | Scrolling cloud strip behind window glass | |
| `hero/` | `_incoming/hero_anim/v34/clean/` (+ `emote_scratch_head/`) | Hero animations: idle_south, walk_south/north/east (west = flip), emote_scratch_head; `hero_frames.tres` SpriteFrames; sheets `hero_*.png` + `.aseprite` | cleaned by `tools/anim_cleanup.py` (head lock, ear removed) |
| `room_princess_bedroom_tracery_{l,r}.png` | from `bedroom_v4_a_2001.png` | Window tracery layers of the bedroom (sky → tracery → room) | |
| `room_princess_dressing.png` | `_incoming/rooms/dressing/dressing_v1_b_2202.png` + inpaint 2401, glass cut, pink wall dimmed ~30% | Dressing room (right room of the suite) | |
| `room_princess_dressing_tracery.png` | from the same | Dressing window tracery layer (1px stone mullion) | |
| `room_princess_{bedroom,boudoir,dressing}_pillar.png` | crops of the front pillar (rows 140–360) | Foreground occluders drawn over the hero | |
| `fx/web_*.png` | `_incoming/rooms/hybrid_bedroom/` | Cobweb sprites for the sway shader | |
| `props/bed_princess.png` + `bed_princess_blanket.png`, `bed_princess_shadow.png`, `nightstand_candle.png` | `_incoming/props/bed/bed_2302_3.png` (blanket on the floor split off as a lower layer, rows 137–151) | Princess bed (variant B) | frame collides, blanket has no collision |
| `hero/emotions/{cheer,facepalm,notice,disgust,thinking,dizzy}/` | `_incoming/hero_emotions/clean/` | Hero reaction animations (south), in `hero/hero_frames.tres` as `react_*` | approved 19.10.2026; `startled` is still in `pending/hero/startled/` |
| `characters/ghost_grandma/emotions/{idle,lecture,angry,startled,thinking,facepalm}/` + `ghost_frames.tres` | `_incoming/characters/ghost_v2/anim/clean/` | Ghost grandma animations; look = `shaders/ghost.gdshader` v2 | approved 19.10.2026 |
| `ui/emotes/<icon>/` + `emote_frames.tres`, `source/` | `_incoming/emotes/frames_a/`, `style_a/` | Manpu icons, style A (white + dark outline; colour only by meaning: anger red, sweat light blue). Drawn on `EmoteLayer` above the night tint | approved 19.10.2026; style B rejected |
| `hero/emotions/startled/` | `_incoming/hero_emotions/clean/startled/` + landing (frames 5–7 = 2, 1, 0) | Hero startled with landing | approved 19.10.2026 |
| `props/boudoir/{birdcage,birdcage_bars,orange_tree,harp,vanity}.png` | birdcage_2701_0, orange_tree_2711_0, harp_2721_0, vanity_2731_2 (b) | Boudoir furniture | approved 19.10.2026; other variants rejected; harp and vanity scale kept |
| `props/boudoir/canary/` + `canary_frames.tres` | canary_2743 + preen / alarm | Canary (sit, preen, alarm) | approved 19.10.2026 |
| `hero/interact/{interact_low,interact_mid}_{south,east}/` | `_incoming/hero_interact/clean_*` | Hero interaction poses | approved 19.10.2026 (interact_high redone, in pending) |
| `props/{wardrobe,secretary}_princess_ajar.png` | edit from closed | Half-open state (3 states) | approved 19.10.2026 |
| `hero/interact/interact_high_{south,east}/` | v2 (tiptoes) | Hero reaching up | approved 19.10.2026 |
| `props/nightstand_drawer_{closed,open}.png` | padded + edit | Nightstand closed / drawer out | approved 19.10.2026 |
| `room_princess_bedroom.png` (v3) | approved bedroom + 2 inpaints (wall instead of the side door; curtains + small door in the arch) | Bedroom | approved 19.10.2026 (the old version is in git history) |
| `props/garderobe_arch_{ajar,open}.png` | edits of the arch crop | Arch door states | approved 19.10.2026 |
| `rooms/garderobe/garderobe_bg.png`, `hand_{point,grab}.png` | garderobe a, hand cursor | First-person garderobe | approved 19.10.2026; b rejected |
| `props/{painting_count(+_eyes),painting_madam,tiger_skin_rug,bedside_rug,chest(+_ajar,_open),folding_screen,harp34,x_chair,plush_bear,cello,oval_rug,still_life,dress_form,laundry_basket,full_length_mirror,worn_rug,coat_stand}.png` | suite furniture picks (a/b per Alexander) + fixes: portrait regenerated 60×72, tiger regenerated 136×56, bedside rug b muted, basket b darker | Suite furniture | approved 19.10.2026; other variants rejected |
| `bg_mortar_closeup_v3.png` | `_incoming/style_test/round2/bg_mortar_closeup_v3.png` | Close-up reference: rendering and light | **sleeves must be redone** (pink bathrobe → striped pajamas) |

| `rooms/garderobe/posters/poster_*.png`, `nail.png`, `tape.png`, `toilet_paper.png` | posters v2 + fixtures + holder on a bracket | First-person garderobe v3 | approved 20.10.2026 |
| `props/boudoir/{music_stand,sheet_music,floor_candelabra}.png` | batch 8 pixen | Boudoir music corner (stand, 3 sheets, 5-candle candelabra) | approved 20.10.2026 |
| `props/painting_madam.png` | — | **reserve** (removed from the bedroom 20.10.2026; only the Count stays, in the arched niche) | not in the scene |
| `room_princess_bedroom.png` (v4) | v3 + pointed-arch garderobe door (inpaint batch 9) | Bedroom | approved 20.10.2026 (older versions in git history) |
| `props/garderobe_door_v3_{ajar,open}.png`, `props/garderobe_sign.png` | batch 9 | Pointed garderobe door states, plaque on a chain | approved 20.10.2026 |
| `props/{bedside_rug_v2,folding_screen_v2}.png` | batch 9 (a) | Bedroom rug with border and fringe, folding screen ~65 px | approved 20.10.2026; b rejected |
| `props/boudoir/{gramophone,record_crate}.png` | batch 9 (a) | Boudoir music corner | approved 20.10.2026; b rejected |
| `props/study/{telescope,globe}.png` | batch 9 | Princess study | approved 20.10.2026 |
| `props/boudoir/floor_candelabra.png` | — | **reserve** (removed from the boudoir 20.10.2026: cut off by the frame at the pillar) | not in the scene |
| `props/study/bookcase.png` | batch 10 (a, #0) | Tall gothic bookcase 42×96, study back wall left | approved 20.10.2026; b rejected |
| `props/trophies/trophy_{griffin,unicorn,dragon}.png` | batch 10 (a: #0 / #16 / #12) | Trophy heads, masters (the scene uses the 75 % wall copies in `pending/`) | approved 20.10.2026; b rejected |
| `props/boudoir/{chandelier,chandelier_fallen}.png` | batch 10 (a, #0 + edit) | Boudoir chandelier: hanging / fallen | approved 20.10.2026; b rejected |
| `items/{ball,key,crystal_prism}.png` | batch 10 pixen | Item sprites / icons | approved 20.10.2026 |

## Pending review (`game/assets/pending/`, tracked, not approved)
Rule (CLAUDE.md §5.12): in git, used by scenes, waiting for an OK; on approval → `approved/`, rejected → `_incoming/rejected/` (out of git).

| File | What |
|---|---|
| `pending/props/dressing_gate.png` | gate bars cut from the dressing room (rattles) |
| `pending/suite/workbench.png` (a) 103×69, `workbench_b.png` 102×67 | large alchemist workbench (batch 10 pass 2), study back wall under the window; replaces the small lab table (rejected) |
| `pending/props/trophy_dragon_large.png` 62×72 (a), `_b` 65×69 | large dragon head between the dressing-room torches (batch 11); griffin and unicorn use the approved masters at native size |
| `pending/rooms/room_princess_bedroom_v5.png` | bedroom with the garderobe door re-inpainted crisp (only the door leaves) |
| `pending/props/garderobe_door_v4_{ajar,open}.png` | door states edited from the new closed door (changed pixels inside the door frame only) |
| `pending/rooms/room_princess_boudoir_v2.png` | boudoir without the pink bow above the middle window (inpaint of that patch only) |
| `pending/props/count/{painting_count_eyes_v2,count_lids,count_yawn}.png` | portrait: crisper eyes (3×2 whites + 1 px pupil), eyelids 2 frames, yawn mouth 3 frames (changed face pixels only) |
| `pending/creatures/{bat_fly,mouse_run,spider}.png` | bat 5-frame flap strip 24 px, mouse 4-frame run strip 20 px, spider 14×15 |
| `pending/props/dressing_gate_open.png` 38×84 | open gate: the arch kept, the opening filled with darkness (flood-fill from the stone edge), a 3 px strip of the leaf at the hinge — no generation (the bars are painted into the room picture) |
| `pending/props/boudoir/chandelier_fallen_empty.png` 75×49 | the wreck with the prism pixels cleared (after the prism is taken) — no generation |
| `pending/props/garderobe_sign_wide.png` 46×33 | approved plaque widened by 9-slice (no new art) so "OUT OF / ORDER" fits at native font size |

Reserve (out of git): `_incoming/reserve/bookcase34.png` (foreground 3/4 bookcase, removed from the study).

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

---

## 2026-10-18 — Fixes, approvals, princess suite scene, bed test

Spent **37** (balance 1711 → 1674): bed 15 + 15, nightstand 1, dressing inpaint 6.

**APPROVED this session:** hero animations (`approved/hero/`), bedroom v2 with tracery layers, dressing room (variant B, fixed). Variant `dressing_v1_a_2201.png` — rejected.

**0a Hero ear** (0 gen): `tools/anim_cleanup.py` now removes the ear completely on south/idle (everything right of the face outline in the ear rows, outline column closed) and turns the pale ear patch of the profile into hair. `fix_hero_ear.png` (before/after pairs ×6), `hero_cleanup_compare.png` rebuilt.

**0b Bedroom windows** (0 gen): 1-bit glass by flood fill from seeds inside each lancet and the rose, bounded by the frame columns; frame highlights touching the dark outline are kept. Tracery/mullions/curtains inside the window rect moved to `bedroom_tracery_{L,R}.png` (at 331,64 / 539,64), the room image has the whole rect cut. Order sky → tracery → room. `fix_bedroom_window.png`, `bedroom_final_v2.png`.

**0c Dressing window**: glass 1-bit by geometry (two lancets + cross), mullion redrawn as outline | 1px stone | outline; tracery layer `dressing_tracery.png` (at 84,118). Light dithered stone patch under/around the window replaced by inpaint:
| File | Tool | Seed | Job ID | Cost |
|---|---|---|---|---|
| `patch_out_2401.png` | `inpaint_image_pro_flash`, crop 160×160 at (40,92), custom mask `patch_mask.png` (patch pixels only, curtains and window excluded), output "Modify current layer" | 2401 | `99659c21-0743-4696-aeed-b8308f7b7ad2` | 6 |
Prompt: "plain smooth dusty lavender plaster wall continuing seamlessly from the surrounding wall, same colors and soft shading as the wall around the window, below the stone window sill; no exposed light stone masonry, no checkered dithering, no bricks". Pink wall between the right columns dimmed ~30% by script; dressing torch lights 1.2 → 0.9. Curtains left as they are (narrowing would break the wall behind them). `fix_dressing_window.png`, `dressing_final.png`.

**Princess suite scene** `game/scenes/rooms/princess_suite.tscn` (generated): Background (sky + tracery + room images), LiveLayers (flames, cobwebs), Props (y-sorted), Hero (`components/hero.gd`, CharacterBody2D with a 14×6 feet shape), Foreground (pillar occluders, z_index 1), Walls (floor bounds per room, pillar bases), Camera, Night, Lights.

**Bed test** (`_incoming/props/bed/`, not approved). `create_image_pro` 168×152 transparent, style_image = bedroom (`upload:040aa6dd-5ebf-4eef-b7bb-93dd85fd2e9b`), 4 candidates per call, cost 15.
| Batch | Seed | Job ID | Prompt | Result |
|---|---|---|---|---|
| `bed_2301_{0..3}.png` | 2301 | `90aa4d13-54e3-47a5-853b-91388929ccf6` | owner's prompt: "ornate gothic canopy bed of a fairy-tale princess, dark carved wood, faded pink bedding with ruffles, heavy burgundy canopy drapes tied back, slightly messy, a few pillows; same diorama camera as the room (front view slightly from above), same lighting as the bedroom, transparent background, no floor, no characters. The bed fills most of the canvas width; canopy posts reach the top." | rejected: all four in isometric 3/4 |
| `bed_2302_{0..3}.png` (index 3 = B **APPROVED** → `approved/props/bed_princess.png`; 0 = A and 2 = C **REJECTED**) | 2302 | `ad6834d5-8961-453e-ab0c-17a80e9a5d5e` | "ornate gothic canopy bed of a fairy-tale princess seen strictly from the front, perfectly symmetrical, flat front view slightly from above: the tall carved headboard against the back wall in the middle, the bed and its ruffled foot end facing straight toward the viewer, four carved dark wood posts, heavy burgundy canopy drapes tied back at both front posts, faded pink bedding with ruffles, slightly messy, a few pillows. The bed fills the whole canvas edge to edge. Same lighting as the bedroom. Transparent background, no floor, no characters, no isometric angle." | frontal; a = index 0, b = index 3, c = index 2 |
Nightstand: `nightstand_2311.png` → `nightstand.png` (flame pixels removed), pixen 32×40, seed 2311, job `17abf558-85c2-4a3d-8e27-ecd9e3124af3`, cost 1, prompt "small gothic dark carved wooden nightstand with a single short white candle in a brass holder on top, unlit candle, front view slightly from above, flat even lighting, no glow, no flame. + style. Avoid: fire, flame, glow, floor, wall, background." Contact shadow `bed_shadow.png` (script, stepped alpha).
Test scenes `tests/princess_suite_bed_{a,b,c}.tscn`; screenshots `bed_v1_a.png`, `bed_v1_b.png`, `bed_v1_c.png`, `bed_in_room.png`.

---

## 2026-10-18 — Idle fix, bed approved, garderobe design, fonts, wardrobe + skeleton

Spent **31** (balance 1674 → 1643): wardrobe 15, skeleton 10, open wardrobe 6 (a second open-wardrobe edit, seed 2521, failed under load — not charged).

**Hero idle** (0 gen): head and neck locked; `tools/anim_cleanup.py` now locks 19 rows (head + neck) and builds idle from one frame: 2 rest + 2 inhale (collar-to-belt rows +1 px), 2.5 fps (~1.6 s cycle). Compared with whole-sprite bob (`v34/idle_fix/{chest,whole}`, `hero_idle_fix.gif` / `.png`); chest variant chosen. `approved/hero/` updated. walk_south re-checked (no double chin with neck locked).

**Bed B approved** — see the bed table above. Screenshot `_incoming/props/bed/bed_final.png`.

**Window view** (0 gen): small left tower and the frame strip at the left edge painted over with sky/forest in `approved/window_view_tower.png` (rebuilt from `view_tower_2102.png`).

**Fonts** (0 gen): Press Start 2P, Pixelify Sans, Tiny5 — all SIL OFL 1.1, see ART_PIPELINE §6 / TOOLING §4.10. Screenshots `_incoming/fonts/font_test_{1,2,3}.png`. Status: pending.

**Wardrobe + skeleton** (`_incoming/props/wardrobe/`), pending review. style_image = dressing room (`upload:182fb637-93d5-4e77-a6ad-b2b6c7dd43fe`).
| File | Tool | Seed | Job ID | Cost |
|---|---|---|---|---|
| `wardrobe_2501_{0..3}.png` (a = 0, b = 1, c = 3) | `create_image_pro` 112×152, 4 candidates | 2501 | `9bffa212-2140-4bf6-88ca-bda0ccb24c98` | 15 |
| `skel_2511_{0..15}.png` (a = 0, b = 3) | `create_image_pro` 48×64, 16 candidates | 2511 | `93116553-020f-48e8-a300-d4d609d2df10` | 10 |
| `wardrobe_open_2522.png` | `edit_image_pro_flash` from `wardrobe_2501_0.png` (`upload:52d29689-228e-4ee2-9354-39328eebb999`) | 2522 | `d6cffbab-7b4a-40ba-aa97-52a44701de39` | 6 |
Prompts: wardrobe — "large ornate gothic wardrobe, dark carved wood, two tall closed doors, faded pink painted flowers on the doors, slightly dusty, seen strictly from the front, symmetrical, flat front view slightly from above (same diorama camera as the room), same lighting as the dressing room, transparent background, no floor, no characters, no isometric angle. The wardrobe fills the canvas from top to bottom."; skeleton — "a funny cartoon skeleton of an old princess standing upright, not scary, no blood, comedic: tattered faded pink ball gown hanging on the bones, a small tilted golden crown on the skull, big round empty eye sockets with a surprised and offended expression, one bony hand on the hip, seen from the front, same lighting as the dressing room, storybook pixel art, transparent background, no floor."; open — "the same wardrobe with both doors swung wide open to the sides, showing the dark interior: a few old faded dresses on hangers at the left and right sides inside, the center of the interior is empty and dark. Keep the same wardrobe frame, carvings, colors, size, outline and lighting."
Scene: `components/openable_prop.gd` (closed/open textures, inside node shown when open, Enter in the hotspot opens), wardrobe at (1738, 312) in the dressing room: shadow, y-sort, collision 84×14 at the base, hotspot «Открыть», skeleton as a separate node. Test scenes `tests/wardrobe_closed_{a,b,c}.tscn`, `tests/wardrobe_open_skel_{a,b}.tscn`. Screenshots `wardrobe_closed_{a,b,c}.png`, `wardrobe_open.png`, `skeleton_{a,b}.png` (×6 sprite + in the wardrobe), `wardrobe_in_room_{closed,open}.png`.

---

## 2026-10-19 — Wardrobe approved, lying skeleton, ghost grandmother, secretary + letter

Spent **36** (balance 1643 → 1607): lying skeleton 10, ghost 10, secretary 10, open secretary 5, parchment 1.

**Wardrobe** — `wardrobe_2501_0` (a) **APPROVED** → `approved/props/wardrobe_princess_closed.png`, `wardrobe_open_2522` → `wardrobe_princess_open.png`, `wardrobe_shadow` → `wardrobe_princess_shadow.png`. `wardrobe_2501_1` (b), `wardrobe_2501_3` (c) **REJECTED**. Standing skeletons `skel_2511_*` (both a/b) **REJECTED**.

**Fonts** — Press Start 2P **APPROVED** → `game/assets/fonts/press_start_2p/` (+ `OFL.txt`); Tiny5 **RESERVE** (candidate for long text, stays in `_incoming/fonts/tiny5/`); Pixelify Sans **REJECTED**.

All new generations below: **pending** (not in approved/).
| File | Tool | Size | Seed | Job ID | Cost | Note |
|---|---|---|---|---|---|---|
| `_incoming/props/wardrobe/skel_lying_2601_{0..15}.png` | `create_image_pro`, style = dressing room (`upload:9d43bf16-0e7e-4ee1-9fdf-0b594de7f6f5`) | 64×48 ×16 | 2601 | `c44780dc-56ec-418c-9c1a-cf5fa23c27ec` | 10 | a = 0, b = 2 |
| `_incoming/characters/ghost/ghost_2611_{0..15}.png` | `create_image_pro`, style = `count_adult_front_b` (`upload:64772fd7-ff08-47c2-b3f2-e87b8f52aaa1`) | 64×64 ×16 | 2611 | `dfccc763-6fb4-4970-8b36-915a0e48b2d3` | 10 | a = 0, b = 7, c = 11 (`ghost_{a,b,c}.png`) |
| `_incoming/props/secretary/secretary_2621_{0..3}.png` | `create_image_pro`, style = dressing room | 80×96 ×4 | 2621 | `d1cad0c3-f1f7-447a-a553-22bdd4af29d7` | 10 | a = 0, b = 1, c = 3 |
| `_incoming/props/secretary/secretary_open_2641.png` | `edit_image_pro_flash` from `secretary_2621_0` (`upload:7c1aa3e6-f87d-41bb-becd-2cf752aff948`) | 80×96 | 2641 | `c0be970a-8ba9-4789-a9fd-656a8df0240f` | 5 | |
| `_incoming/rooms/letter_parchment_2631.png` | `create_image_pixen` | 256×192 | 2631 | `0614cbbf-d01c-40fb-b3c3-eaf80a4947f5` | 1 | blank parchment, text is drawn by the font |

Prompts:
- lying skeleton — "cartoonish skeleton lying slumped at the bottom of an open wardrobe among old dresses, wearing a tattered faded pink ball gown, skull tilted to one side, dusty, not scary, no blood, same diorama camera (front, slightly from above), same lighting as the dressing room, transparent background. Only the slumped skeleton in its gown and a few fallen dresses, no wardrobe frame."
- ghost — "elderly fairy-tale princess grandmother, small crown on grey hair in a bun, voluminous old-fashioned ball gown, grumpy but kind wrinkled face, floating pose with the gown hem drifting, adult proportions (not chibi), 3/4 view, full figure, transparent background." (opaque sprite; ghostliness via `shaders/ghost.gdshader`)
- secretary — "small ornate gothic writing desk (secretary) with a fold-down lid closed, dark carved wood, tiny drawers, a dried-up inkwell and a quill on top, a stack of old letters tied with a faded pink ribbon on top, dusty, seen strictly from the front, symmetrical, flat front view slightly from above (same diorama camera as the room), same lighting as the room, transparent background, no floor, no characters, no isometric angle."
- open secretary — "the same writing desk with the slanted fold-down lid opened down flat into a writing surface, inside are small pigeonhole compartments with rolled papers and scattered old letters lying on the open lid. Keep the same desk body, drawers, inkwell and quill, colors, size, outline and lighting."
- parchment — "a single sheet of old yellowed parchment paper seen flat from the front, slightly curled corners, faint stains and a small pink wax seal at the bottom, completely blank with no writing, soft even lighting."

Screenshots: `skeleton_lying_{a,b}.png`, `wardrobe_open_with_skeleton.png` (props/wardrobe); `ghost_raw_{a,b,c}.png`, `ghost_in_room.png` (= a), `ghost_in_room_{b,c}.png` (characters/ghost); `secretary_{a,b,c}.png`, `secretary_open.png`, `secretary_in_room.png`, `letter_screen_press_start.png`, `letter_screen_tiny5.png` (props/secretary).

---

## 2026-10-19 (2) — Skeleton and secretary approved, letter, ghost v2

Spent **6** (balance 1607 → 1601): ghost v2, 3 × `create_character` v3 = 2 each.

**Approved:**
- `skel_lying_2601_0` (a) → `approved/props/skeleton_princess_lying.png`; `skel_lying_2601_2` (b) **REJECTED**.
- `secretary_2621_0` (a) → `approved/props/secretary_princess_closed.png`, `secretary_open_2641` → `approved/props/secretary_princess_open.png`; `secretary_2621_1` (b), `secretary_2621_3` (c) **REJECTED**.
- `letter_parchment_2631` → `approved/ui/letter_princess.png`. Letter font: Press Start 2P (Tiny5 for letters **REJECTED**).

**Ghost v1** — `ghost_2611_*` (a/b/c) **all REJECTED**: mush at small scale, face and crown unreadable (image 384 + style reference).

**Ghost v2** (`_incoming/characters/ghost_v2/`), **pending**. Tool: `create_character` mode `v3`, size 64, view `low top-down`, outline `single color outline`, detail `high detail`, no reference (8 directions come with it). Cost 2 each.
| Variant | Character ID | Figure height |
|---|---|---|
| a | `1f0c9d71-e969-423a-ac7e-1a72f77ca386` | 62 px |
| b | `94ea04ee-a8e7-44c0-8ad5-1203e084a4eb` | 60 px |
| c | `238ea9d6-d5bd-45ae-991d-7a432a1c80ea` | 62 px |
Description: "elderly princess grandmother, adult realistic proportions (not chibi, head about 1/6 of height), clearly visible small golden crown on white hair in a bun, voluminous old-fashioned pink-lilac ball gown with puffed sleeves and white lace collar, grumpy but kind wrinkled face, one finger raised as if lecturing, other hand on hip, standing upright, 3/4 view, full body filling the canvas height".
Files: `ghost_v2_{a,b,c}_south.png`, `ghost_v2_{a,b,c}_south-east.png`, `ghost_v2_{a,b,c}.png` (= south). Screenshots: `ghost_v2_compare.png` (×6 next to the hero and the count), `ghost_v2_in_room.png` (a with `shaders/ghost.gdshader`). Test scenes `tests/ghost_v2_{a,b,c}.tscn` (not committed).

Screenshot: `_incoming/props/secretary/letter_final.png` (letter with margins, hotspot prompts hidden).

---

## 2026-10-19 (3) — Ghost grandma approved, shader v2, emotions, emotes

Spent **34** (balance 1601 → 1567): 13 animations × 1, 21 emote icons × 1 (18 for two styles + 3 re-rolls). Budget proposed: ≤ 50.

**Ghost grandma** — `ghost_v2_a` (`1f0c9d71-e969-423a-ac7e-1a72f77ca386`) **APPROVED** → `approved/characters/ghost_grandma/{south,south-east,east,north-east,north,north-west,west,south-west}.png` + `ghost_frames.tres` (idle = south). `ghost_v2_b` **REJECTED**, `ghost_v2_c` **RESERVE**. Shader `shaders/ghost.gdshader` v2: opacity 0.55, tint 0.8 green, rim light, 2 px halo, hem fade over the bottom 10 px (`fade_end` = UV.y of the hem: 1.0 on a 64 canvas, 0.8636 on the 88 animation canvas). Screenshot `_incoming/characters/ghost_v2/ghost_shader_v2.png`.

**Emotion animations** (pending): `animate_character` mode `v3`, direction south, 1 generation each. Raw frames in `raw/`, cleaned by `tools/emotion_cleanup.py` into `clean/` (no face lock).

| Character | Animation | Frames | Group | Action description |
|---|---|---|---|---|
| ghost | idle | 6+1 | `703b4667-6a68-42b7-9541-cfd68001d18a` | floating gently in place with arms folded across the chest, then briefly lifting one hand to straighten the small crown on her head, grumpy face |
| ghost | lecture | 4+1 | `3a0663f8-e3e2-484a-ab0f-f5708ea40503` | sternly wagging her raised index finger as if lecturing, head nodding slightly, standing in place |
| ghost | angry | 6+1 | `cdd0b1fd-98ef-4e88-a6ee-c612bafdb3be` | furious, angrily waving both arms up and down and stamping her feet in the air, angry face, staying in place |
| ghost | startled | 4+1 | `de3fdb53-2331-4eec-a1a0-34433bb7739a` | startled, jumps up in fright with both arms thrown up in the air, eyes wide open, then lands back in place |
| ghost | thinking | 4+1 | `8f719057-877b-41db-b7dc-94370fa8a6f0` | thinking, one hand raised to her chin, slowly tilting her head from side to side, standing in place |
| ghost | facepalm | 4+1 | `4341a2b7-3581-4fda-abb0-7fac5dd8da6e` | exasperated facepalm, raises one hand and slaps her own forehead, eyes closed, head drops slightly, standing in place |
| hero | cheer | 6+1 | `aa328dca-2852-463f-bfe8-f8d6f44bf43e` | happily cheering, pumps one fist up into the air, big joyful smile, standing in place |
| hero | facepalm | 4+1 | `309c77e8-d471-477b-8e3e-a2cbb472e567` | disappointed facepalm, raises one hand and slaps his own forehead, eyes closed, standing in place |
| hero | notice | 4+1 | `1436e7d9-21d5-4d23-83ae-ef892ee3faa7` | flinches slightly in surprise, then leans forward to look closely at something on the floor in front of him, curious face, feet stay in place |
| hero | startled | 4+1 | `7d19c95f-2a7a-44ae-b1f6-ef63f6cf5482` | startled in fright, hops backward with both hands raised, eyes wide open, mouth open, then lands |
| hero | disgust | 6+1 | `0bc42061-83db-4517-94bc-e19202b487c9` | disgusted by a bad smell, turns his head away grimacing and waves one hand in front of his nose, standing in place |
| hero | thinking | 4+1 | `d3d31a5a-80a8-4abd-a1aa-befc940096fc` | thinking hard, one hand on his chin, eyes looking up, slight head tilt, standing in place |
| hero | dizzy | 4+1 | `1d0cd18f-5643-4260-a8ee-a38d1bc75174` | dizzy and confused, body sways unsteadily from side to side, wobbly dazed expression, feet stay in place |

Ghost: character `1f0c9d71-…`, canvas 88×88, `_incoming/characters/ghost_v2/anim/{raw,clean}/<name>/`; idle uses clean frames 3–6 ping-pong (arms folded; the crown adjust did not come out). Cleanup removed red "anger marks" the model drew itself (angry 1, 4, 5). Hero: character `866a2fb0-…` (approved v34 rig), canvas 92×92, `_incoming/hero_emotions/{raw,clean}/<name>/`; cleanup removed a pebble drawn in "notice" and remapped 8–21 px per frame in the slipper rows to hero_v7_a colours. SpriteFrames: `ghost_v2/anim/ghost_frames.tres`, `hero_emotions/hero_frames_emotions.tres` (last frame held ×4). Previews `ghost_v2/ghost_emotions.gif`, `hero_emotions/hero_emotions.gif` (assembled offline from the same frames with the in-game emote timing; the ghost shader is approximated).

**Emote icons** (`_incoming/emotes/`), pending. `create_image_pixen` 24×24, `no_background`, 1 each. Style A: "<symbol>, manga emote icon, bold pure white fill, thick black outline, flat, centered, large and readable" (outline `single color black outline`, detail low, seed 3101; anger red and sweat pale-blue fill). Style B: "<symbol>, cute game emote icon, bright <colour> fill with a small white highlight, dark brown outline, chunky storybook pixel art, centered, large and readable" (outline `single color outline`, detail medium, seed 3201).

| Icon | Style A job | Style B job |
|---|---|---|
| dots | `ec0fb364-5e94-42b2-9f0d-7b285f45c0e9` | `41f6594c-99bf-49e0-84c2-13d7f9571748` |
| exclaim | `8d1de857-645d-4a11-b3b4-f3a49a4bd616` | `03a8c573-8b0f-4b4b-ba12-32a5123ac642` |
| double | `f336e49e-db84-4eab-81e4-0a027f358652` | `086dee21-6b5c-4865-9222-dda07e182864` |
| question | `8f64f603-24f8-45ea-933e-5ffefbc126b7` | `fe7a41ff-6a0e-4e27-a341-40476383c679` (v1 `1fb1819a-8953-4f39-8d02-4b11b039357e`) |
| anger | `9c458f81-fc69-4b4f-8e10-1ae6108e7120` (v1 `5de644f2-b1ee-4af9-8a6a-86d1175e0c0a`) | `9f8c17b5-f441-4c20-9ce6-e25a1b236bb1` |
| sweat | `9cd3c4ac-67ce-46ca-8734-1166b2af453d` | `5d8fa556-0eeb-4a3b-82ab-4ec4de1c34d0` |
| gloom | `a590d82a-36b5-43d1-bc80-bd6741e24337` | `5e16cc3b-c596-4432-906e-92171912f8bf` |
| sparkle | `07918539-bdcf-4f3b-8845-6aec8b5763fa` (v1 `554b79a7-e4f0-402d-8f08-f346dfc7bcd0` had a face) | `1d498b24-068f-408f-b8bd-264b53f0a525` |
| swirl | `069ea11f-62f6-4ac6-9d08-fcc3045ffa36` | `715ec704-a17c-40f0-ac47-2184bce4b716` |

Frames for style A by `tools/emote_frames.py` → `frames_a/<icon>/`, SpriteFrames `emote_frames_a.tres`. Sheets: `emotes_style_a.png`, `emotes_style_b.png` (×8), `emotes_sheet.png` (style A, all frames ×4).

## 2026-10-19 (4) — Emotions and emotes approved, boudoir furniture, canary

Spent **66** (balance 1567 → 1501): anger vein 10, swirl 10, birdcage 10, orange tree 10, harp 10, vanity 10, canary 4 (2 at 24 px — too big for the cage, 2 at 16 px), canary animations 2.

**Approved:** ghost shader v2 + all 6 ghost emotions; hero cheer, facepalm, notice, disgust, thinking, dizzy; emote style A (B rejected). Hero `startled`: the jump ended in mid-air — landing assembled from existing frames (0 generations): after frame 4 (held 2) come frame 2 (crouch, held 2), 1, 0 (held 2), then idle. Preview `_incoming/hero_emotions/startled_landing.gif`, strip `startled_landing_strip.png`. Pending.

**Emote fixes (style A):**

| Icon | Fix | Tool | Job / pick | Cost |
|---|---|---|---|---|
| anger | classic anime cross-popping vein: 4 curved arms meeting in a cross, red | `create_image_pro` 24×24 (64 candidates), style image = `style_a/question.png` (outline, detail, shading) | `db1e1a0d-61bc-4402-9bce-b20ba79f4719`; #9 (alternatives #41, #24) | 10 |
| swirl | one coiled spiral line, not concentric circles | `create_image_pro` 24×24 (64 candidates), same style image | `6999e98b-c019-4042-ab58-e012c3475ca3`; #21 (alternatives #17, #12) | 10 |
| dots | source `dots.png` = three identical round dots (the third was a squiggle); in-game frames were already built from the first dot | script | — | 0 |
| sparkle | in game it is the regenerated star without a face (`sparkle.png` = `frames_a/sparkle/0.png`); the face was only on the old sheet (`sparkle_v1`) | check | — | 0 |

Candidates: `_incoming/emotes/gen_v2/{anger,swirl}/`. Old versions kept as `style_a/{anger_v2,swirl_v1,dots_v1}.png`. New sheet `emotes_sheet_v2.png`, in game `emote_in_game.png`.
Prompts: anger — "anime anger vein symbol (cross-popping vein mark, "kekkan" manga emote): four short thick curved bulging red veins whose rounded ends point to the center and bend outward, forming a cross shape like the character ╬ with a small gap in the middle, bright red with darker red shading, thick dark outline, centered, nothing else, simple bold icon readable at small size"; swirl — "dizzy spiral symbol: a single white line coiled into a spiral (like a snail shell or the @ swirl), one continuous curling line winding inward from the outside to the center, clearly a spiral and NOT concentric circles or a target, thick dark outline, white with light grey shading, centered, nothing else, simple bold manga emote icon".

**Boudoir furniture** (`_incoming/props/<prop>/`, pending). `create_image_pro`, style image = `approved/room_princess_boudoir.png` (`upload:0c2faaff-5c72-4388-b0f3-b5aab1feaf05`). Every prompt ends with: "seen strictly from the front, symmetrical, flat front view slightly from above (same diorama camera as the room), same lighting as the room, transparent background, no floor, no characters, no isometric angle. The <prop> fills the canvas from top to bottom."

| Files | Canvas | Seed | Job | Cost | Picks |
|---|---|---|---|---|---|
| `birdcage/birdcage_2701_{0..8}.png` | 56×100, 9 candidates | 2701 | `a13d211a-ff85-4a66-8a08-1cf3c1f3aaef` | 10 | a = 0, b = 4 |
| `orange_tree/orange_tree_2711_{0..8}.png` | 64×88, 9 | 2711 | `9d909802-56b2-43f6-a232-403487095132` | 10 | a = 0 (pebble next to the pot removed), b = 4 |
| `harp/harp_2721_{0..8}.png` | 64×96, 9 | 2721 | `bac7c81d-74b4-4e91-b101-228b9f5dfd43` | 10 | a = 0, b = 2 |
| `vanity/vanity_2731_{0..3}.png` | 96×104, 4 | 2731 | `e27450b0-4c87-4d50-9cf9-d1058a440050` | 10 | a = 0 (triple mirror), b = 2 (oval mirror) |

Prompts (subject part): birdcage — "ornate gilded birdcage on a tall slender stand with a round base, dome-topped cage with thin golden bars and curled scrollwork, slightly tarnished and dusty gold, inside two thin wooden perches at different heights, a tiny water dish and a few scattered seeds on the cage floor, the cage is EMPTY with no bird"; orange tree — "small potted orange tree in an old cracked ceramic planter with faded blue and white painted pattern, round leafy dark green crown with a few ripe bright oranges hanging, a few fallen dry leaves lying inside the pot on the soil … no leaves on the ground"; harp — "tall gilded concert harp standing upright on the floor, ornate carved golden column and curved neck with scrollwork, a few strings broken and hanging loose, dusty and slightly tarnished gold, a cobweb thread between the column and the strings, seen from the side as a harp is usually shown (its triangular frame facing the viewer)"; vanity — "gothic vanity dressing table of dark carved wood with curved legs, a tall oval mirror in a carved frame on top (the mirror glass is plain dark silvery grey with a soft sheen, no reflection), on the tabletop a round powder box, two small crystal perfume bottles with pink and violet glass, a hairbrush and a few tiny golden hairpins, dusty … no stool".
Post: `tools/prop_tools.py clean` (detached specks), `bars` (front bars of the cage → `*_bars.png`, drawn over the canary). Shadows reuse `approved/props/wardrobe_princess_shadow.png` scaled.

**Canary** (`_incoming/props/birdcage/`): `create_image_pixen` 16×16, `no_background`, outline black, view side — "tiny yellow canary bird sitting on a perch, side view facing right, round fluffy body, small orange beak, black dot eye, folded wings, short tail, bright lemon yellow feathers with slightly darker wing tips, cute storybook pixel art". Seeds 2743 (picked, `e7ff0b89-3cd1-4958-8475-b9b9ce124c56`), 2744 (`e1016699-8734-4c99-b894-f6e6a35b1c47`, drew its own perch); 24 px tries 2741/2742 too big. `animate_image` from 2743: preen 6 frames "small bird preening: turns its head back and pecks gently at its wing feathers, then looks forward again, stays sitting on the same spot" (seed 2745, `9f92c38e-a41f-4050-bcf5-884bbc905927`, 1); alarm 4 frames "small bird alarmed: flaps both wings quickly up and down while staying in place, feathers ruffled" (seed 2746, `d18acae7-1786-43c0-a5c8-232dffcb90c4`, 1). Hop = code (arc tween + alarm frames + flip).

**Sound placeholders** (`assets/audio/sfx_placeholder/`, synthesized by `tools/placeholder_sfx.py`, 0 generations): `canary_chirp.wav`, `harp_note_{0..3}.wav` (C5 E5 G5 C6). Replace at T-27.

Screenshots: `_incoming/props/{birdcage,orange_tree,harp,vanity}/<prop>_{a,b}.png` (×3, hero for scale), `boudoir_furnished.png` (a), `boudoir_furnished_b.png`, `birdcage/canary.gif` (idle: hops, preening; then alarm).

## 2026-10-19 (5) — Emote anchors, transitions, interactable props, poses, half-open frames, layouts

Spent **34** (balance 1501 → 1467): hero poses 6, wardrobe ajar 6, secretary ajar 5, nightstand slot 5, garderobe door ajar 6 + open 6.

**Approved from the last batch:** startled with landing → `approved/hero/emotions/startled/`; boudoir birdcage a, canary, orange tree a, vanity b, harp a → `approved/props/boudoir/`; other variants rejected (deleted from `pending/`).

**Hero interaction poses** (`_incoming/hero_interact/{raw,clean_south,clean_east}/`, pending): `animate_character` mode v3 on character `866a2fb0-794b-40be-8cd5-c99e3a9480c2`, directions south + east, 4 frames + reference, canvas 92×92 (south) / 88×88 (east), 1 per direction. Cleanup `tools/emotion_cleanup.py` (slippers checked against `hero_v7_a.png`).

| Animation | Group | Action |
|---|---|---|
| interact_low | `9aa22746-2066-4d4d-9474-bbb254af9201` | "crouches down low bending the knees and reaches one hand toward the floor in front of him to pick something up, then holds the crouch, feet stay in place" |
| interact_mid | `5656fc21-9bf5-46ed-8880-9971c10a4963` | "leans forward slightly and stretches one arm straight out in front of him at chest height to touch or take something from a table, then holds the pose, feet stay in place" |
| interact_high | `a250d6fd-7975-4d00-a050-d873d8af7d5f` | "rises onto his tiptoes and reaches one arm high up above his head to pick something from a branch, then holds the pose, feet stay in place" |

**Half-open frames** (`edit_image_pro_flash`, `use_color_palette_correction`):

| Output | Source upload | Seed | Job | Cost | Prompt |
|---|---|---|---|---|---|
| `_incoming/props/wardrobe/wardrobe_ajar_2801_0.png` | `upload:a589e18c-c283-44bd-801a-fd36ebbbe1aa` (closed wardrobe) | 2801 | `8ca3aae6-a67a-4165-8d44-7c3d1464e321` | 6 | "the same wardrobe with both doors only slightly ajar, each door swung open just a little (a narrow dark gap in the middle, about one fifth of the way open), the dark interior barely visible through the gap. Keep the same wardrobe frame, carvings, painted flowers, colors, size, outline and lighting." |
| `_incoming/props/secretary/secretary_ajar_2811_0.png` | `upload:5d03cc28-3c8c-4c9e-a5c1-023ad8cceb5a` | 2811 | `996924f2-1009-4d0e-8454-abc169afac96` | 5 | "the same writing desk with the slanted fold-down lid half open, tilted forward about halfway down, a dark gap showing the shadowy interior with pigeonholes barely visible. Keep the same desk body, drawers, inkwell and quill, colors, size, outline and lighting." |
| `_incoming/props/nightstand/nightstand_slot_2821_0.png` | `upload:4b95e439-d124-464a-acd5-1f2987f5619f` | 2821 | `a00632fa-0577-4797-975f-a847967dce76` | 5 | "the same small nightstand, but its upper front drawer is pulled out and missing, leaving an empty dark rectangular drawer slot in the upper part of the front face. Keep the same candle, colors, size, outline and lighting." |
| `_incoming/props/door/door_ajar_2831_0.png` | `upload:ab5cefee-289b-433e-aa0c-58738a18283f` (bedroom crop 216,136–276,272) | 2831 | `eee5f248-a7be-4908-8460-e051ec472c9c` | 6 | "the narrow wooden door in the side wall is slightly ajar: it has swung open a little, a thin dark gap appears along its edge with deep darkness behind it. Keep everything else exactly the same: the stone pillar, the wall, the wallpaper, the floor, colors and lighting." |
| `_incoming/props/door/door_open_2832_0.png` | same | 2832 | `9b55cfc8-a8ff-47b1-bf6b-55d9e429c10e` | 6 | "the narrow wooden door in the side wall is wide open: the door leaf is swung fully open against the wall, the doorway is an empty pitch-dark opening. Keep everything else exactly the same: …" |

**Sound placeholders** added (synthesized, `tools/placeholder_sfx.py`, 0 generations): `open.wav`, `close.wav`, `locked.wav`, `pickup.wav`, `creak.wav`.

Found-item icon = placeholder (coloured square + letter, `components/item_pop.gd`); WIP garderobe room = grey rectangles + label.

Screenshots / GIFs: `_incoming/emotes/emotes_placement.png`; `_incoming/feel/{door_transition,iris,wardrobe_open_anim,drawer,look_under_bed,pick_orange}.gif`; `_incoming/layouts/layout_{bedroom,boudoir,dressing}.png`.

## 2026-10-19 (6) — Fixes, text/highlight, first-person garderobe, bedroom arch

Spent **130** (balance 1467 → 1337): fixes 27 (interact_high v2 2, drawer 5, gloom 10, swirl 10); garderobe + bedroom 103 (wall inpaint 6, arch door 6 + 6, arch door ajar/open 12, garderobe backgrounds 2×25, posters 10 + 10, hand 2, toilet paper 1).

**Approved:** interact_low, interact_mid (south, east) → `approved/hero/interact/`; wardrobe/secretary ajar → `approved/props/`; door 3 states, fade, iris, emote placement. The old side-door overlays (`garderobe_door_*`) were deleted with the door.

**Fixes**

| What | Tool | Seed / job | Cost | Result |
|---|---|---|---|---|
| interact_high v2 (south + east) | `animate_character` v3, group `cea28a8d-cb6f-435a-9236-57a2eeba46ed`, "standing in place, rises up onto his tiptoes with both feet staying on the floor, stretches one arm straight up above his head reaching for something high, the other arm down at his side, body upright, then holds the pose" | — | 2 | pending |
| nightstand drawer out | `edit_image_pro_flash` of the nightstand padded to 40×48 (`upload:facd79fc-0d40-4197-b6d8-4b83ed6f7862`): "the same small nightstand with its upper front drawer pulled out forward and slightly down toward the viewer: the drawer front panel with its little knob sticks out of the nightstand, above it the open drawer box shows a dark empty inside with a tiny matchbox lying in it. Keep the same candle, nightstand body, colors, outline and lighting." | 2901 / `6f2c5a9e-2b60-4060-9d24-d3debfaaf6d8` | 5 | pending (the cut-out drawer of the last batch removed) |
| gloom 16×16 | `create_image_pro` 64 candidates, style = `style_a/question.png`: "manga gloom lines emote: three short wavy vertical white lines hanging down side by side like a sad aura, thick dark outline, white with light grey shading, small and simple, centered, nothing else" | `b7f28b03-374a-4fbb-b54d-d3d52334a78a`, #13 | 10 | approved/ui/emotes (on the forehead/top of the head) |
| swirl with an open tail | `create_image_pro` 24×24 64 candidates: "dizzy spiral emote: one thick white line curling inward in a spiral from an open loose tail end at the outside to the center, like a snail shell drawn with a single stroke, the outer tail end clearly sticks out and is NOT closed into a circle, NOT a target, NOT concentric rings, no filled disc behind it, thick dark outline, centered, nothing else" | `02285472-141d-4790-a69e-00940d9b7c78`, #24 | 10 | approved/ui/emotes |
| oranges | script: fruit colours shifted to yellow-orange (the night tint turned them red) | — | 0 | `approved/props/boudoir/orange_tree.png` (before: `_incoming/props/orange_tree/orange_tree_approved_before_recolor.png`) |

**Bedroom arch** (`_incoming/rooms/bedroom_garderobe/`, `upload:186d8156-ad0c-47a9-b2c3-ea93b7027695` = bedroom):

| Output | Tool | Seed / job | Cost |
|---|---|---|---|
| `olddoor_inpaint_3001_0.png` | `inpaint_image_pro_flash` on crop (196,120)+96×160, mask (40,8,24,152): "plain castle side wall with no door: continue the faded pink rose wallpaper above and the dark stone wainscoting and stone blocks below, matching the wall on the left, the stone pillar on the right stays. No door, no doorway, no frame." | 3001 / `e7533c7a-b7e9-4760-9757-0bcf5df23d41` | 6 |
| `arch_door_3011_0.png` (rejected: door fills the whole arch) | inpaint on crop (400,72)+120×192, mask (26,14,62,146): small closed wooden door … above it stone | 3011 / `b83a2d30-adba-4379-a6a2-73c538a52051` | 6 |
| `arch_door_3012_0.png` (used) | same mask: "inside the pointed stone archway: burgundy velvet curtains tied back with gold tassels on both sides of the archway, and between them, set deep inside, a SMALL LOW old wooden plank door with an iron ring handle standing on the floor; the small door is only half the height of the archway; above the small door the archway is closed with solid dark cut stone blocks. Front view, same lighting as the surrounding wall." | 3012 / `a9c08af5-faf5-4443-91e1-6e514d40cdf6` | 6 |
| `arch_ajar_3021_0.png`, `arch_open_3022_0.png` | `edit_image_pro_flash` of 3012 (`upload:12aff17e-ec7a-4287-a8df-2520211d0ed9`): "…the small low wooden door between the curtains is slightly ajar: swung open a little, a thin strip of warm candle light shows through the gap…" / "…is wide open: the door leaf swung inward, the small doorway shows a warm candle-lit tiny stone room inside…" | 3021 `d23f6479-…`, 3022 `437fe499-…` | 12 |

**First-person garderobe** (`_incoming/garderobe/`): `create_image_pro` 640×360, style = bedroom, seeds 3101 (`270112de-c265-4ca6-9f4b-8893975625ab`, a) and 3102 (`c13b9459-9aa2-4453-b685-c684d9f35390`, b), 25 each. Prompt: "first-person view looking straight into a cramped medieval castle garderobe: a narrow stone toilet niche at night, rough grey-lilac stone block walls on the left, right and back, a low vaulted stone ceiling. In the middle stands a funny ultra-modern Japanese high-tech toilet: sleek glossy white, shaped like a little spaceship with smooth curves, a soft glowing blue rim light, a side control panel on the right armrest with a few round and square buttons but no text or symbols on them. The back and side walls have large flat bare stone areas left empty (for posters that will be added later). A small wooden shelf on the right wall with a short white candle, warm candle light on the stone. An empty toilet paper holder on the left wall. Old wooden floor. Storybook gothic pixel art, same style, palette and lighting as the reference bedroom. No people, no characters, no text, no letters, no logos, no posters, no pictures on the walls."
Posters: `create_image_pro` 48×64 — seed 3121 (`3584a2ff-…`, transparent cut-outs without paper, rejected) and 3122 (`ca1f7f2f-240a-4cfe-91a2-71bb69460703`, used #1 Rotley Glue, #2 Buns N' Noses, #5 Squid Row, #7 Bon Jovial, #12 Whitesnack, #15 Deaf Leopard): "a complete rectangular 1980s glam metal concert poster filling the whole canvas edge to edge: a coloured printed paper background (…) and an invented band of two or three made-up rock musicians with huge teased hair, spandex and guitars; slightly faded, creased, a torn corner; a plain empty colour strip at the top for a title. Absolutely no text, no letters, no logos, no real people. Flat front view, storybook pixel art." Hand cursor: `create_image_pixen` 24×24 seeds 3131 (point), 3132 (grab, mirrored). Toilet paper: pixen 24×24 seed 3141. Sound `spray.wav` — synthesized.

Screenshots: `_incoming/feel/{drawer_v2,pick_orange_v2}.gif`, `text_size_{a,b}.png`, `highlight.gif`; `_incoming/emotes/emotes_fix.png`; `_incoming/layouts/layout_{bedroom,boudoir,dressing}_v2.png`; `_incoming/garderobe/{garderobe_a,garderobe_b,garderobe_poster_moved}.png`, `garderobe_spray.gif`.

### Brief — suite furniture by the v2 layouts (NOT generated, waiting for an OK on `layout_*_v2.png`)
§3.4 order: style image = the room, camera "seen strictly from the front … slightly from above" (3/4 items: "turned three-quarters to the left/right, standing against the side wall"), shadow, y-sort, sole collision, hotspot; 2 variants each, all into `pending/`.
- Bedroom: `nightstand_2` — mirrored copy of the nightstand (0 generations). `tiger_skin` — "cartoonish tiger skin rug hung on the wall, slightly moth-eaten, comic flat head with a silly expression" (3/4, side wall). `bedside_rug` — "round faded pink rug, flat on the floor, seen from above at the room's camera angle". `chest` — "wooden chest with iron bands and a small brass combination lock with number wheels", 3 states closed / ajar / open (edits). `painting_count` — portrait of the Count, `count_adult_front_b.png` as the character reference, ornate frame; **eyes as a separate sprite** (pupils shift 1–2 px toward the hero's x). `painting_madam` — "stern old lady with a tiny fluffy lapdog in her lap, oil portrait in a gilded frame" (invented person). `still_life` — "still life painting: red apples and a clay jug, small gilded frame".
- Boudoir: `x_chair` — "X-shaped curule chair, dark wood, faded pink cushion" (3/4); `plush_bear` (separate) — "worn plush teddy bear with tiny felt vampire fangs, sitting"; `cello` — "old cello leaning on its side, two broken strings, dusty" (3/4).
- Dressing room: `dress_form` — "dress form mannequin wearing an old faded pink ball gown" (3/4); `laundry_basket` — "wicker laundry basket with silk stockings hanging over the edge" (hotspot "Take stockings" → `stockings`, second use: water filter); `full_length_mirror` — "tall full-length standing mirror in a carved frame, dusty glass, no reflection" (3/4, on the right side wall).

## 2026-10-19 (7) — Posters v2, suite furniture

Spent **292** (balance 1337 → 1045): posters 6 × 15 + nail/tape 2 = 92; furniture 200.

**Posters v2** (`_incoming/garderobe/posters_v2/<name>/`, `create_image_pro` 64×84, 9 candidates each, 15 each, `no_background: false`). Each prompt: "a complete rectangular 1980s … concert poster filling the whole canvas edge to edge, parody of a made-up band: <idea>; colour scheme <…>; plain empty strips at the very top and at the very bottom for the band name. No text, no letters, no logos of real bands, no real people. Slightly faded paper. Storybook pixel art."

| Poster | Idea | Seed / job | Pick |
|---|---|---|---|
| Rotley Glue | three rockers in black leather and silver chains, a GIANT tube of glue squeezing out a shiny blob like a logo; black, chrome, blood red | 3201 / `a138dc34-414c-4298-85e6-b775862796f6` | #4 |
| Buns N' Noses | rockers with bandanas, giant bread buns stacked like amplifiers, red clown noses; golden brown, cream, red; jungle leaves | 3202 / `d67cd6df-fb94-44a5-80ad-7e5dd083788f` | #5 |
| Squid Row | a big friendly purple squid with teased hair holding four guitars and a microphone, under water; deep sea blue, teal, purple | 3203 / `b6cda0b0-50d2-45c2-95c4-e5aaddcae909` | #4 |
| Bon Jovial | a grinning guy in a cowboy hat and denim jacket, thumbs up, pink hearts, sunburst; sky blue, pink, white | 3204 / `ee6ba899-6f74-4578-8f94-8ab34c6ed519` | #4 |
| Whitesnack | a white snake coiled around an open bag of chips eating a chip, a guitar; yellow, white, green | 3205 / `f01361c7-8e4d-4043-8546-eb355fb03403` | #6 |
| Deaf Leopard | a roaring leopard with an old brass ear trumpet and huge headphones, lightning; hot orange, black, magenta | 3206 / `f8a62f64-4905-4f62-98cb-026a5b335175` | #3 |

Nail / tape: `create_image_pixen` 16×16, seeds 3212 / 3211 ("a single small iron nail head hammered into a wall…", "a short strip of old yellowed masking tape…"), cropped.

**Suite furniture** (`_incoming/suite/<name>/`, `create_image_pro`, style image = own room: bedroom `upload:9207f2f1-6ffd-4152-b9c3-ccfe8938e93d`, boudoir `upload:7992bcfd-528b-422e-9921-312e908144cd`, dressing `upload:0522591d-849d-4087-ac38-3236dcfc3364`). Picks a / b; offsets in the scene from the sprite bbox (sole = bbox bottom).

| Item | Canvas | Seed / job | Cost | a / b | Prompt (subject) |
|---|---|---|---|---|---|
| painting_count | 40×48 (25) | 3301 / `87726c7a-b8d0-4d1f-8bc2-bae2265099d5` | 10 | 7 / 2 | oil portrait of a pale vampire count, gilded gothic frame, eyes with visible whites; reference `count_adult_front_b.png` (`upload:9bd77bc6-…`) |
| painting_madam | 36×44 (36) | 3302 / `95810ad4-de34-4bde-ba01-4422bbc2045e` | 10 | 16 / 28 | invented stern old lady with a tiny fluffy lapdog; framed with the frame of painting_count #2 (script) |
| tiger_skin_rug | 96×40 (16) | 3303 / `a920f35b-ff61-4544-a890-c4794116083d` | 10 | 12 / 14 | cartoonish tiger skin rug flat on the floor, head with open jaws, moth-eaten |
| bedside_rug | 64×24 (36) | 3304 / `b6d6f1d3-ab74-4a99-b602-62f158952787` | 10 | 21 / 8 | round faded pink rug, flat |
| chest | 56×40 (25) | 3305 / `f95ba4d2-cf80-4060-98d2-458667094980` | 10 | 2 / 16 | wooden chest, iron bands, small brass 4-wheel combination lock, 3/4 left |
| chest ajar / open | 56×56 padded | 3311 `9bf0c674-…`, 3312 `f521cab3-…` | 10 | — | `edit_image_pro_flash` from chest #2 |
| folding_screen | 64×88 (9) | 3306 / `bf9b7040-2f4c-499b-9756-8df76b6958ac` | 10 | 0 / 6 | gothic three-panel screen, painted roses and birds, 3/4 right |
| harp34 | 64×96 (9) | 3401 / `81d3c5ec-6ec8-4846-9fc9-4c75c4e28bcb` | 10 | 0 / 5 | gilded harp turned three-quarters to the left |
| x_chair | 40×40 (36) | 3402 / `45624d79-4f12-4fb1-b4dd-0e82f56434bb` | 15 | 1 / 24 | gothic X-frame chair, faded pink cushion, 3/4 right |
| plush_bear | 24×24 (64) | 3403 / `cfaa570c-831e-44fb-963d-9a37eb20c8a2` | 10 | 6 / 19 | worn teddy bear, one button eye |
| cello | 32×64 (25) | 3404 / `43e403ee-cf9e-47ea-901a-bee7f8c29bd5` | 10 | 21 / 5 | cello leaning on the wall, 3/4 right, one string loose |
| oval_rug | 96×28 (4) | 3405 / `d05bfb8d-7828-4903-8c8a-03eb50557710` | 10 | 3 / 2 | oval dusty-pink rug, flat |
| floor_candelabra | 24×80 (16) | 3406 / `1f840936-437b-4d02-ba48-6536fbe0ebf1` | 10 | 0 / 4 | wrought-iron floor candelabra, three candles (flames = particles + light in Godot) |
| still_life | 28×24 (64) | 3407 / `e19ccef1-2bf2-4cb5-941f-ab40a09be314` | 10 | 36 / 28 | apples and a jug, gilded frame |
| dress_form | 40×72 (16) | 3501 / `a38d32d5-ac09-4ea3-a7d7-2012914e7be1` | 10 | 3 / 13 | dress form in a faded pink ball gown, 3/4 left |
| laundry_basket | 40×32 (49) | 3502 / `582ef7ed-ef82-4a51-9d91-1c62a18e546a` | 15 | 13 / 7 | wicker basket, linen, stockings over the edge, 3/4 right |
| full_length_mirror | 36×80 (16) | 3503 / `dba09120-deeb-42f8-bd19-941345d02418` | 10 | 2 / 15 | standing mirror against the right side wall, 3/4 left, dusty glass, no reflection |
| worn_rug | 112×32 (4) | 3504 / `8a05f6cd-7a72-4fed-b846-52251c4f85fa` | 10 | 0 / 1 | worn burgundy rug with fringe, flat |
| coat_stand | 32×84 (16) | 3505 / `a946d6af-024c-4f46-bad2-d7fe88662387` | 10 | 5 / 2 | coat stand with a pink feather boa |
(The first bear/cello/rug/candelabra/still life calls hit the 8-jobs limit and were not charged.)

Script work (0 generations): nightstand_L = mirrored nightstand; Count eyes = eye-white pixels of the portrait as an overlay (`painting_count_eyes.png`); madam framed with a generated frame.

Screenshots: `_incoming/garderobe/{garderobe_a_v2,garderobe_poster_moved_v2,posters_sheet}.png`; `_incoming/layouts/layout_bedroom_v3.png`; `_incoming/suite/shots/{bedroom_full,boudoir_full,dressing_full}.png`, `eyes_follow.gif`, `<item>_{a,b}.png`, `variants_overview.png`.

## 2026-10-19 (8) — Fix batch (budget 40)

Spent **38** (balance 1045 → 1007). After this: pause until 18.11.2026 (CLAUDE.md §5.8).

| Output (`_incoming/batch8/`) | Tool | Seed / job | Cost |
|---|---|---|---|
| `arch_door_0.png` — ornate door in the arch | `inpaint_image_pro_flash` on the arch crop (400,72)+120×192 (`upload:ece478d3-…`), mask (38,72,44,94): "between the tied-back curtains: a pompous ornate closed door standing on the floor, dark carved wood with gilded trim, gold scrollwork and a big gold ring handle, a pointed top that fits the arch; a small blank wooden plaque hangs on a thin chain from the handle (the plaque has no text). Front view, same lighting as the surrounding wall." | 3601 / `1e80009e-cb9f-4c28-ae10-832ad47c8486` | 6 |
| `arch_ajar_0.png`, `arch_open_0.png` | `edit_image_pro_flash` of `arch_door_0` (`upload:0e86a7a3-…`): "…the ornate gilded door between the curtains is slightly ajar…" / "…is wide open: the door leaf swung inward, the doorway shows a warm candle-lit tiny stone room inside…" | 3611 `4666341e-…`, 3612 `3830d592-…` | 12 |
| `portrait_{0..8}.png` — Count 60×72 (a = 0, b = 6) | `create_image_pro`, style = bedroom, reference = count: "an oil portrait painting of a pale vampire count in an ornate gilded gothic frame … the eyes look straight at the viewer: clearly visible white eyeballs with small black pupils …" | 3602 / `09dc2013-42ec-4081-98be-650b20a57c16` | 15 |
| `tiger_0.png` 136×56 | `create_image_pixen`: "a cartoonish tiger skin rug lying flat on a wooden floor seen from a high front camera angle … head at the front with comically open jaws and fangs, slightly moth-eaten" | 3603 / `e7d46b46-…` | 1 |
| `candelabra_0.png` 44×72 | pixen: "a tall ornate wrought-iron floor candelabra as tall as a person, five white candles on curled arms, curled tripod feet, gothic scrollwork … no flames" | 3604 / `a2937bd7-…` | 1 |
| `music_stand_0.png` 32×56 | pixen: "a gothic wrought-iron music stand with curled scrollwork on a tripod base, an open sheet of music paper on it, turned three-quarters to the left" | 3605 / `44446b7e-…` | 1 |
| `sheet_music_0.png` 24×24 | pixen: "a single loose old sheet of music paper with staves and notes lying flat on a floor, seen from above at a steep angle, slightly yellowed" | 3606 / `f990fc8c-…` | 1 |
| `paper_holder_0.png` 32×40 | pixen: "a wall-mounted toilet paper holder: a small brass bracket screwed to a stone wall with a short horizontal rod, a white roll of toilet paper on the rod, the loose end of the paper hanging down a little, seen at an angle on a wall that recedes to the right" | 3607 / `d7fbde7b-…` | 1 |

Script work: Count eye band (rows 33–37) as the eyes overlay; bedside rug b desaturated/darkened; basket b darkened; door pasted into the bedroom, state overlays = door area only. Old small-door overlays (`approved/props/garderobe_arch_*`) deleted.
Screenshots: `_incoming/garderobe/garderobe_v3.png`; `_incoming/batch8/shots/{bedroom_full_v3,boudoir_full_v3,dressing_full_v3}.png`, `eyes_follow_v2.gif`; `_incoming/layouts/layout_boudoir_v3.png`.

## 2026-10-20 (9) — Batch 9 (budget 100): bedroom fixes, princess study, gramophone

Spent **94** (balance 1007 → 913). Style images (uploads 19.10/20.10): bedroom `upload:ddc0f33a-a66e-42f1-b669-51c389de8e81` (pending bedroom), dressing `upload:04726783-8c93-40f0-ba81-a5a924200e76`, boudoir `upload:45874cac-497a-4865-99d7-266d7cf5e7d8`. Raw output: `_incoming/batch9/`. Variants a (in the scene) / b (next to it in `pending/suite/`).

| Output | Tool | Seed / job | Cost | a / b | Prompt (subject) |
|---|---|---|---|---|---|
| `arch_door_pointed_0.png` | `inpaint_image_pro_flash` on the arch crop (400,72)+120×192 (`upload:36976264-…`), mask (32,64,56,110) | 3701 / `cd65dd7d-d063-49ba-a351-97cfc65dff77` | 6 | — | "Between the tied-back red velvet curtains: a narrow ornate closed door with a POINTED gothic arch top that follows the shape of the surrounding stone arch, standing on the floor; dark carved wood with gilded trim, gold scrollwork along the pointed edge and a big gold ring handle… fits fully between the curtains and does not overlap them… No sign, no plaque, no text. Front view, same lighting." |
| `arch_door_pointed_{ajar,open}.png` | `edit_image_pro_flash` of the door (`upload:0e42c99e-…`) | 3711 `216a4b51-…`, 3712 `1901eff2-…` | 12 | — | "…slightly ajar: the right half of the door leaf swung a little inward, a narrow dark gap with a thin line of warm candle light" / "…wide open… the pointed doorway shows a warm candle-lit tiny stone room inside" |
| `sign/sign_0.png` 28×28 | `create_image_pixen` | 3713 / `4fbcb104-…` | 1 | — | "a small rectangular old wooden plaque sign hanging from a short thin iron chain shaped like an upside-down V… blank… no text"; plank widened by 8 px (script) |
| `bedside_rug/` 104×40 (4) | `create_image_pro`, style = bedroom | 3702 / `139b7b9e-079a-487d-b9da-c1b7f5efdf07` | 10 | 1 / 2 | "A large round faded pink rug lying completely flat… ornate darker rose border with a woven floral pattern ring, a medallion pattern in the middle, short cream fringe all around… not a plate, not a dish" |
| `folding_screen/` 60×84 (9) | `create_image_pro`, style = bedroom | 3703 / `5af40a59-f8dd-460f-8b1b-437431e84ffd` | 15 | 0 / 8 | "A tall gothic three-panel folding screen… slim panels with pointed arched tops… painted with faded pink roses and small birds, turned three-quarters to the right" |
| `bookcase/` 48×84 (16) | `create_image_pro`, style = dressing | 3704 / `0eda8672-9e6b-45aa-b105-e87d2e730015` | 10 | 5 / 11 | "A tall narrow gothic bookcase… seen strictly from the front… old leather books, glass jars of dried herbs, a pressed-flower herbarium album lying open… dusty, a cobweb" |
| `bookcase34/` 52×84 (16) | `create_image_pro`, style = dressing | 3705 / `5f2819c6-82ba-4943-bd8b-4b4a7f9a3468` | 15 | 3 / 9 | same, "turned three-quarters to the right (we see its front and its left side panel)" |
| `lab_table/` 64×48 (16) | `create_image_pro`, style = dressing | 3706 / `913c11d9-d0c3-4652-80ed-42d1dbe0d300` | 10 | 2 / 9 | "A small old wooden work table… glass flasks with coloured liquids, a stone mortar and pestle, a tiny copper alembic, small brass scales, a little candle burner, scattered handwritten notes" |
| `gramophone/` 48×64 (16) | `create_image_pro`, style = boudoir | 3707 / `9b0cdd99-8521-4e49-b7d5-b69ed44091c3` | 10 | 0 / 12 | "An antique gramophone with a large flared brass horn on a small square wooden cabinet… crank handle… turned three-quarters to the left" |
| `telescope/` 48×72 | pixen | 3708 / `f911bb03-…` | 1 | — | "an antique brass telescope on a tall wooden tripod, the long brass tube tilted up…" (flip_h in the scene to aim at the window) |
| `globe_0.png` 32×48 | pixen | 3714 / `8c69481d-…` | 1 | — | "an antique world globe on a carved wooden floor stand with three curved legs and a brass meridian ring" |
| `record_crate/` 32×32 ×3 | pixen | 3715 `a57678cd-…`, 3716 `ae3e3f40-…`, 3717 `ed3e5403-…` | 3 | 2 / 1 | #0, #1 read as a chest with a lid; #2: "a wooden slatted crate made of horizontal planks, open top, no lid, no hinges, full of vinyl record sleeves standing upright…" |

Notes: inpaint keeps unmasked bytes → only the mask rect is pasted into the bedroom; edit states → only pixels that differ from the closed door inside the mask. The pro grid of `bookcase` was fetched as one 4×4 sheet from the gallery asset (job download expired) and split by script.
Screenshots: `_incoming/batch9/shots/{bedroom_full_v4,boudoir_full_v4,dressing_full_v4,lab_closeup}.png`, `garderobe_door_states.{gif,png}`, `gramophone_canary.gif`; layout `_incoming/layouts/layout_dressing_v3.png`; candidate sheets `_incoming/batch9/*_sheet.png`.

## 2026-10-20 (10) — Batch 10 (budget 75): study scale, trophy heads, chandelier, items

Spent **63** (balance 913 → 850). Style images: dressing `upload:04726783-…`, bedroom `upload:ddc0f33a-…`, boudoir `upload:45874cac-…` (batch 9 uploads). Raw output: `_incoming/batch10/` (candidate sheets `*_sheet.png`).

| Output | Tool | Seed / job | Cost | a / b | Prompt (subject) |
|---|---|---|---|---|---|
| `bookcase/` 52×104 (9) | `create_image_pro`, style = dressing | 3801 / `829126c5-2735-483e-95da-1f1b46b4d9b1` | 10 | 0 / 4 | "A very tall narrow gothic bookcase… seen strictly from the front… five shelves full of old leather books, glass jars of dried herbs, a pressed-flower herbarium album lying open… Much taller than wide" |
| `griffin/` 48×48 (25) | `create_image_pro`, style = bedroom | 3802 / `8773f496-f508-48ba-9776-e2a6cec34cc7` | 10 | 0 / 9 | "A mounted trophy head of a cute cartoon griffin on a wooden shield-shaped wall plaque… strictly from the front… big friendly round eyes… comical not scary… soft shadow under it" |
| `unicorn/` 48×48 (25) | same | 3803 / `c6b9a418-f1d6-4710-9c47-1b98e1e10156` | 10 | 16 / 1 | "…cute cartoon unicorn… spiral pearly golden horn, pastel pink and lilac mane… slightly offended sad expression… no blood" |
| `dragon/` 48×48 (25) | same | 3804 / `73b25f0c-ab76-4661-b006-bf7b1b0ba960` | 10 | 12 / 1 | "…cute small cartoon green dragon… two little curved horns… big goofy eyes, the mouth wide open showing a dark empty mouth with small blunt teeth" |
| `chandelier/` 80×80 (9) | `create_image_pro`, style = boudoir | 3805 / `d1860659-733d-48e3-8ef0-17e76df4fbaf` | 15 | 0 / 8 | "A gothic wrought iron chandelier… six white wax candles… many small clear crystal pendants and teardrop prisms… a short iron chain going up to the top edge" |
| `fallen_0.png` 80×80 | `edit_image_pro_flash` of chandelier 0 (`upload:e35ff851-…`) | 3809 / `e8ca301f-1835-4aa1-8a28-6deb3851c3ec` | 5 | — | "The same iron chandelier after it fell down: it lies crashed on the floor… bent ring, arms broken off, candles knocked over and snuffed out, crystal shards… One large clear triangular crystal prism lies intact in front" |
| `key_0.png` 24×24 | `create_image_pixen` | 3806 / `37c0f0da-…` | 1 | — | "a small old iron key with a round ornate bow and a simple bit, slightly rusty" |
| `prism_0.png` 24×24 | pixen | 3807 / `9fec0680-…` | 1 | — | "a clear glass crystal prism, triangular, faceted, with a tiny rainbow glint" |
| `ball_0.png` 20×20 | pixen | 3808 / `6d62ee3f-…` | 1 | — | "an old worn brown leather ball with stitched panels, scuffed, round" |

Notes: all picks trimmed to the alpha bbox. Swinging = rotation of the hanging sprite around the ceiling hook (`components/chandelier.gd`), no extra frames. lab_closeup not generated (temporary `bg_mortar_closeup_v3` until 18.11).
Screenshots: `_incoming/batch10/shots/{dressing_full_v5,bedroom_tidy,boudoir_tidy,dressing_tidy,trophy_heads}.png`, `chandelier_states.{gif,png}`.

### Pass 2 (20.10.2026): workbench (approved budget 15)

Spent **10** (850 → 840). Style image: dressing re-uploaded `upload:d2494b67-16ec-426e-af24-2cea562f44f5`.

| Output | Tool | Seed / job | Cost | a / b | Prompt (subject) |
|---|---|---|---|---|---|
| `workbench/` 136×72 (4) | `create_image_pro`, style = dressing | 2026102010 / `e70ab435-66a6-4e4d-bc11-a54c9c4ca59c` | 10 | 2 / 3 | "large wooden alchemist workbench, long rectangular table with thick dark oak top at waist height and sturdy carved legs, cluttered with glass flasks and retorts, a stone mortar and pestle, a small copper alembic, brass scales, a candle burner with a small flame, jars and scattered parchment notes, gothic castle furniture, front view slightly from above, warm candle light from the left…" |

Notes: the model drew the bench ~103 px wide on the 136 px canvas (asked 120–140); not scaled. All four candidates came out in a 3/4 view, not strictly frontal.
Screenshots: `_incoming/batch10/shots/{bedroom_v6,dressing_v6,workbench_a,workbench_b,sign_v6,trophy_wall_v6}.png`.

## 2026-10-20 (11) — Batch 11 (budget 50): heads, door, bow, ambient life

Spent **50** (balance 840 → 790). Style image: dressing `upload:d2494b67-…`. Raw output: `_incoming/batch11/`.

| Output | Tool | Seed / job | Cost | Pick | Prompt (subject) |
|---|---|---|---|---|---|
| `dragon/` 80×72 (9) | `create_image_pro`, style = dressing, ref = approved small dragon | 2026102011 / `b37894fd-7624-4a59-ba58-41c4e26778c6` | 15 | a #0 / b #2 | "large mounted dragon head trophy on a big wooden shield-shaped wall plaque, cute cartoonish small green dragon, two curved horns, big goofy friendly eyes, open toothy mouth… not scary… strictly from the front, soft shadow under it" |
| `bow_inpaint.png` 128×128 | `inpaint_image_pro_flash`, boudoir crop (392,0), mask (44,26,46,38) | 2026102012 / `c624f641-b9e7-4f1f-ba20-19126fd14f0e` | 6 | — | "Remove the pink ribbon bow: plain dark stone brick wall of the arch recess above the gothic window…" |
| `yawn.png` 60×72 | `edit_image_pro_flash` of the portrait | 2026102013 / `c9a56630-dfd5-4b49-932b-451462fc7549` | 5 | — | "…he is yawning: mouth wide open in a big sleepy yawn showing two white vampire fangs, eyes squeezed shut…" |
| `yawn_anim/` 4 frames | `animate_image`, first = portrait, last = yawn | 2026102018 / `8ec53131-9224-4a7f-aec2-16e7cf781991` | 1 | frames 1, 2 | "the painted vampire slowly opens his mouth into a big yawn; only the mouth moves" |
| `bat.png` 24×24 | `create_image_pixen` | 2026102014 / `7cd13d3a-…` | 1 | — | "a small cute dark purple bat flying, wings spread wide, seen from the front, tiny fangs" |
| `bat_fly/` 4 frames | `animate_image` | 2026102016 / `96f0c519-…` | 1 | 0–4 ping-pong | "bat flapping its wings up and down in flight, a smooth looping wing beat" |
| `mouse.png` 20×20 | pixen | 2026102015 / `6d4b4969-…` | 1 | — | "a small grey mouse running, side view facing right, long thin pink tail, round ears" |
| `mouse_run/` 4 frames | `animate_image` | 2026102017 / `b2c65a01-…` | 1 | 1–4 | "mouse running fast to the right, legs scurrying, tail swaying, looping run cycle in place" |
| `spider.png` 16×16 | pixen | 2026102019 / `2a8350b6-…` | 1 | — | "a tiny black house spider hanging, seen from above, eight thin legs" |
| `door_inpaint.png` 120×192 | `inpaint_image_pro_flash`, bedroom crop (400,72), mask (38,60,44,106) | 2026102020 / `7987b37e-8a12-4864-8f1b-e44fd4fd0bf6` | 6 | — | "A closed narrow double door of dark carved wood with a pointed gothic top, drawn as clean crisp pixel art with large simple readable shapes and few colours… No noise, no dithering" |
| `door_ajar.png`, `door_open.png` | `edit_image_pro_flash` of the new door crop | 2026102021 / `52b97c7d-…`, 2026102022 / `e1d1ae48-…` | 6 + 6 | — | "…now slightly ajar: the right door leaf has swung inward a little…" / "…now wide open: both door leaves have swung inward out of sight…" |

Notes: no scaling anywhere (the 75 % head copies from pass 2 are deleted). Eyes / lids drawn by script on the portrait's own palette (3×2 whites, 1 px pupil; lids = skin + lash line). Yawn overlays keep only the face pixels that changed and are opaque (the animated frames lost the painting's dark background inside the frame).
Screenshots / GIFs: `_incoming/batch11/shots/`.

## 2026-10-21 — Suite v2: one room per screen
- **Legacy** (used only in `scenes/rooms/princess_suite.tscn` until the 5 new rooms are ready): `room_princess_bedroom*.png` (incl. `_v5`, tracery, pillar), `room_princess_boudoir*.png` (incl. `_v2`), `room_princess_dressing*.png`.
- **Reused** in the new rooms: all approved furniture and props (`approved/props/**`, `items/**`, `creatures/**`, characters).

## 2026-10-21 (R1) — Bedroom v2: empty shell (budget 60)

Spent **54** (balance 790 → 736). Raw output: `_incoming/v2/bedroom/`. Variants (pending, one file each): `pending/rooms/v2/bedroom_shell_{a,b,c}.png`.

| Output | Tool | Seed / job | Cost | Note |
|---|---|---|---|---|
| `shell_px_1..4.png` 640×360 | `create_image_pixen` | 2026102101–04 / `1cbd2f2a-…`, `712eaac9-…`, `71ba4b8f-…`, `8cb61604-…` | 4 × 1 | all four split the frame into two bays with a central pier (the §3.5 pixen habit) → **c** = #4 kept only for comparison |
| `shell_pro_1.png` → **a** | `create_image_pro`, style = `approved/room_princess_boudoir.png`, reference = own flat layout sketch (`layout_sketch.png`, "layout and composition only") | 2026102111 / `bb43f68b-b430-49e5-8444-08e9d3f4c39b` | 25 | one room, arcade of slim pilasters, torn wallpaper |
| `shell_pro_2.png` → **b** | same | 2026102112 / `008db344-564d-4dc4-8ce6-e4572f7bbb67` | 25 | one room, wide plain centre wall with wallpaper panels (recommended) |

Prompt (pixen, Alexander's): "bare empty stone room shell of a gothic castle tower chamber, single cohesive room filling a wide 16:9 frame, back wall facing the viewer straight-on, two tall pointed gothic windows placed symmetrically with night sky and moonlight, empty plain center of the back wall, faded torn pink rose wallpaper panels between stone pilasters, a small pointed arched wooden door in the back wall right of center, open arched doorways in the left and right side walls, wide dark wooden plank floor across the whole foreground, ribbed vaulted ceiling, cobwebs only in the upper corners, diorama camera slightly from above, completely empty: no furniture, no bed, no fireplace, no rug, no candles, no curtains, no characters, nothing on the floor". Pro: the same + "ONE single cohesive room … no pillars or columns in the middle of the image … no torches, no paintings".
Lesson: for one-room shells pixen keeps drawing two bays; a flat-colour layout sketch as a pro reference (composition only) fixes the composition.

## 2026-10-21 (R1-bis) — Bedroom v2: windowless shell (budget 50)

Spent **50** (balance 736 → 686). Variants: `pending/rooms/v2/bedroom_shell_{d,e}.png` (a/b/c with windows are superseded).

| Output | Tool | Seed / job | Cost |
|---|---|---|---|
| `shell_pro_nowin_1.png` → **d** | `create_image_pro`, style = `pending/rooms/v2/bedroom_shell_a.png`, reference = own flat layout sketch `layout_sketch_nowin.png` (composition only) | 2026102121 / `111db883-3422-4cee-972d-63683010cab0` | 25 |
| `shell_pro_nowin_2.png` → **e** | same | 2026102122 / `d127fa1e-d872-4388-9512-b4e7fbe2e3fd` | 25 |

Prompt (Alexander's): "bare empty stone room shell of a windowless gothic castle chamber, single cohesive room filling a wide 16:9 frame, back wall facing the viewer straight-on, NO windows, faded torn pink rose wallpaper panels between stone pilasters, a small pointed arched wooden door in the back wall right of center, a built-in stone fireplace with carved gargoyles on the left part of the wall (empty hearth, no fire), an open arched doorway in the right side wall, wide dark wooden plank floor across the whole foreground, ribbed vaulted ceiling, cobwebs only in the upper corners, warm dim lighting, no moonlight, diorama camera slightly from above, completely empty: no furniture, no bed, no rug, no candles, no characters, nothing on the floor".

## 2026-10-21 (R1-ter) — Bedroom v2 by Alexander's scheme (budget 50)

Spent **50** (balance 686 → 636). Variants: `pending/rooms/v2/bedroom_shell_{f,g}.png`; `e` → `_incoming/reserve/bedroom_shell_e.png` (out of git).

| Output | Tool | Seed / job | Cost |
|---|---|---|---|
| `shell_pro_v3_1.png` → **f** | `create_image_pro`, style = `approved/room_princess_boudoir.png` (palette), reference = own flat layout sketch `layout_sketch_v3.png` (fireplace on the left side wall, one continuous back wall, door near its right end, doorway on the right wall; composition only) | 2026102131 / `06cae986-1e32-468a-bc92-e46343092554` | 25 |
| `shell_pro_v3_2.png` → **g** | same | 2026102132 / `414f5922-95a2-4b38-9504-d2644951b6c7` | 25 |

Prompt: Alexander's R1-ter prompt (one wide continuous back wall with pilasters only at the corners, door near the right end, fireplace with gargoyles and chimney breast on the LEFT side wall, doorway on the RIGHT side wall, muted lilac-grey stone, no windows, completely empty). Both shells came with baked wall sconces with lit candles (f: 3, g: 2) despite "no candles".

## 2026-10-21 (R2) — Bedroom v2: big furniture

- `approved/rooms/v2/bedroom_shell.png` = shell **g** (approved 21.10.2026); f → `_incoming/reserve/`, a–d → `_incoming/rejected/v2/`.
- Spent **5** (636 → 631): `pending/props/v2/folding_screen_dress.png` 40×65 — `edit_image_pro_flash` of `approved/props/folding_screen_v2.png` (padded to 40×68), seed 2026102141 / `ac43f383-59ca-434d-a5d4-03bd6b9b62bb`: "The same folding screen with a frilly pale pink princess ball gown draped over its top edge, hanging down the front of the left and middle panels, soft folds and a little lace; keep the screen's frame, panels, colours, size, outline and lighting exactly the same".
- Reused (approved): bed_princess (+blanket, shadow), nightstand_drawer_closed ×2, painting_count + count/eyes_v2, chest, tiger_skin_rug, bedside_rug_v2.

## 2026-10-21 (R3) — Bedroom v2: decor, fire, doors (budget 60)

Spent **51** (631 → 580). Reference for style / look: `docs/reference/bedroom_ref_alexander.png` (Alexander's own generation), style image = approved bedroom shell. All in `pending/props/v2/bedroom/` (variants b next to a).

| File | Tool | Seed / job | Cost | Prompt (subject) |
|---|---|---|---|---|
| `nightstand.png` 30×47 (#2), `nightstand_b.png` (#13) | `create_image_pro` 44×56 (25), ref = Alexander's bedroom | 2026102151 / `2cbecc84-3671-4e6c-b8e3-bb47947abe0c` | 10 | "a gothic bedside nightstand: small dark carved wooden cabinet with one drawer, curved wrought iron legs, a single tall white wax candle in a small brass candlestick on top (unlit)…" |
| `wall_clock.png` 24×55 (#15) | same, 36×64 | 2026102152 / `6584d954-47c0-4694-89a9-13696a5d455b` | 10 | "a gothic wooden wall clock with a long pendulum case… round cream clock face with roman numerals but NO clock hands… an EMPTY pendulum space"; hands at 3:09 drawn by script (2 short lines, like the portrait lids) |
| `rug_main.png` 168×48 (#1), `rug_main_b.png` (#0) | same, 168×48 | 2026102153 / `63385e89-ac56-44e0-90ef-1f94a1f19e60` | 10 | "a large rectangular faded burgundy and rose oriental rug with an ornate patterned border and short fringe… flat on the floor in floor perspective" |
| `firewood.png`, `banner_welcome.png` (no text), `garland.png`, `clock_pendulum.png`, `wall_candelabra.png`, `scrolls.png`, `book.png`, `flask.png` | `create_image_pixen` ×9 (one garland redone: the first came with a background scene) | 2026102154–62 | 9 | firewood logs; pale pink cloth banner, gold fringe, NO text; pink-gold tinsel garland arc; brass pendulum; iron wall candelabra 3 candles; scrolls; leather book; fallen perfume flask |
| `garderobe_door_{ajar,open}.png` 120×124 overlays | `edit_image_pro_flash` of the shell crop (404,140) | 2026102171 / `e06f4499-…`, 2026102172 / `2a826e4a-…` | 12 | "…slightly ajar: the door leaf has swung inward a little…" / "…wide open: … dark narrow doorway…"; only the doorway pixels kept (mask from the dark opening) |

Round rug `approved/props/bedside_rug_v2.png` → not used in the bedroom any more (reserve).
