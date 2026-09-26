# Weapons — module M10

- **Spec:** `docs/specs/M10-weapons.md` (read the task you were given)
- **Design:** `docs/gdd/14-weapons.md`
- **Kind:** simulation
- **Public surface:** `weapons_api.gd` (`class_name WeaponsApi`) and `public/`

## Owns

- Weapon, Ammo Rack and ammo definitions
- Aiming, traverse, firing, projectiles, reload, recoil
- Power Modes and the Control Theory gate
- Activation Groups

## Uses (the only things this module may reference)

- `game/core/`
- `blueprint`: its `blueprint_api.gd` and `public/` only
- `vehicle`: its `vehicle_api.gd` and `public/` only
- `power`: its `power_api.gd` and `public/` only
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
weapons_api.gd   public entry point
public/          data types other modules may use
internal/        private implementation
data/            .tres files
scenes/          demo_weapons.tscn and private scenes
tests/           gdUnit4 tests
```

## Status

Update this list at the end of every task (check the box, add one line on what's next).

- [ ] M10-T1 Weapon and Ammo Rack definitions, mounting and traverse
- [ ] M10-T2 Firing, projectiles, reload and recoil
- [ ] M10-T3 Ammo types and damage components
- [ ] M10-T4 Power Modes and the Control Theory gate
- [ ] M10-T5 Activation Groups
- [ ] M10-T6 Directed Energy, Area Denial and EW weapons
