# Progression — module M16

- **Spec:** `docs/specs/M16-progression.md` (read the task you were given)
- **Design:** `docs/gdd/23-progression.md`
- **Kind:** meta
- **Public surface:** `progression_api.gd` (`class_name ProgressionApi`) and `public/`

## Owns

- Knowledge and Device unlock graph; writes core Unlocks
- Research Puzzle framework
- Reverse Engineering odds

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
progression_api.gd   public entry point
public/              data types other modules may use
internal/            private implementation
data/                .tres files
scenes/              demo_progression.tscn and private scenes
tests/               gdUnit4 tests
```

## Status

Update this list at the end of every task (check the box, add one line on what's next).

- [ ] M16-T1 Unlock graph and Unlocks writer
- [ ] M16-T2 Research Puzzle framework
- [ ] M16-T3 Reverse Engineering
