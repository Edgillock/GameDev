# Controls — module M06

- **Spec:** `docs/specs/M06-controls.md` (read the task you were given)
- **Design:** `docs/gdd/17-controls.md`, `docs/gdd/14-weapons.md`
- **Kind:** presentation
- **Public surface:** `controls_api.gd` (`class_name ControlsApi`) and `public/`

## Owns

- Input Map actions (the only module that reads Input)
- Drive view, first-person and free cameras; Command view camera
- Turning input into Orders: driving, Activation Groups, Squads

## Uses (the only things this module may reference)

- `game/core/`
- `vehicle`: its `vehicle_api.gd` and `public/` only
- `ai`: its `ai_api.gd` and `public/` only

## Must not

- Reference any module not listed under **Uses**.
- Reach into another module's `internal/`, `data/` or `scenes/`, or use node paths into another module's nodes.
- Put gameplay numbers in code (they belong in `data/*.tres`).
- Edit files outside this folder (except appending to `docs/open-questions.md`).

## Folder layout

```
controls_api.gd   public entry point
public/           data types other modules may use
internal/         private implementation
data/             .tres files
scenes/           demo_controls.tscn and private scenes
tests/            gdUnit4 tests
```

## Status

Update this list at the end of every task (check the box, add one line on what's next).

- [ ] M06-T1 Input actions and Flagship driving
- [ ] M06-T2 Cameras: orbit, first person, free
- [ ] M06-T3 Activation Group input
- [ ] M06-T4 Command view and Squad input
