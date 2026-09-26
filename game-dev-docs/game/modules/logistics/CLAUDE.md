# Logistics — module M18

- **Spec:** `docs/specs/M18-logistics.md` (read the task you were given)
- **Design:** `docs/gdd/22-logistics.md`
- **Kind:** meta
- **Public surface:** `logistics_api.gd` (`class_name LogisticsApi`) and `public/`

## Owns

- Logistics Nodes, storage, transports, routes, Raids

## Uses (the only things this module may reference)

- `game/core/`
- `vehicle`: its `vehicle_api.gd` and `public/` only
- `ai`: its `ai_api.gd` and `public/` only
- `economy`: its `economy_api.gd` and `public/` only

## Must not

- Reference any module not listed under **Uses**.
- Reach into another module's `internal/`, `data/` or `scenes/`, or use node paths into another module's nodes.
- Put gameplay numbers in code (they belong in `data/*.tres`).
- Edit files outside this folder (except appending to `docs/open-questions.md`).
- Read `Input` directly (only `controls` reads input; everything else receives Orders).
- Depend on UI: no references to `controls`, `builder`, `hud` or `audio`.

## Folder layout

```
logistics_api.gd   public entry point
public/            data types other modules may use
internal/          private implementation
data/              .tres files
scenes/            demo_logistics.tscn and private scenes
tests/             gdUnit4 tests
```

## Status

Update this list at the end of every task (check the box, add one line on what's next).

- [ ] M18-T1 Nodes and storage
- [ ] M18-T2 Transports and routes
- [ ] M18-T3 Raids and node defenses
