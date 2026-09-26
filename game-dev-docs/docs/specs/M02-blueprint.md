# M02 · Blueprint

- **Status:** READY
- **Folder:** `game/modules/blueprint/`
- **Uses:** core
- **Design:** `docs/gdd/10-vehicle-structure.md`, `docs/gdd/18-builder.md`, `docs/gdd/40-tech.md`

## Purpose

A blueprint is the vehicle as **pure data**: which parts, where, how big, facing which way, linked to what. It knows nothing about physics, power or weapons. Everything else (builder, vehicle runtime, AI blueprint pools, sharing) reads and writes blueprints through this module.

## Public API sketch

```gdscript
class_name BlueprintApi
static func create(name: String, weight_class: int) -> Blueprint
static func save_to_file(bp: Blueprint, path: String) -> Error
static func load_from_file(path: String) -> BlueprintLoadResult   # blueprint + warnings
static func to_dict(bp: Blueprint) -> Dictionary
static func from_dict(d: Dictionary) -> BlueprintLoadResult
static func validate(bp: Blueprint) -> ValidationReport
```

Public types (`public/`): `Blueprint`, `BlueprintPart`, `ValidationReport`, `ValidationIssue`, `BlueprintLoadResult`.

## Data model

`Blueprint` (RefCounted):
- `format_version: int` (starts at 1), `name`, `author`, `weight_class`, `grid_step_m: float` (from class data), `default_adhesive_id`.
- `parts: Array[BlueprintPart]`, `next_uid: int`.
- `props: Dictionary` — **module-owned properties**, keys namespaced `"<module>.<key>"` (e.g. `"weapons.group_meta"`). Values must be JSON-safe. The blueprint module stores and copies them but never interprets them.

`BlueprintPart` (RefCounted):
- `uid: int` (unique within the blueprint, never reused), `def_id: StringName`.
- `cell: Vector3i` — minimum corner in grid cells. `size_cells: Vector3i` — for resizable parts; fixed parts use the def's size.
- `facing: Facing`.
- `material_id` (blocks/struts), `adhesive_id` (bonds owned by this part; empty = blueprint default), `infill: float` (1.0 default), `chamfers: Dictionary` (edge → {shape, size}), `texture_id`.
- `props: Dictionary` — module-owned, namespaced like above (e.g. `"weapons.groups": [1, 9]`, `"weapons.ammo_racks": [12, 15]`, `"power.path": [[x,y,z]…]`).

Helper: `aabb_m(part) -> AABB` in meters (from cell, size and grid step).

## Tasks

### M02-T1 · Blueprint data model (READY)

**Build** the classes above plus editing helpers used by the builder: `add_part(def_id, cell, size, facing) -> BlueprintPart`, `remove_part(uid)`, `move_part(uid, cell)`, `resize_part(uid, cell, size)`, `get_part(uid)`, `parts_overlapping(aabb)`, `duplicate()`. Overlapping parts are **not** allowed: `add_part`/`move_part`/`resize_part` return an error result if the new box overlaps another part.

**Tests:** uids unique and never reused; overlap rejection; `duplicate()` is deep (props included); AABB math for each facing.

### M02-T2 · Versioned save and load (READY)

**Build**
- JSON file format with `format_version` at the top. `to_dict`/`from_dict` round-trip exactly.
- A migration table: `migrations[v] = Callable(dict) -> dict` upgrading version v to v+1. Loading an older file runs migrations in order; a newer file than the game supports fails with a clear message.
- Unknown `def_id`s load as **missing parts** listed in `BlueprintLoadResult.warnings` (not silently dropped).
- Default folder for player blueprints: `user://blueprints/`.

**Tests:** round-trip equality; migration from a fake v0 fixture; unknown def id → warning; corrupted file → error, no crash.

### M02-T3 · Validation (READY)

**Build** `validate(bp) -> ValidationReport` with issues (severity ERROR/WARNING, code, message, part uids):
- `NO_COMMAND_MODULE`, `MULTIPLE_COMMAND_MODULES`.
- `OVER_BOUNDING_BOX`, `OVER_MASS`, `OVER_PART_COUNT` against the Weight Class caps in `data/weight_classes.tres` (values from the table in 10-vehicle-structure; part-count caps are `# TBD OQ-03` placeholders).
- `SIZE_OUT_OF_RANGE` for resizable parts outside their def's min/max.
- `LOCKED_PART` if a part's `unlock_id` is not unlocked (through core `Unlocks`).

Mass here is a **quick estimate** (sum of part masses from defs and materials). The exact mass and connectivity checks live in M03; the builder shows both.

Other modules add their own validation (power badges, weapon bindings) in their APIs; the builder combines the reports.

**Tests:** one fixture per issue code; a valid minimal blueprint (Command Module + one block) passes.

## Out of scope

Bonds and connectivity (M03). Anything physical (M04). Module-specific meaning of `props`.
