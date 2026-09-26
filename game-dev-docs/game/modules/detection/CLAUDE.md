# Detection — module M11

- **Spec:** `docs/specs/M11-detection.md` (read the task you were given)
- **Design:** `docs/gdd/15-detection.md`
- **Kind:** simulation
- **Public surface:** `detection_api.gd` (`class_name DetectionApi`) and `public/`

## Owns

- Observation Ports and the ray scheduler
- The detection rule, Noise decay, Concealment, night
- Contacts per faction; Recon Scan; paint definitions

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
detection_api.gd   public entry point
public/            data types other modules may use
internal/          private implementation
data/              .tres files
scenes/            demo_detection.tscn and private scenes
tests/             gdUnit4 tests
```

## Status

Update this list at the end of every task (check the box, add one line on what's next).

- [ ] M11-T1 Observation Ports and the ray scheduler
- [ ] M11-T2 Detection rule, Noise, Concealment and night
- [ ] M11-T3 Recon Scan
