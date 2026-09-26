# HUD & Menus — module M19

- **Spec:** `docs/specs/M19-hud.md` (read the task you were given)
- **Design:** `docs/gdd/14-weapons.md`, `docs/gdd/17-controls.md`, `docs/gdd/30-art-audio.md`
- **Kind:** presentation
- **Public surface:** `hud_api.gd` (`class_name HudApi`) and `public/`

## Owns

- All in-game interface screens; reads module APIs only

## Uses (the only things this module may reference)

- `game/core/`
- `vehicle`: its `vehicle_api.gd` and `public/` only
- `power`: its `power_api.gd` and `public/` only
- `weapons`: its `weapons_api.gd` and `public/` only
- `detection`: its `detection_api.gd` and `public/` only
- `crew`: its `crew_api.gd` and `public/` only
- `world`: its `world_api.gd` and `public/` only
- `ai`: its `ai_api.gd` and `public/` only
- `economy`: its `economy_api.gd` and `public/` only
- `progression`: its `progression_api.gd` and `public/` only
- `logistics`: its `logistics_api.gd` and `public/` only

## Must not

- Reference any module not listed under **Uses**.
- Reach into another module's `internal/`, `data/` or `scenes/`, or use node paths into another module's nodes.
- Put gameplay numbers in code (they belong in `data/*.tres`).
- Edit files outside this folder (except appending to `docs/open-questions.md`).
- Read `Input` directly (only `controls` reads input; everything else receives Orders).

## Folder layout

```
hud_api.gd   public entry point
public/      data types other modules may use
internal/    private implementation
data/        .tres files
scenes/      demo_hud.tscn and private scenes
tests/       gdUnit4 tests
```

## Status

Update this list at the end of every task (check the box, add one line on what's next).

- [ ] M19-T1 Activation Group bar
- [ ] M19-T2 Driving HUD
- [ ] M19-T3 Menus and pause
- [ ] M19-T4 Minimap and weather
