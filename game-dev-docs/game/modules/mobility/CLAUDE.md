# Mobility — module M05

- **Spec:** `docs/specs/M05-mobility.md` (read the task you were given)
- **Design:** `docs/gdd/11-mobility.md`
- **Kind:** simulation
- **Public surface:** `mobility_api.gd` (`class_name MobilityApi`) and `public/`

## Owns

- Running Gear definitions
- Suspension casts, drive, steering, grip, overload
- HP performance curves for running gear; procedural track visuals

## Uses (the only things this module may reference)

- `game/core/`
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
mobility_api.gd   public entry point
public/           data types other modules may use
internal/         private implementation
data/             .tres files
scenes/           demo_mobility.tscn and private scenes
tests/            gdUnit4 tests
```

## Status

Update this list at the end of every task (check the box, add one line on what's next).

- [ ] M05-T1 Suspension and ground contact
- [ ] M05-T2 Drive, steering, grip and overload
- [ ] M05-T3 HP performance curves and procedural track visuals
