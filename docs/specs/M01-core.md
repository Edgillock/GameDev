# M01 · Core

- **Status:** READY
- **Folders:** `game/core/`, `game/autoload/`
- **Uses:** nothing (Godot only)
- **Design:** `docs/gdd/01-glossary.md`, `docs/gdd/40-tech.md`, `CLAUDE.md` §3

## Purpose

The small set of shared types and services every module relies on. Core must stay small and stable: after M01, core only changes through an accepted change request (CR-xx).

## Folder layout

```
game/core/
├─ services/      services.gd (registry), log.gd, rng.gd, game_clock.gd
├─ stats/         stat_block.gd, stat_modifier.gd, modifier_stack.gd
├─ defs/          material_def.gd, adhesive_def.gd, part_def.gd, enums.gd
├─ registry/      registry.gd (loads all .tres defs)
├─ orders/        order.gd and subclasses
├─ vehicle/       vehicle_system.gd, vehicle_system_factory.gd, part_uid.gd
├─ interfaces/    power_query.gd, crew_query.gd, environment_query.gd, saveable.gd
├─ unlocks/       unlocks.gd
└─ tests/
game/autoload/
└─ services_autoload.gd   (autoload name: Services)
```

## Tasks

### M01-T1 · Services, Log, Rng and GameClock (READY)

**Build**

- `Services` autoload (the only autoload in the game): a typed registry. `register(key: StringName, service: Object)`, `get_service(key) -> Object`, `has_service(key)`, and `get_or_create(key, create: Callable) -> Object` (returns the service, creating and registering it with `create.call()` on first use; modules use it for their events objects, see `CLAUDE.md` §3.2). Registering the same key twice is an error. Add it to `project.godot` autoloads (this task may edit `project.godot` for that line only).
- `Log`: levels (debug/info/warn/error), a module tag per message, printed with a timestamp. No other module prints directly.
- `Rng`: wraps `RandomNumberGenerator` with a seed; `randf()`, `randi_range()`, `chance(p: float) -> bool`, and named sub-streams (`stream(&"weather")`) so systems don't disturb each other's sequences.
- `GameClock`: in-game time in seconds, day length (data), `time_scale` (Time Acceleration, 1–N), signal `time_scale_changed`, helper `is_night()` from a day/night curve in data. Advances in `_physics_process` of the autoload.

**Tests:** registry errors on duplicates; `get_or_create` creates once and returns the same object after; same seed → same sequence; sub-streams independent; clock advances by `delta × time_scale`.

### M01-T2 · Stats and modifiers (READY)

Every bonus in the game (crew, biome, weather, overclock, damage state) goes through this pipeline. Nothing edits base stats.

**Build**

- `StatBlock`: typed map of `StringName → float` base values, loaded from Resources.
- `StatModifier`: `stat: StringName`, `op` (ADD, MULTIPLY, OVERRIDE_MIN, OVERRIDE_MAX), `value`, `source: StringName` (e.g. `&"crew.gunnery"`), optional `duration_s`.
- `ModifierStack`: holds modifiers for one owner (a part or a vehicle). `add()`, `remove_by_source()`, `get_value(stat) -> float`. Order of application: all ADD, then all MULTIPLY, then clamps. Cached; recomputed only when modifiers change. Signal `stat_changed(stat)`.

**Tests:** order of operations; removing by source; expiry of timed modifiers with `GameClock`; cache invalidation.

### M01-T3 · Materials, part definitions and the data registry (READY)

**Build**

- `enums.gd`: `DamageType`, `GroundType`, `EnergyType`, `PartKind` (ARMOR_BLOCK, STRUT, RUNNING_GEAR, POWER_PLANT, POWER_RELAY, CONDUIT, FUEL_TANK, FUEL_LINE, EXHAUST_STACK, WEAPON, AMMO_RACK, COMMAND_MODULE, CREW_COMPARTMENT, WORKSHOP_MODULE, OBSERVATION_PORT, SALVAGE_RIG, CARGO_MODULE), `Facing` (six axis directions), `WeightClass` (T1–T6). Names exactly as the glossary.
- `MaterialDef` (Resource): `id`, `display_name`, `density`, `hp_per_m3`, the three resistances, `kinetic_protection`, `blast_protection`, `chemical_protection`, `overheat_temp`, `meltdown_temp`, `heat_capacity`, `heat_dissipation`, `resonance_band_hz: Vector2`, `infill_resonance_shift` (curve), `tier`.
- `AdhesiveDef` (extends MaterialDef): `strength`, `compatibility: Dictionary[StringName, float]` (material id → factor, default 1).
- `PartDef` (Resource): `id`, `display_name`, `kind: PartKind`, `weight_class`, `family_id`, `model_id`, `variant_id`, `tags: Array[StringName]`, `resizable: bool`, `min_size_m`, `max_size_m`, `default_size_m`, `fixed_size_m` (for non-resizable), `material_id` (for blocks/struts), `base_mass_kg`, `base_hp`, `stats: StatBlock` (extra stats), `unlock_id: StringName` (empty = always available). Modules extend it (`PowerPlantDef extends PartDef`) in their own `public/`.
- `Registry`: `load_from(roots: PackedStringArray)` recursively finds every `data/` folder under the given roots and loads its `.tres` files; indexes MaterialDefs and PartDefs (and any other Resource with an `id`) by `id`; errors on duplicate ids. `get_part(id)`, `get_material(id)`, `get_def(id)`, `parts_of_kind(kind)`. Registered in `Services` as `&"registry"`. Core never names module paths itself: the boot scene (app, M00) calls `load_from(["res://game/core/data", "res://game/modules"])`. This task may add that one call to `game/scenes/boot.gd`. Tests call `load_from` with fixture folders.
- `game/core/data/`: two placeholder materials (`mat.steel_basic`, `mat.scrap`), one adhesive (`adh.basic`), one armor block def, one strut def and one Command Module def (all T1). All numbers marked `# placeholder`.

**Tests:** registry loads fixtures; duplicate id fails; lookups by kind.

### M01-T4 · Orders, VehicleSystem base and core interfaces (READY)

**Build**

- `Order` (RefCounted) with `issuer: StringName` and `created_at`. Subclasses:
  - `DriveOrder`: `throttle` (−1…1), `steer` (−1…1), `brake: bool`, `fine: bool`.
  - `AimOrder`: `point: Vector3`, or `target: TargetRef`.
  - `WeaponGroupOrder`: `action` (SELECT, ADD_TO_ACTIVE, REMOVE_FROM_ACTIVE, FIRE_START, FIRE_STOP, HOLD_FIRE, FIRE_AT_WILL, LOCK_TARGET, RELEASE_TARGET, SET_POWER_MODE, SET_AMMO, SET_PATTERN, ASSIGN, UNASSIGN), `group_ids: PackedInt32Array`, `weapon_uids: PackedInt32Array`, `params: Dictionary`.
  - `MoveOrder`, `AttackOrder`, `AttackMoveOrder`, `StopOrder`, `StanceOrder` (for Squads; used by M14).
- `TargetRef`: stable handle to a target (vehicle instance id + optional part uid + last known position).
- `VehicleSystem` (Node, abstract): `system_id: StringName`, `func setup(vehicle: Object) -> void`, `func handles_order(order: Order) -> bool`, `func handle_order(order: Order) -> void`, `func physics_step(delta: float) -> void`. The vehicle runtime calls these.
- `VehicleSystemFactory`: modules register `Callable`s that create their system for a vehicle: `Services.get_service(&"system_factories").register(&"power", callable)`.
- Interfaces (abstract classes with default "neutral" implementations registered at boot, replaced by the real module later):
  - `PowerQuery`: `power_for_part(vehicle_id, part_uid) -> float` (W). Neutral: returns the part's `debug_power_w` stat if present, else 0.
  - `CrewQuery`: `has_crew(vehicle_id, part_uid, role) -> bool`. Neutral: true (so weapons work before the crew module exists).
  - `EnvironmentQuery`: `ground_type_at(pos) -> GroundType`, `view_range_multiplier_at(pos) -> float`, `concealment_modifier_at(pos) -> float`, `ambient_temp_at(pos) -> float`. Neutral: HARD, 1, 0, 20.
  - `Saveable`: `save_key() -> StringName`, `save_state() -> Dictionary`, `load_state(d: Dictionary, version: int) -> void`.
- `Unlocks`: a set of unlocked ids (`&"knowledge.control_theory"`…). `is_unlocked(id)`, `unlock(id)` (only the progression module calls `unlock`), signal `unlocked(id)`. Registered as `&"unlocks"`. In Creative Mode everything reports unlocked.

**Tests:** default neutral implementations are registered; replacing an implementation works; order classes carry their fields; Unlocks signal fires once per id.

## Out of scope

Any module-specific definition (power plants, weapons…). Anything that needs a scene.
