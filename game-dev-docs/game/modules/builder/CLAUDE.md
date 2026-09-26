# Builder — module M07

- **Spec:** `docs/specs/M07-builder.md` (read the task you were given)
- **Design:** `docs/gdd/18-builder.md`, `docs/gdd/10-vehicle-structure.md`, `docs/gdd/12-power.md`, `docs/gdd/14-weapons.md`
- **Kind:** presentation
- **Public surface:** `builder_api.gd` (`class_name BuilderApi`) and `public/`

## Owns

- The build mode scene and tools
- Placing, resizing, chamfering, selecting, mirroring
- Builder-side views of power, weapons and paint

## Uses (the only things this module may reference)

- `game/core/`
- `blueprint`: its `blueprint_api.gd` and `public/` only
- `structure`: its `structure_api.gd` and `public/` only
- `vehicle`: its `vehicle_api.gd` and `public/` only
- `controls`: its `controls_api.gd` and `public/` only
- `power`: its `power_api.gd` and `public/` only
- `weapons`: its `weapons_api.gd` and `public/` only
- `detection`: its `detection_api.gd` and `public/` only

## Must not

- Reference any module not listed under **Uses**.
- Reach into another module's `internal/`, `data/` or `scenes/`, or use node paths into another module's nodes.
- Put gameplay numbers in code (they belong in `data/*.tres`).
- Edit files outside this folder (except appending to `docs/open-questions.md`).
- Read `Input` directly (only `controls` reads input; everything else receives Orders).

## Folder layout

```
builder_api.gd   public entry point
public/          data types other modules may use
internal/        private implementation
data/            .tres files
scenes/          demo_builder.tscn and private scenes
tests/           gdUnit4 tests
```

## Status

Update this list at the end of every task (check the box, add one line on what's next).

- [ ] M07-T1 Builder scene, grid and part placement
- [ ] M07-T2 Resize and chamfer
- [ ] M07-T3 Selection, copy/paste, undo/redo, mirror, presets
- [ ] M07-T4 Save, load, validate and test drive
- [ ] M07-T5 Power tools
- [ ] M07-T6 Weapon placement, Ammo Rack binding and Activation Group assignment
- [ ] M07-T7 Paint and appearance
