# AI Vehicles — module M14

- **Spec:** `docs/specs/M14-ai.md` (read the task you were given)
- **Design:** `docs/gdd/24-ai-and-factions.md`, `docs/gdd/17-controls.md`
- **Kind:** simulation
- **Public surface:** `ai_api.gd` (`class_name AiApi`) and `public/`

## Owns

- AI driver and AI gunner (issue the same Orders as the player)
- Squads and RTS orders
- Enemy stance, Combat Rating, allied AI rules

## Uses (the only things this module may reference)

- `game/core/`
- `vehicle`: its `vehicle_api.gd` and `public/` only
- `mobility`: its `mobility_api.gd` and `public/` only
- `weapons`: its `weapons_api.gd` and `public/` only
- `detection`: its `detection_api.gd` and `public/` only
- `crew`: its `crew_api.gd` and `public/` only

## Must not

- Reference any module not listed under **Uses**.
- Reach into another module's `internal/`, `data/` or `scenes/`, or use node paths into another module's nodes.
- Put gameplay numbers in code (they belong in `data/*.tres`).
- Edit files outside this folder (except appending to `docs/open-questions.md`).
- Read `Input` directly (only `controls` reads input; everything else receives Orders).
- Depend on UI: no references to `controls`, `builder`, `hud` or `audio`.

## Folder layout

```
ai_api.gd   public entry point
public/     data types other modules may use
internal/   private implementation
data/       .tres files
scenes/     demo_ai.tscn and private scenes
tests/      gdUnit4 tests
```

## Status

Update this list at the end of every task (check the box, add one line on what's next).

- [ ] M14-T1 AI driver
- [ ] M14-T2 AI gunner
- [ ] M14-T3 Squads and orders
- [ ] M14-T4 Enemy stance and Combat Rating
- [ ] M14-T5 Allied AI rules
- [ ] M14-T6 Blueprint pools, factions and morale
