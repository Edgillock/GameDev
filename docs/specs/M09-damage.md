# M09 · Damage

- **Status:** READY
- **Folder:** `game/modules/damage/`
- **Uses:** core, vehicle, structure
- **Design:** `docs/gdd/13-damage.md`, `docs/gdd/11-mobility.md` (ramming)

## Purpose

All damage rules. Weapons, the world and collisions hand this module a **damage payload** and a place; it works out which parts and bonds are affected and by how much, and applies the result through `VehicleApi`. It also handles Destruction Blasts and ramming.

## Public API sketch

```gdscript
class_name DamageApi
static func register() -> void
static func apply_payload(payload: DamagePayload, hit: HitInfo) -> DamageResult
static func apply_area(payload: DamagePayload, center: Vector3) -> DamageResult
static func events() -> DamageEvents      # signals live here (CLAUDE.md §3.2)
# public/damage_events.gd: class_name DamageEvents extends RefCounted
signal damage_applied(result: DamageResult)     # for HUD/audio/effects
```

Public types: `DamagePayload` (list of `DamageComponent`s), `DamageComponent` (`type: DamageType` + type-specific fields), `HitInfo` (vehicle, part uid, point, normal, direction, velocity), `DamageResult` (per-part and per-bond deltas, destroyed parts), `DamageEvents`.

`DamageComponent` fields by type:
- KINETIC: `mass_kg`, `velocity_mps`, `diameter_m`, `kinetic_penetration`.
- EXPLOSIVE: `blast_power`, `damage`, `radius_m` (derived from blast power by a data curve), `overpressure_peak`.
- THERMAL: `heat_rate_w`, `max_temp_c`, `radius_m`, `hp_drain_per_s`, `duration_s`, `mode` (FLAME/LASER).
- CHEMICAL: `chemical_potency`, `d0`, `radius_m`, `ray_count`, `duration_s`.
- MATTER_WAVE: `frequency_hz`, `power_w`, `range_m`, `falloff: Curve`.

## Resolution order

Overpressure → Kinetic → Explosive → Thermal / Chemical / Matter-Wave (13-damage).

## Tasks

### M09-T1 · Damage payloads, HP and destruction blasts (READY)

**Build**
- The public types above.
- Damage per part = raw ÷ the part's resistance for that type (from material/def + modifiers). Apply with `apply_hp_delta`.
- Listen to every vehicle's `part_destroyed`: if the part's def has a `destruction_blast`, apply it as an area payload at the part's center (one frame later, to avoid recursion storms; chain reactions allowed but capped per frame by data). Skip it once per battle if the part carries the modifier flag `&"ignore_one_destruction_blast"` (Gunnery crew, M12-T2).
- Debug overlay (demo scene only): flash hit parts.

**Tests:** resistance division; destruction blast triggers once; chain cap respected.

### M09-T2 · Kinetic resolver (READY)

**Build**
- From the hit point along the direction: shape cast a cylinder of `diameter_m`. Walk the parts it intersects in order.
- Penetration budget: starts at `kinetic_penetration`; each part consumes budget proportional to its `kinetic_protection` × thickness along the path (formula constants in data). The damage volume ends where the budget is spent.
- Damage per part from kinetic energy `½ m v²` × share (data), ÷ `kinetic_resistance`. Bonds inside the cylinder take damage too (`damage_bond`).

**Tests:** thicker/stronger armor stops the round earlier; bonds in the path are damaged; energy scales with v².

### M09-T3 · Explosive resolver and overpressure (READY)

**Build**
- Sphere of radius `radius_m` at the center (decision C12: fixed radius).
- Falloff `max(0, 1 − x/R)` using the distance to each part's nearest point.
- Damage per part = `damage × falloff × protection_factor ÷ explosive_resistance`, with `protection_factor = clamp(blast_power ÷ blast_protection, 0, 1)` (`# TBD OQ-19`).
- Overpressure first: pressure at each bond = `overpressure_peak × falloff`; if it exceeds the bond's `effective_strength`, `break_bond`.
- Terrain occlusion: parts fully behind terrain relative to the center take no damage (one ray per part).

**Tests:** falloff at 0, R/2 and R; overpressure breaks weak bonds and not strong ones; resolution order (bonds break before HP damage).

### M09-T4 · Heat model and thermal resolver (READY, after milestone 5)

**Build**
- Flame: sphere at the first hit point, radius ∝ distance within range; Laser: fixed radius.
- Each tick inside the sphere: `add_heat` with a rate falling linearly with radius, not above `max_temp_c`; small constant HP drain that ignores resistances (C13).
- Overheat effect: while `temperature_c > overheat_temp`, the part gets MULTIPLY modifiers on the three resistances by `overheat_factor` (data, 0.5); removed when it cools down.
- Meltdown: `temperature_c > meltdown_temp` → destroyed.

**Tests:** heating obeys capacity × mass; overheat modifiers appear and disappear; meltdown destroys.

### M09-T5 · Chemical resolver (READY, after milestone 5)

**Build** sphere of fixed radius, `ray_count` rays evenly spread (Fibonacci sphere); per hit: `damage(d) = d0 × e^(−k·d)`, `k = chemical_protection ÷ chemical_potency`, applied over `duration_s` at a constant rate, ÷ `chemical_resistance`, × heat synergy `(1 + α × max(0, T − T_ref) ÷ T_ref)`.

**Tests:** depth falloff; hotter target takes more.

### M09-T6 · Matter-wave resolver (READY, after milestone 5)

**Build** a ray to the first object only; damage only if `frequency_hz` is inside that material's resonance band (infill shift applied); HP drain ∝ power density at the hit point (`power_w × falloff(distance)`); nothing outside the band or beyond `range_m`. Expose `band_proximity(frequency, target) -> float` (0–1) for audio feedback.

**Tests:** in-band vs out-of-band; no penetration; proximity value.

### M09-T7 · Ramming (READY, after milestone 5)

**Build** listen to vehicle–vehicle contacts; energy `E = ½ × μ × v_rel²` (μ = reduced mass), split by inverse mass as kinetic damage to the touching parts; ×3 to the smaller vehicle when Weight Classes and running gear classes both differ by ≥ 2. Only non-friendly pairs.

**Tests:** equal masses split evenly; crush multiplier applies only when both gaps are ≥ 2.

## Out of scope

Firing weapons (M10). Visual effects beyond the debug overlay (art tasks). World hazards call `apply_area` (M13-T4).
