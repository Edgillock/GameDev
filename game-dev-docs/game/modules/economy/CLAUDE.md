# Economy & Home Base — module M17

- **Spec:** `docs/specs/M17-economy.md` (read the task you were given)
- **Design:** `docs/gdd/21-economy.md`
- **Kind:** meta
- **Public surface:** `economy_api.gd` (`class_name EconomyApi`) and `public/`

## Owns

- Inventory, materials, Scrip
- Crafting, manufacturing queue, Home Base sectors
- Farms, extractors, trade, contracts, salvage returns

## Uses (the only things this module may reference)

- `game/core/`
- `blueprint`: its `blueprint_api.gd` and `public/` only
- `progression`: its `progression_api.gd` and `public/` only

## Must not

- Reference any module not listed under **Uses**.
- Reach into another module's `internal/`, `data/` or `scenes/`, or use node paths into another module's nodes.
- Put gameplay numbers in code (they belong in `data/*.tres`).
- Edit files outside this folder (except appending to `docs/open-questions.md`).
- Read `Input` directly (only `controls` reads input; everything else receives Orders).
- Depend on UI: no references to `controls`, `builder`, `hud` or `audio`.

## Folder layout

```
economy_api.gd   public entry point
public/          data types other modules may use
internal/        private implementation
data/            .tres files
scenes/          demo_economy.tscn and private scenes
tests/           gdUnit4 tests
```

## Status

Update this list at the end of every task (check the box, add one line on what's next).

- [ ] M17-T1 Inventory, materials and Scrip
- [ ] M17-T2 Crafting and manufacturing queue
- [ ] M17-T3 Home Base sectors
- [ ] M17-T4 Farms, extractors, trade and contracts
