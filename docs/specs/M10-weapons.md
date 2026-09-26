# M10 · Weapons

- **Status:** READY (T6 DRAFT)
- **Folder:** `game/modules/weapons/`
- **Uses:** core, blueprint, vehicle, power, damage
- **Design:** `docs/gdd/14-weapons.md`

## Purpose

Weapon and ammo definitions, the per-vehicle `WeaponSystem` (aiming, traverse, reload, firing, projectiles, recoil, Power Modes), and **Activation Groups**. Target selection for "fire at will" is not here: the AI gunner (M14) issues the same group orders a player would.

## Public API sketch

```gdscript
class_name WeaponsApi
static func register() -> void
# blueprint helpers (the only way other modules write weapon props)
static func bind_ammo_racks(bp: Blueprint, weapon_uid: int, rack_uids: PackedInt32Array) -> void
static func set_weapon_groups(bp: Blueprint, weapon_uids: PackedInt32Array, group_id: int, member: bool) -> void
static func set_group_meta(bp: Blueprint, group_id: int, name: String, color: Color) -> void
static func groups_of(bp: Blueprint) -> Array[ActivationGroupInfo]
static func validate_blueprint(bp: Blueprint) -> ValidationReport
# runtime
static func group_status(vehicle: Vehicle) -> Array[GroupStatus]     # for the HUD group bar
static func weapon_status(vehicle: Vehicle, weapon_uid: int) -> WeaponStatus
static func events() -> WeaponsEvents      # signals live here (CLAUDE.md §3.2)
# public/weapons_events.gd: class_name WeaponsEvents extends RefCounted
signal weapon_fired(vehicle_id: int, weapon_uid: int, muzzle: Transform3D)
signal active_groups_changed(vehicle_id: int, group_ids: PackedInt32Array)
```

Public types: `WeaponDef`, `AmmoRackDef`, `AmmoDef` (extend `PartDef`/`Resource`), `ActivationGroupInfo`, `GroupStatus`, `WeaponStatus`, enums `WeaponClass`, `PowerMode`, `FirePattern` (SALVO, RIPPLE), `MemberState` (READY, RELOADING, OUT_OF_ARC, NO_POWER, NO_AMMO, NO_CREW, DESTROYED), `WeaponsEvents`.

Blueprint props (written only through this API): part `"weapons.ammo_racks"` (ordered uids), part `"weapons.groups"` (group ids), blueprint `"weapons.group_meta"` ({id: {name, color, pattern, ripple_interval_s}}).

## Data

- `WeaponDef`: `weapon_class`, `family_id`/`model_id`/`variant_id`, `energy_type`, `rated_power_w`, `min_power_w` (Directed Energy), `power_step_table` (power ratio → fire-rate and dispersion multipliers), `can_underpower`, `can_overclock`, `fire_interval_s`, `reload_s`, `muzzle_velocity_mps`, `dispersion_deg`, `recoil_impulse_ns`, `noise_per_shot`, `traverse_deg: Vector2` (min/max yaw), `elevation_deg: Vector2`, `turn_rate_deg_s`, `ammo_types: Array[StringName]`, `indirect_fire: bool`, `tags` (e.g. `&"superweapon"`), `destruction_blast`.
- `AmmoRackDef`: `capacity_per_m3` by ammo size, `reload_k`, `reload_free_distance_m`, `destruction_blast`.
- `AmmoDef`: `id`, `caliber_m`, `mass_kg`, `payload: DamagePayload` (from `DamageApi` public types), `unlock_id`.

## Tasks

### M10-T1 · Weapon and Ammo Rack definitions, mounting and traverse (READY)

**Build**
- Def classes; T1 content: one autocannon, one cannon, one Ammo Rack def; AP and HE ammo defs.
- `WeaponSystem` (VehicleSystem): per weapon, a yaw/pitch state limited by `traverse_deg`/`elevation_deg` and `turn_rate_deg_s`. `AimOrder(point)` → each weapon turns toward its own solution; out-of-arc weapons report `OUT_OF_ARC`.
- Visual: turret and barrel meshes rotate (placeholder boxes).
- Ammo racks bound per weapon (from props), capacity from volume.

**Tests:** traverse clamps; aim solution for a point to the side; rack capacity from volume.

### M10-T2 · Firing, projectiles, reload and recoil (READY)

**Build**
- Fire when ready: spend one round from the first bound rack that has ammo (click order), then the second.
- Projectiles: lightweight simulated objects (not RigidBodies): step position with gravity each physics tick, ray-cast the segment; on hit call `DamageApi.apply_payload` with a `HitInfo`. Mortars (`indirect_fire`) solve the high arc to the aim point.
- Dispersion: random cone from `dispersion_deg` (core `Rng`).
- Reload: `reload_s × (1 + reload_k × max(0, d − d_free))`, d = distance between rack center and weapon center.
- Recoil: `apply_impulse_at` on the vehicle opposite the muzzle direction.
- Noise: `add_noise(noise_per_shot)`.
- Crew: if `CrewQuery.has_crew(…, GUNNERY)` is false and Control Theory is not unlocked → `NO_CREW`, can't fire (neutral CrewQuery says true until M12).
- Emit `weapon_fired`. While a weapon executes orders (aiming, firing), call `report_activity(uid, delta)` on the vehicle so crews gain XP.

**Tests:** rack order; reload distance formula; projectile hits a target box at range; recoil pushes the vehicle; no crew + no Control Theory blocks firing.

### M10-T3 · Ammo types and damage components (READY for AP and HE; others need OQ-16)

**Build** AP (kinetic payload) and HE (explosive payload) with switching (`SET_AMMO` handled per weapon until groups exist). Other ammo from External Ballistics waits for OQ-16.

**Tests:** switching ammo; AP hit produces a kinetic result, HE an explosive one.

### M10-T4 · Power Modes and the Control Theory gate (READY)

**Build**
- `power_ratio = PowerQuery.power_for_part() ÷ rated_power_w`.
- Modes: UNPOWERED (Ballistic only: ratio 0, fires at the floor rate), UNDERPOWERED, NORMAL, OVERCLOCKED; each maps to multipliers via `power_step_table` (a step function).
- Directed Energy below `min_power_w` → `NO_POWER`.
- **Overclock gate (decision C08):** OVERCLOCKED is refused for every weapon until `Unlocks.is_unlocked(&"knowledge.control_theory")`; after that, only weapons with `can_overclock`. UNDERPOWERED needs `can_underpower`. A refused mode leaves the weapon in NORMAL.
- Report power demand per weapon to the power module through its priority keys (`"weapons.group.<n>"` for the weapon's first group, or `"weapons.ungrouped"`).

**Tests:** step function boundaries; overclock refused before Control Theory and allowed after (with the flag).

### M10-T5 · Activation Groups (READY)

Implements the Activation Group rules in 14-weapons.

**Build**
- Blueprint helpers (API above). Up to **9 groups** per vehicle (constant `MAX_GROUPS` from data; OQ-13); a weapon may be in several groups; group meta = name, color, fire pattern (SALVO / RIPPLE), ripple interval.
- Runtime state per vehicle: `active_groups` (set), per-group standing order (HOLD_FIRE or FIRE_AT_WILL, default HOLD_FIRE), per-group target lock (`TargetRef` or none), per-group power mode.
- Handle `WeaponGroupOrder`:

  | Action | Effect |
  |---|---|
  | SELECT | `active_groups = {n}` |
  | ADD_TO_ACTIVE / REMOVE_FROM_ACTIVE | add/remove n |
  | FIRE_START / FIRE_STOP | every ready member of the active set fires (SALVO: same tick; RIPPLE: one member every `ripple_interval_s`, in weapon-uid order) until FIRE_STOP |
  | HOLD_FIRE / FIRE_AT_WILL | set the standing order of the listed groups |
  | LOCK_TARGET / RELEASE_TARGET | members aim at the `TargetRef` each tick (leading moving targets by projectile time) instead of the aim point |
  | SET_POWER_MODE | set every member's mode (refused modes stay NORMAL, see T4) |
  | SET_AMMO | members that carry that ammo switch; others keep theirs |
  | SET_PATTERN | change the group's fire pattern |
  | ASSIGN / UNASSIGN | change membership at runtime (`weapon_uids` + `group_ids`); `WeaponsApi` can write it back to the blueprint when asked |

- `AimOrder` applies to the active set (or to locked groups' targets).
- A weapon in several active groups acts once, not twice.
- Members that can't act (`MemberState` other than READY) are skipped and never block the rest of the group.
- `group_status()` returns, per group: name, color, active?, standing order, locked target, and each member's `MemberState`, ammo count and reload progress, for the HUD group bar.
- Signal `active_groups_changed`.
- Demo scene: a vehicle with 4 weapons in 3 groups firing at target boxes, driven by a scripted order sequence.

**Tests:** select/add/remove; overlap (weapon in groups 1 and 2, both active, fires once per trigger); salvo vs ripple timing; skip rules; ammo switch only on carriers; assignments survive blueprint save/load.

### M10-T6 · Directed Energy, Area Denial and EW weapons (DRAFT)

Flamethrower, laser and matter-wave emitters (using M09-T4/T6), running-gear breakers, terrain-drag fields and jammers. Needs weapon stats, Superweapon list (OQ-12) and M09-T4/T6 first.

## Out of scope

Choosing targets automatically (M14-T2). Reading input (M06-T3). Group bar UI (M19-T1).
