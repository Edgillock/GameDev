# Core — module M01

- **Spec:** `docs/specs/M01-core.md` (read the task you were given)
- **Design:** `docs/gdd/01-glossary.md`, `docs/gdd/40-tech.md`
- **Kind:** core
- **Public surface:** core (everything in game/core is public)

## Owns

- Services autoload, Log, Rng, GameClock
- Stats and the modifier pipeline
- MaterialDef, AdhesiveDef, PartDef base, the data Registry
- Order types, VehicleSystem base, core interfaces (PowerQuery, CrewQuery, EnvironmentQuery, Unlocks, Saveable)

## Uses (the only things this module may reference)

- Godot engine APIs only. Core depends on no module.

## Must not

- Reference anything under `game/modules/`. Core must stay at the bottom of the graph.
- Grow without a spec task or an accepted change request (CR-xx). Every addition to core affects every module.
- Put gameplay numbers in code.

## Status

Update this list at the end of every task (check the box, add one line on what's next).

- [ ] M01-T1 Services, Log, Rng and GameClock
- [ ] M01-T2 Stats and modifiers
- [ ] M01-T3 Materials, part definitions and the data registry
- [ ] M01-T4 Orders, VehicleSystem base and core interfaces
