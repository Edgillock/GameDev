# Vehicle Runtime — module M04

- **Spec:** `docs/specs/M04-vehicle.md` (read the task you were given)
- **Design:** `docs/gdd/10-vehicle-structure.md`, `docs/gdd/13-damage.md`
- **Kind:** simulation
- **Public surface:** `vehicle_api.gd` (`class_name VehicleApi`) and `public/`

## Owns

- Spawning a blueprint as one Jolt rigid body with per-part collision
- Per-part runtime state (hp, is_active, temperature) and vehicle Noise
- Attaching registered VehicleSystems; routing Orders
- Spawning debris when groups detach

## Uses (the only things this module may reference)

- `game/core/`
- `blueprint`: its `blueprint_api.gd` and `public/` only
- `structure`: its `structure_api.gd` and `public/` only

## Must not

- Reference any module not listed under **Uses**.
- Reach into another module's `internal/`, `data/` or `scenes/`, or use node paths into another module's nodes.
- Put gameplay numbers in code (they belong in `data/*.tres`).
- Edit files outside this folder (except appending to `docs/open-questions.md`).
- Read `Input` directly (only `controls` reads input; everything else receives Orders).
- Depend on UI: no references to `controls`, `builder`, `hud` or `audio`.

## Folder layout

```
vehicle_api.gd   public entry point
public/          data types other modules may use
internal/        private implementation
data/            .tres files
scenes/          demo_vehicle.tscn and private scenes
tests/           gdUnit4 tests
```

## Status

Update this list at the end of every task (check the box, add one line on what's next).

- [ ] M04-T1 Spawn a blueprint as a physics body
- [ ] M04-T2 Part state, systems and order routing
- [ ] M04-T3 Damage hooks and detaching debris
