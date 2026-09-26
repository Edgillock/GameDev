# M14 · AI Vehicles

- **Status:** READY (T6 DRAFT)
- **Folder:** `game/modules/ai/`
- **Uses:** core, vehicle, mobility, weapons, detection, crew
- **Design:** `docs/gdd/24-ai-and-factions.md`, `docs/gdd/17-controls.md`

## Purpose

AI drivers and gunners for enemy and allied vehicles, plus **Squads**: the player's Command & Conquer-style control over allied AI vehicles. The AI uses exactly the same parts, physics and Orders as the player: it produces `DriveOrder`s, `AimOrder`s and `WeaponGroupOrder`s and submits them through `VehicleApi`.

## Public API sketch

```gdscript
class_name AiApi
static func register() -> void
static func attach_brain(vehicle: Vehicle, faction: StringName, profile: AiProfile) -> void
# Squads (called by controls, M06-T4)
static func assign_squad(squad_id: int, vehicles: Array[Vehicle]) -> void
static func squad_members(squad_id: int) -> Array[Vehicle]
static func order(vehicles: Array[Vehicle], order: Order, queue: bool = false) -> void   # Move/Attack/AttackMove/Stop/Stance
static func events() -> AiEvents      # signals live here (CLAUDE.md §3.2)
# public/ai_events.gd: class_name AiEvents extends RefCounted
signal squad_changed(squad_id: int)
```

Public types: `AiProfile` (aggression, preferred range, retreat HP %, stance), `Stance` (HOLD_FIRE, RETURN_FIRE, FREE_FIRE, RETREAT), `AiEvents`.

## Tasks

### M14-T1 · AI driver (READY)

**Build**
- `AiBrain` (VehicleSystem) with a driver: follows a path from Godot's `NavigationServer3D` toward a goal; converts steering to `DriveOrder`s (look-ahead point, throttle by distance and slope, brake before corners); unstuck behavior (reverse and retry).
- `MoveOrder` handling with a waypoint queue.

**Tests:** reaches a goal on the test ground around an obstacle; stops at the goal; unstuck triggers.

### M14-T2 · AI gunner (READY)

**Build**
- Picks targets from `DetectionApi.contacts_of(faction)` (nearest threat first; data weights).
- Uses the vehicle's **Activation Groups**: issues `WeaponGroupOrder(SELECT)`, `AimOrder`/`LOCK_TARGET`, `FIRE_START`/`FIRE_STOP`. For player-owned allied vehicles, only groups set to FIRE_AT_WILL engage on their own; HOLD_FIRE groups wait for orders.
- Respects the stance (M14-T3).

**Tests:** engages a detected target; never fires on HOLD_FIRE; does nothing without contacts.

### M14-T3 · Squads and orders (READY)

**Build** the Command & Conquer-style layer (decision C15):
- Squads 1–9: `assign_squad`, `squad_members`; a vehicle is in at most one squad.
- Orders to a set of vehicles: Move (formation offsets so they don't collide), Attack (target), Attack-move (move, engaging anything detected on the way), Stop, Stance (hold fire / return fire / free fire / retreat), queued waypoints.
- Only vehicles with a Brain-in-a-Vat in their Command Module can be allied AI. Before `&"knowledge.radio"` is unlocked they ignore orders and follow the Flagship at a set distance (M14-T5 finalizes this).

**Tests:** squad membership exclusive; move with formation; attack-move engages on the way; stance HOLD_FIRE blocks firing.

### M14-T4 · Enemy stance and Combat Rating (READY, placeholder formula)

**Build**
- Combat Rating: placeholder = (firepower + protection + mobility scores from part stats) × current HP % (`# TBD OQ-07`), recomputed on part changes.
- On detecting the player: compare ratings, the player's condition and cargo value → flee / keep distance / attack (thresholds in `AiProfile`).
- Retreat when own HP % falls below the profile's threshold.

**Tests:** weaker AI flees; stronger attacks; retreat threshold.

### M14-T5 · Allied AI rules (READY, caps need OQ-15)

**Build** Brain-in-a-Vat requirement; Radio Communications gate (before: follow Flagship; after: obey Squad orders); a cap on allied AI vehicles from data (`# TBD OQ-15`).

### M14-T6 · Blueprint pools, factions and morale (DRAFT)

Faction definitions (24-ai-and-factions), blueprint pools per faction × region × class, spawning, morale and surrender, squad tactics (flank, focus fire, pull back damaged units). Needs region layout (OQ-01) and blueprint content.

## Out of scope

Player input (M06). Transports' route logic (M18 uses the driver).
