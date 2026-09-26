# M16 · Progression

- **Status:** DRAFT — T1 (except Weight Class unlocks, OQ-02) and T3 can be built; T2 needs OQ-21
- **Folder:** `game/modules/progression/`
- **Uses:** core
- **Design:** `docs/gdd/23-progression.md`, `docs/gdd/21-economy.md` (Reverse Engineering)

## Purpose

Owns the unlock graph (Knowledge and Devices), is the **only writer** of core `Unlocks`, runs Research Puzzles, and tracks Reverse Engineering odds.

## Public API sketch

```gdscript
class_name ProgressionApi
static func register() -> void
static func grant(unlock_id: StringName, source: StringName) -> void    # story, pickup, puzzle, reverse engineering
static func can_unlock(unlock_id: StringName) -> bool                   # prerequisites met
static func start_puzzle(unlock_id: StringName, stage: int) -> ResearchPuzzle
static func reverse_engineering_chance(unlock_id: StringName) -> float
static func add_exposure(unlock_id: StringName, amount: float, source: StringName) -> void
static func roll_reverse_engineering(unlock_id: StringName) -> bool     # the caller (economy's trial build) has already taken the materials
```

Public types: `KnowledgeDef`, `DeviceDef` (id, display name, prerequisites, stages, puzzle ids, effects description), `ResearchPuzzle`.

## Tasks

### M16-T1 · Unlock graph and Unlocks writer (READY once OQ-02 is answered; the rest can be built now)

- Knowledge and Device defs for every item in 23-progression, with prerequisites (e.g. drone swarms need Computer Vision + Control Theory + Aeronautics; logistics needs Control Theory + Satellite Uplink).
- `grant()` checks prerequisites, writes `Unlocks`, records the source. Multi-stage Knowledge tracks its stage.
- Weight Class unlocks: `# TBD OQ-02`.
- Implements `Saveable`.

### M16-T2 · Research Puzzle framework (DRAFT — OQ-21)

A puzzle interface (question/answer, or a small interactive puzzle scene), unlimited attempts, no penalty; completing it grants the unlock or stage. Content TBD.

### M16-T3 · Reverse Engineering (READY)

Base chance per technology (data); exposure sources add to it up to a cap (engaging or detecting enemies carrying the weapon, POI items, tech caches, meeting NPCs — callers use `add_exposure`); `roll_reverse_engineering` rolls on the `&"reverse_engineering"` Rng stream and grants the unlock permanently on success. Spending the materials is the economy's job (M17-T4), which calls this.
