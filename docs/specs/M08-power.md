# M08 · Power

- **Status:** READY
- **Folder:** `game/modules/power/`
- **Uses:** core, blueprint, vehicle
- **Design:** `docs/gdd/12-power.md`

## Purpose

Power part definitions; a **blueprint-level analysis** the builder uses (what is connected, how much power reaches each consumer); and the runtime `PowerSystem` that burns fuel, delivers power, and handles malfunctions and overheating. Implements core `PowerQuery`.

## Public API sketch

```gdscript
class_name PowerApi
static func register() -> void                         # factory + PowerQuery implementation
static func analyze_blueprint(bp: Blueprint) -> PowerReport
static func validate_blueprint(bp: Blueprint) -> ValidationReport
static func set_conduit_path(bp: Blueprint, conduit_uid: int, from_uid: int, to_uid: int, path_cells: Array[Vector3i]) -> void
static func set_priority_groups(bp: Blueprint, groups: Array) -> void
static func runtime_report(vehicle: Vehicle) -> PowerReport
static func events() -> PowerEvents      # signals live here (CLAUDE.md §3.2)
# public/power_events.gd: class_name PowerEvents extends RefCounted
signal power_changed(vehicle_id: int)
```

Public types: `PowerPlantDef`, `PowerRelayDef`, `ConduitDef`, `FuelTankDef`, `FuelLineDef`, `ExhaustStackDef` (all extend `PartDef`), `PowerReport`, `PowerNetwork`, `PowerEvents`.

Blueprint props written only through this API: `"power.from"`, `"power.to"`, `"power.path"` (conduits and fuel lines), `"power.priority_groups"` (blueprint).

## Data

- `PowerPlantDef`: `plant_type` (STEAM, COMBUSTION, DIESEL_ELECTRIC, FISSION, FUSION, EXOTIC), `output_power_w`, `output_energy_type`, `fuel_type`, `fuel_use_per_s_at_full`, `drive_range_shape` (SPHERE/BOX), `drive_range_m`, `needs_fuel_tank`, `needs_exhaust`, `base_malfunction_chance`, `malfunction_vs_hp: Curve`, `noise_at_full`, `destruction_blast`.
- `PowerRelayDef`: `energy_types_in`, `energy_type_out`, `conversion_k`, `max_output_w`, `drive_range_*`, `destruction_blast`.
- `ConduitDef`: `energy_type`, `loss_per_m`, `hp_per_m`, `destruction_blast`.
- `FuelTankDef`: `fuel_type`, `capacity_per_m3`, `destruction_blast`. `FuelLineDef`: `hp_per_m`.
- `ExhaustStackDef`: `height_coefficient: Curve` (outlet height above the vehicle's lowest point → coefficient).
- Fission and Fusion reactor numbers: `# TBD OQ-18` placeholders.

## Tasks

### M08-T1 · Power part definitions (READY)

**Build** the def classes and T1 starting content: one combustion engine, one steam engine, one electric relay, one thermal relay, one electric and one thermal conduit, one fuel tank, one fuel line, one exhaust stack (placeholder numbers).

**Tests:** defs load through the Registry; required fields validated.

### M08-T2 · Power network analysis (READY)

**Build** `analyze_blueprint(bp) -> PowerReport`, pure data:
1. Conduits connect `power.from` → `power.to`; conduit length = path length in meters. Build networks: plants → conduits → relays → conduits → weapons.
2. Energy type checks: conduit type must match both ends; weapons need their energy type; relays convert (`conversion_k`), capped at `max_output_w`.
3. Loss per conduit: `P_out = P_in × max(0, 1 − loss_per_m × length)`.
4. Exhaust: exhaust stacks touching a plant; outlet open-air check (the cells beyond the outlet within N cells are empty); `exhaust_efficiency = min(1.15, 0.8 + height_coefficient)`; a plant that needs an exhaust and has none produces 0.
5. Fuel: a plant needing fuel must touch a matching tank or be linked by a fuel line; otherwise 0.
6. Running gear: every running gear unit inside the drive range of a plant or relay with a compatible energy type is a drive consumer of it (C21).
7. Distribute available power: drive consumers and weapons share a network's output; default split is even by rated demand, overridden by priority groups (M08-T5).
8. Report per part: supplied W, demand W, network id, and badges: `EXHAUST_BLOCKED`, `NO_FUEL`, `WEAPON_UNPOWERED` (warning), `WRONG_ENERGY_TYPE`, `NOT_IN_DRIVE_RANGE`.

**Tests:** one fixture per badge; conduit loss math; relay conversion and cap; exhaust formula at several heights; drive range sphere vs box.

### M08-T3 · Runtime power system and fuel (READY)

**Build**
- `PowerSystem` (VehicleSystem): builds its networks from the analysis at spawn; rebuilds when parts are destroyed or detached (listen to the vehicle's signals).
- Implements `PowerQuery.power_for_part()` (replaces the neutral one at `register()`), scaled by throttle demand where relevant.
- Sets the `&"exhaust_efficiency"` modifier on running gear so M05 uses it.
- Fuel: tanks hold fuel; plants burn fuel proportional to output; empty → output 0. Destroyed fuel line cuts that tank.
- Noise: active plants add noise each tick (`noise_at_full × load`) through `add_noise`.
- Signal `power_changed` when any consumer's supply changes by more than a threshold.
- Remove the need for `debug_power_w` in the demo: the Milestone 2 demo vehicle has a real engine, tank, exhaust and conduits.

**Done when** (Milestone 2) a vehicle with an engine drives; removing its exhaust or fuel stops it; a heavier vehicle with the same engine is slower.

### M08-T4 · Malfunctions and overheating (READY)

**Build**
- On `part_damaged` for a power plant, relay or conduit: malfunction check with `malfunction_chance` from `malfunction_vs_hp` (+ modifiers). Fail → `is_active = false` (shut down). Fail while overheated (`temperature_c > overheat_temp`) and active → destroyed (`apply_hp_delta` to 0).
- While overheated and active, run a check every `overheat_check_interval_s` (data) even without hits.
- Powertrain crew conversion (destroy → shut down) is a modifier flag `&"malfunction_no_destroy"` read here; crew sets it later.
- Restart: a shut-down plant restarts after `restart_time_s` if HP > 0 (data).
- Plants heat up with load (`add_heat`), cool through dissipation (M04 does the cooling).

**Tests:** seeded Rng → deterministic outcomes; overheated failure destroys; the no-destroy flag converts.

### M08-T5 · Power priority groups and budget report (READY)

**Build**
- Priority groups: an ordered list of consumer sets (e.g. `["drive"], ["weapons.group.1"], ["weapons.group.2"]`). When demand exceeds supply, earlier groups are filled first. Weapons groups are identified by string keys; this module doesn't need to know what they mean.
- `runtime_report()` for the HUD: per network supply, demand, loss, exhaust efficiency, fuel left.

**Tests:** shortage fills the first group fully before the second.

## Out of scope

Destruction Blast damage itself (M09 applies it). Wireless Power Transfer (later task once Progression exists).
