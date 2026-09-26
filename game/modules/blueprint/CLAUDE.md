# Blueprint — module M02

- **Spec:** `docs/specs/M02-blueprint.md` (read the task you were given)
- **Design:** `docs/gdd/10-vehicle-structure.md`, `docs/gdd/18-builder.md`
- **Kind:** data
- **Public surface:** `blueprint_api.gd` (`class_name BlueprintApi`) and `public/`

## Owns

- The vehicle as pure data (parts, positions, sizes, facing, links, module props)
- Versioned blueprint files and migrations
- Blueprint validation (Command Module, Weight Class caps)

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
blueprint_api.gd   public entry point
public/            data types other modules may use
internal/          private implementation
data/              .tres files
scenes/            demo_blueprint.tscn and private scenes
tests/             gdUnit4 tests
```

## Status

Update this list at the end of every task (check the box, add one line on what's next).

- [ ] M02-T1 Blueprint data model
- [ ] M02-T2 Versioned save and load
- [ ] M02-T3 Validation
