# M15 · Save/Load

- **Status:** READY
- **Folder:** `game/modules/save/`
- **Uses:** core
- **Design:** `docs/gdd/40-tech.md`

## Purpose

Saving and loading the game without knowing what the other modules store. Every module that has state implements core `Saveable` and registers itself; this module collects and restores them.

## Public API sketch

```gdscript
class_name SaveApi
static func register_participant(p: Saveable) -> void
static func save(slot: StringName) -> Error
static func load(slot: StringName) -> Error
static func list_slots() -> Array[SaveSlotInfo]
static func events() -> SaveEvents      # signals live here (CLAUDE.md §3.2)
# public/save_events.gd: class_name SaveEvents extends RefCounted
signal saved(slot: StringName)
signal loaded(slot: StringName)
```

## Tasks

### M15-T1 · Save service and file format (READY)

**Build**
- File: `user://saves/<slot>.json` = `{format_version, game_version, created_at, play_time_s, participants: {save_key: {version, state}}}`.
- Write to a temp file, then rename (no half-written saves).
- Load order: participants load in registration order; a participant missing from the file gets `load_state({}, 0)`; a key in the file with no participant is kept and written back on the next save (forward compatibility).
- Each participant's `version` lets it migrate its own state.

**Tests:** round-trip with two fake participants; atomic write; unknown keys preserved; corrupt file → error, current game untouched.

### M15-T2 · Module save participants (READY — checklist task)

**Build** nothing new here; instead, for each module that exists at this point, open a change request asking that module to implement `Saveable` (vehicles in the world with their blueprints and part states, GameClock and weather, crew roster, unlocks, inventory…), and add the participant registration calls in `game/scenes/boot.gd` as they land. Track the list in this module's `CLAUDE.md` status.

## Out of scope

What each module saves (each module decides).
