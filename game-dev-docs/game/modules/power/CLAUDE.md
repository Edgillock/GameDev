# Power — module M08

- **Spec:** `docs/specs/M08-power.md` (read the task you were given)
- **Design:** `docs/gdd/12-power.md`
- **Kind:** simulation
- **Public surface:** `power_api.gd` (`class_name PowerApi`) and `public/`

## Owns

- Power part definitions
- Power network analysis (blueprint-level) and the runtime PowerSystem
- Fuel, malfunctions, overheating of power parts, priority groups

## Uses (the only things this module may reference)

- `game/core/`
- `blueprint`: its `blueprint_api.gd` and `public/` only
- `vehicle`: its `vehicle_api.gd` and `public/` only

## Must not

- Reference any module not listed under **Uses**.
- Reach into another module's `internal/`, `data/` or `scenes/`, or use node paths into another module's nodes.
- Put gameplay numbers in code (they belong in `data/*.tres`).
- Edit files outside this folder (except appending to `docs/open-questions.md`).
- Read `Input` directly (only `controls` reads input; everything else receives Orders).
- Depend on UI: no references to `controls`, `builder`, `hud` or `audio`.

## Folder layout

```
power_api.gd   public entry point
public/        data types other modules may use
internal/      private implementation
data/          .tres files
scenes/        demo_power.tscn and private scenes
tests/         gdUnit4 tests
```

## Status

Update this list at the end of every task (check the box, add one line on what's next).

- [ ] M08-T1 Power part definitions
- [ ] M08-T2 Power network analysis
- [ ] M08-T3 Runtime power system and fuel
- [ ] M08-T4 Malfunctions and overheating
- [ ] M08-T5 Power priority groups and budget report
