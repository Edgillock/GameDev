# M11 · Detection

- **Status:** READY
- **Folder:** `game/modules/detection/`
- **Uses:** core, blueprint, vehicle
- **Design:** `docs/gdd/15-detection.md`

## Purpose

Who can see whom. Observation Ports cast rays on a budget; the detection rule decides whether a ray hit counts; each faction keeps a list of **contacts**. Also paints (Concealment, Recon Masking) and the Recon Scan skill.

## Public API sketch

```gdscript
class_name DetectionApi
static func register() -> void
static func contacts_of(faction: StringName) -> Array[Contact]      # current known enemies
static func is_detected(by_faction: StringName, vehicle: Vehicle) -> bool
static func start_recon_scan(vehicle: Vehicle, direction: Vector3) -> Error
static func events() -> DetectionEvents      # signals live here (CLAUDE.md §3.2)
# public/detection_events.gd: class_name DetectionEvents extends RefCounted
signal contact_added(faction: StringName, contact: Contact)
signal contact_lost(faction: StringName, contact: Contact)
```

Public types: `ObservationPortDef`, `PaintDef` (concealment per biome/weather, `recon_masking`), `Contact` (`TargetRef`, last seen position/time, revealed info), `DetectionEvents`.

## Tasks

### M11-T1 · Observation Ports and the ray scheduler (READY)

**Build**
- `ObservationPortDef` (small part, `rays_per_scan`, `max_view_range_m` base).
- A world-level `DetectionService` (registered in `Services`) that owns a **ray budget per physics tick** (data). Every N ticks each port needs a scan of `rays_per_scan` rays evenly spread over the sphere (Fibonacci); the service spreads those rays over the ticks in between so the per-tick count stays under budget. The outcome must not depend on frame rate.
- Rays stop at terrain and at the ray's own vehicle is ignored.
- Destroyed ports stop scanning.

**Tests:** budget never exceeded; every port completes its scan within its interval; own vehicle ignored.

### M11-T2 · Detection rule, Noise, Concealment and night (READY)

**Build**
- On a ray hitting an enemy part: `detection_range = max_view − (max_view − auto_spot) × clamp(concealment − noise, 0, 1)`; detected if `detection_range > distance`.
  - `max_view` = port's range × vehicle modifiers (Recon crew later) × `EnvironmentQuery.view_range_multiplier_at` × night factor (from `GameClock.is_night()`; Night Vision Device later sets a modifier).
  - `concealment` = the hit part's paint value for the current biome/weather + `EnvironmentQuery.concealment_modifier_at`.
  - `noise` = target vehicle's `noise()`.
- Auto-Spot: any two hostile vehicles within `auto_spot_range` are detected both ways.
- Contacts per faction; a contact is lost after `contact_timeout_s` without detection.
- Default paint for parts without one (data).

**Tests:** formula including both clamps; auto-spot; noise makes a target visible from farther; night shortens range.

### M11-T3 · Recon Scan (READY, after milestone 5)

**Build** (defaults from 15-detection, OQ confirmation pending):
- Needs a Recon crew (`CrewQuery.has_crew(…, RECON)`); cooldown from data; range = Max View Range.
- Scans a cone for 5 s (data); reveals armor, weapon and power parts of targets in the cone (stored on the `Contact`), reduced per part by the target's Recon Masking.
- Each use adds Noise to the scanning vehicle.
- At a Recon level threshold (modifier flag `&"recon_weak_points"`): chance to reveal weak-point parts.
- Reveals resonance bands for unlocked materials on fully filled blocks only.

**Tests:** masking lowers reveal chance; cooldown; noise added.

## Out of scope

Crew levels (M12 provides modifiers). Showing contacts (M19). AI reactions (M14).
