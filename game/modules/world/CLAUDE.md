# World — module M13

- **Spec:** `docs/specs/M13-world.md` (read the task you were given)
- **Design:** `docs/gdd/20-world.md`
- **Kind:** meta
- **Public surface:** `world_api.gd` (`class_name WorldApi`) and `public/`

## Owns

- Ground types on terrain; EnvironmentQuery implementation
- Day/night, weather, Time Acceleration
- Maps and biome effects/events

## Uses (the only things this module may reference)

- `game/core/`
- `vehicle`: its `vehicle_api.gd` and `public/` only
- `damage`: its `damage_api.gd` and `public/` only

## Must not

- Reference any module not listed under **Uses**.
- Reach into another module's `internal/`, `data/` or `scenes/`, or use node paths into another module's nodes.
- Put gameplay numbers in code (they belong in `data/*.tres`).
- Edit files outside this folder (except appending to `docs/open-questions.md`).
- Read `Input` directly (only `controls` reads input; everything else receives Orders).
- Depend on UI: no references to `controls`, `builder`, `hud` or `audio`.

## Folder layout

```
world_api.gd   public entry point
public/        data types other modules may use
internal/      private implementation
data/          .tres files
scenes/        demo_world.tscn and private scenes
tests/         gdUnit4 tests
```

## Status

Update this list at the end of every task (check the box, add one line on what's next).

- [ ] M13-T1 Ground types and the environment service
- [ ] M13-T2 Day, night, weather and Time Acceleration
- [ ] M13-T3 Region 1 test map
- [ ] M13-T4 Biome effects and events
