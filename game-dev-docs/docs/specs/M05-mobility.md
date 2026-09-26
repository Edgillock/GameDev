# M05 · Mobility

- **Status:** READY
- **Folder:** `game/modules/mobility/`
- **Uses:** core, vehicle
- **Design:** `docs/gdd/11-mobility.md`

## Purpose

Makes vehicles move: Running Gear Unit definitions and a per-vehicle `MobilitySystem` that applies suspension, drive and grip forces to the vehicle's rigid body, driven by `DriveOrder`s.

## Public API sketch

```gdscript
class_name MobilityApi
static func register() -> void          # registers the MobilitySystem factory with Services
# public/running_gear_def.gd: RunningGearDef extends PartDef
# public/mobility_telemetry.gd: speed_mps, per-unit load_factor, grounded, slip
static func telemetry(vehicle: Vehicle) -> MobilityTelemetry
```

## Data

`RunningGearDef` (extends `PartDef`): `gear_type` (WHEELS, TRACKS, LEGS), `energy_types: Array[EnergyType]`, `transmission_efficiency`, `rated_load_kg`, `terrain_drag: Dictionary[GroundType, float]`, `grip_mu: Dictionary[GroundType, float]`, `suspension_rest_m`, `suspension_travel_m`, `spring_n_per_m`, `damping_ns_per_m`, `contact_points: Array[Vector3]` (local), `steerable: bool`, `max_steer_deg`, `v_min_mps`, `hp_performance_curve: Curve`, `mount_deck_size_m`.

Starting content in `data/`: one T1 wheel set and one T1 track unit (placeholder numbers).

## Tasks

### M05-T1 · Suspension and ground contact (READY)

**Build**
- `MobilitySystem` (VehicleSystem). For each running gear part and each of its contact points: a downward ray (or short shape cast) from the part's position. Spring-damper force along the hit normal, applied at the contact point with `apply_force`.
- Ground Type from `EnvironmentQuery.ground_type_at(hit point)`.
- Telemetry per unit: compression, grounded, normal load.
- Register the factory in `MobilityApi.register()`; the app calls it at boot (this task may add that one call to `game/scenes/boot.gd`).

**Tests:** a fixture vehicle settles at the expected ride height (± tolerance) on flat ground; unit load sums to vehicle weight at rest.

### M05-T2 · Drive, steering, grip and overload (READY)

**Build**
- Handle `DriveOrder`. Power per unit from `PowerQuery.power_for_part()` (until M08 exists the neutral implementation returns the def's `debug_power_w`).
- Drive force per unit: `F_max = P × transmission_efficiency × exhaust_efficiency ÷ max(v, v_min)`, with `exhaust_efficiency` read from the part's modifier stack stat `&"exhaust_efficiency"` (default 1; M08 sets it).
- Grip limit `μ(ground) × normal load`; clamp the combined drive + lateral friction force to it (friction circle).
- Terrain Drag as a speed-proportional resisting force by Ground Type.
- Overload: `load_factor = unit load ÷ rated_load`; above 1, drive force and grip × `1 ÷ load_factor²`.
- Steering: skid steering (left/right units get opposite throttle) for every vehicle; units with `steerable` also turn their contact frame by up to `max_steer_deg`.
- Brake: strong longitudinal friction up to the grip limit.
- Demo scene: drive the fixture vehicle with a temporary debug script that submits `DriveOrder`s from a fixed test sequence (no input reading here — input is M06).

**Tests:** more power → higher top speed; overloaded vehicle is slower; on low-μ ground the vehicle slides instead of stopping instantly; skid steering turns in place.

### M05-T3 · HP performance curves and procedural track visuals (READY)

**Build**
- Apply `hp_performance_curve` to transmission efficiency and terrain drag as the unit loses HP (as modifiers, source `&"mobility.damage"`). Destroyed units produce no force.
- Track and chain visuals: a simple procedural track mesh or segment chain following the unit's contact points and suspension compression. Visual only — no physics bodies.

**Tests:** efficiency at 50 % HP matches the curve; destroyed unit contributes zero force.

## Out of scope

Reading input (M06). Power networks (M08). Ramming damage (M09-T7).
