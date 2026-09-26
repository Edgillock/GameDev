# M04 · Vehicle Runtime

- **Status:** READY
- **Folder:** `game/modules/vehicle/`
- **Uses:** core, blueprint, structure
- **Design:** `docs/gdd/10-vehicle-structure.md`, `docs/gdd/13-damage.md`

## Purpose

Turns a blueprint into a living vehicle in the world: one Jolt rigid body, per-part collision and visuals, per-part runtime state, the per-vehicle systems from other modules, and debris when pieces come off. It is the hub every per-vehicle system talks to, but it knows nothing about power, weapons or damage rules.

## Public API sketch

```gdscript
class_name VehicleApi
static func spawn(bp: Blueprint, xform: Transform3D, parent: Node, faction: StringName) -> Vehicle
# Vehicle (public/vehicle.gd, extends RigidBody3D):
func vehicle_id() -> int
func blueprint() -> Blueprint
func structure() -> StructureGraph
func part_state(uid: int) -> PartState
func part_uid_from_shape(shape_index: int) -> int
func part_world_aabb(uid: int) -> AABB
func parts_of_kind(kind: PartKind) -> PackedInt32Array
func get_system(system_id: StringName) -> VehicleSystem
func submit_order(order: Order) -> void
func apply_hp_delta(uid: int, delta: float, source: StringName) -> void
func damage_bond(bond_id: int, amount: float) -> void
func add_heat(uid: int, joules: float) -> void
func add_noise(amount: float) -> void
func noise() -> float
func apply_impulse_at(point: Vector3, impulse: Vector3) -> void
func modifiers(uid: int = -1) -> ModifierStack     # -1 = vehicle-wide
func report_activity(uid: int, seconds: float) -> void   # a part did its job (crew XP)
signal part_activity(uid: int, seconds: float)
signal part_damaged(uid: int, delta: float, source: StringName)
signal part_destroyed(uid: int)
signal parts_detached(uids: PackedInt32Array, debris: Node3D)
signal vehicle_lost()
```

`PartState` (public): `hp`, `max_hp`, `is_active`, `is_destroyed`, `temperature_c`. Only this module writes it, through the methods above. Temperature integration (heat in, dissipation) uses the heat stats from the part's material/def; the *rules* for heat damage live in M09.

## Tasks

### M04-T1 · Spawn a blueprint as a physics body (READY)

**Build**
- `Vehicle` extends `RigidBody3D`. One `CollisionShape3D` with a `BoxShape3D` per part (in meters, from `aabb_m`). Keep a map shape index → part uid.
- Mass, center of mass and inertia from `StructureApi.mass_properties` (set `center_of_mass_mode` to custom).
- Visuals: one `MeshInstance3D` per part with a box mesh and a flat color by part kind or material (placeholder art). Chamfers are ignored until art tasks.
- `spawn()` validates first (blueprint + connectivity) and refuses invalid blueprints with the report.
- Demo scene: `scenes/demo_vehicle.tscn` spawns a fixture blueprint (Command Module on a slab of blocks) that drops onto the ground and rests.

**Tests:** shape count equals part count; shape→uid map is correct; mass equals structure mass; invalid blueprint is refused.

### M04-T2 · Part state, systems and order routing (READY)

**Build**
- `PartState` for every part, initialized from defs.
- On spawn, ask `Services` `&"system_factories"` for every registered factory and attach each returned `VehicleSystem` as a child; call `setup(vehicle)`. Unknown or missing systems are fine.
- `submit_order()` routes an order to every system whose `handles_order()` returns true. `physics_step()` is called on each system in a fixed, logged order each physics tick.
- Vehicle-wide and per-part `ModifierStack`s.
- `report_activity(uid, seconds)` re-emits as `part_activity` (used for crew XP).
- Vehicle Noise: `add_noise()` accumulates; decays each tick by a rate from data.
- Temperature integration per part: `add_heat(uid, J)` raises temperature by `J ÷ (heat_capacity × mass)`; each tick cools by `heat_dissipation × delta` toward ambient (`EnvironmentQuery.ambient_temp_at`).

**Tests:** a fake system registered in a test receives setup, orders and steps; noise decays; heat math matches the formula.

### M04-T3 · Damage hooks and detaching debris (READY)

**Build**
- `apply_hp_delta` updates HP, emits `part_damaged`. If HP would reach 0 and the part's modifier stack has the flag `&"survive_one_destruction"` not yet used this battle, HP stays at 1 and the flag is consumed (Maintenance crew, M12-T3). Otherwise, at HP ≤ 0 it marks the part destroyed, emits `part_destroyed`, removes its shape and mesh, and calls `StructureGraph.remove_part`.
- `damage_bond` forwards to the structure graph.
- For each newly detached group: create a separate `RigidBody3D` debris object with those parts' shapes and meshes, initial velocity matching the vehicle at that point; recompute the vehicle's mass properties; emit `parts_detached`.
- Command Module destroyed → emit `vehicle_lost` once; the vehicle stays as a wreck (a salvageable object; salvage rules come later).
- Debris lifetime and cleanup rules from data.

**Tests:** destroying a bridging block detaches the far side; mass updates; `vehicle_lost` fires once.

## Out of scope

How much damage something takes (M09). What systems do (other modules). Art.
