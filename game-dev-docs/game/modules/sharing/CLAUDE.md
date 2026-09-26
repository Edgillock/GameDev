# Blueprint Sharing — module M22

- **Spec:** `docs/specs/M22-sharing.md` (read the task you were given)
- **Design:** `docs/gdd/40-tech.md`
- **Kind:** meta
- **Public surface:** `sharing_api.gd` (`class_name SharingApi`) and `public/`

## Owns

- Blueprint export/import files
- Certification Trials and Rated Stats

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
sharing_api.gd   public entry point
public/          data types other modules may use
internal/        private implementation
data/            .tres files
scenes/          demo_sharing.tscn and private scenes
tests/           gdUnit4 tests
```

## Status

Update this list at the end of every task (check the box, add one line on what's next).

- [ ] M22-T1 Blueprint export and import
- [ ] M22-T2 Certification Trials
