# Crew — module M12

- **Spec:** `docs/specs/M12-crew.md` (read the task you were given)
- **Design:** `docs/gdd/16-crew.md`
- **Kind:** simulation
- **Public surface:** `crew_api.gd` (`class_name CrewApi`) and `public/`

## Owns

- Crew data, roles, proficiency and XP
- Crew bonuses as stat modifiers; CrewQuery implementation
- Crew Compartments and consumables; Workshop Module rules

## Uses (the only things this module may reference)

- `game/core/`
- `vehicle`: its `vehicle_api.gd` and `public/` only

## Must not

- Reference any module not listed under **Uses**.
- Reach into another module's `internal/`, `data/` or `scenes/`, or use node paths into another module's nodes.
- Put gameplay numbers in code (they belong in `data/*.tres`).
- Edit files outside this folder (except appending to `docs/open-questions.md`).
- Read `Input` directly (only `controls` reads input; everything else receives Orders).
- Depend on UI: no references to `controls`, `builder`, `hud` or `audio`.

## Folder layout

```
crew_api.gd   public entry point
public/       data types other modules may use
internal/     private implementation
data/         .tres files
scenes/       demo_crew.tscn and private scenes
tests/        gdUnit4 tests
```

## Status

Update this list at the end of every task (check the box, add one line on what's next).

- [ ] M12-T1 Crew data, roles and proficiency
- [ ] M12-T2 Gunnery crew and trainees
- [ ] M12-T3 Powertrain and Maintenance crews
- [ ] M12-T4 Recon and Salvage crews
- [ ] M12-T5 Crew Compartments, consumables and recruitment
