# Structure — module M03

- **Spec:** `docs/specs/M03-structure.md` (read the task you were given)
- **Design:** `docs/gdd/10-vehicle-structure.md`
- **Kind:** data
- **Public surface:** `structure_api.gd` (`class_name StructureApi`) and `public/`

## Owns

- Bonds between touching boxes (ownership, overlap area, effective strength)
- Connectivity graph and detached groups
- Mass, center of mass and inertia

## Uses (the only things this module may reference)

- `game/core/`
- `blueprint`: its `blueprint_api.gd` and `public/` only

## Must not

- Reference any module not listed under **Uses**.
- Reach into another module's `internal/`, `data/` or `scenes/`, or use node paths into another module's nodes.
- Put gameplay numbers in code (they belong in `data/*.tres`).
- Edit files outside this folder (except appending to `docs/open-questions.md`).
- Read `Input` directly (only `controls` reads input; everything else receives Orders).
- Depend on UI: no references to `controls`, `builder`, `hud` or `audio`.

## Folder layout

```
structure_api.gd   public entry point
public/            data types other modules may use
internal/          private implementation
data/              .tres files
scenes/            demo_structure.tscn and private scenes
tests/             gdUnit4 tests
```

## Status

Update this list at the end of every task (check the box, add one line on what's next).

- [ ] M03-T1 Bond computation
- [ ] M03-T2 Connectivity, detached groups and mass properties
