# Save/Load — module M15

- **Spec:** `docs/specs/M15-save.md` (read the task you were given)
- **Design:** `docs/gdd/40-tech.md`
- **Kind:** meta
- **Public surface:** `save_api.gd` (`class_name SaveApi`) and `public/`

## Owns

- Save slots and the versioned save file
- Collecting state from every Saveable

## Uses (the only things this module may reference)

- `game/core/`

## Must not

- Reference any module not listed under **Uses**.
- Reach into another module's `internal/`, `data/` or `scenes/`, or use node paths into another module's nodes.
- Put gameplay numbers in code (they belong in `data/*.tres`).
- Edit files outside this folder (except appending to `docs/open-questions.md`).
- Read `Input` directly (only `controls` reads input; everything else receives Orders).
- Depend on UI: no references to `controls`, `builder`, `hud` or `audio`.

## Folder layout

```
save_api.gd   public entry point
public/       data types other modules may use
internal/     private implementation
data/         .tres files
scenes/       demo_save.tscn and private scenes
tests/        gdUnit4 tests
```

## Status

Update this list at the end of every task (check the box, add one line on what's next).

- [ ] M15-T1 Save service and file format
- [ ] M15-T2 Module save participants
