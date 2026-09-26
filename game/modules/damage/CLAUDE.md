# Damage — module M09

- **Spec:** `docs/specs/M09-damage.md` (read the task you were given)
- **Design:** `docs/gdd/13-damage.md`, `docs/gdd/11-mobility.md`
- **Kind:** simulation
- **Public surface:** `damage_api.gd` (`class_name DamageApi`) and `public/`

## Owns

- Damage payloads and the five resolvers
- Heat model
- Destruction blasts
- Ramming damage

## Uses (the only things this module may reference)

- `game/core/`
- `vehicle`: its `vehicle_api.gd` and `public/` only
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
damage_api.gd   public entry point
public/         data types other modules may use
internal/       private implementation
data/           .tres files
scenes/         demo_damage.tscn and private scenes
tests/          gdUnit4 tests
```

## Status

Update this list at the end of every task (check the box, add one line on what's next).

- [ ] M09-T1 Damage payloads, HP and destruction blasts
- [ ] M09-T2 Kinetic resolver
- [ ] M09-T3 Explosive resolver and overpressure
- [ ] M09-T4 Heat model and thermal resolver
- [ ] M09-T5 Chemical resolver
- [ ] M09-T6 Matter-wave resolver
- [ ] M09-T7 Ramming
