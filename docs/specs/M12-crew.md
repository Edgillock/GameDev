# M12 · Crew

- **Status:** READY (T5 DRAFT; recruitment needs OQ-06)
- **Folder:** `game/modules/crew/`
- **Uses:** core, vehicle
- **Design:** `docs/gdd/16-crew.md`

## Purpose

Crew data, roles, proficiency and XP, and how crews change vehicles. **All crew effects are stat modifiers** (source `&"crew.<role>"`) or modifier flags read by other modules. Implements core `CrewQuery`.

## Public API sketch

```gdscript
class_name CrewApi
static func register() -> void
static func roster() -> CrewRoster                       # the player's crews
static func assign(vehicle: Vehicle, crew_id: int, part_uid: int, slot: int) -> Error   # slot 0 operator, 1 trainee
static func unassign(crew_id: int) -> void
static func add_xp(crew_id: int, family_or_role: StringName, xp: float) -> void
signal crew_leveled(crew_id: int, key: StringName, level: int)
```

Public types: `Crew` (id, role, origin HUMAN/ROBOT, proficiency per key), `CrewRoster`, `CrewRoleDef` (level curve, bonuses per level as modifiers, thresholds).

## Tasks

### M12-T1 · Crew data, roles and proficiency (READY)

**Build**
- `Crew`, `CrewRoster`, `CrewRoleDef` for the five roles. Proficiency = level + XP per key (Gunnery: per weapon family; others: per role).
- Level curve and per-level modifiers in data.
- `CrewSystem` (VehicleSystem): holds assignments for the vehicle; applies each assigned crew's modifiers to the right parts/vehicle; removes them on unassign or when the part is destroyed.
- Implement `CrewQuery.has_crew()` (replaces the neutral one).
- XP from operating time: listen to the vehicle's `part_activity(uid, seconds)` signal (weapons report it while executing orders; see M04-T2) and add XP to the crew assigned to that part.

**Tests:** modifiers appear/disappear with assignment; level-up from XP; has_crew answers correctly.

### M12-T2 · Gunnery crew and trainees (READY)

**Build**
- Operator slot gives Gunnery bonuses (reload, Target Lock speed/accuracy) to its weapon; trainee slot gains XP only.
- Proficiency per weapon family; switching family keeps `family_switch_keep` (data) of the level; each additional mastered family raises the XP needed (data).
- Level threshold flag `&"ignore_one_destruction_blast"` on the weapon and its racks (M09 reads it).

**Tests:** trainee gives no bonus; family switch keep; threshold flag.

### M12-T3 · Powertrain and Maintenance crews (READY, after milestone 5)

**Build**
- Powertrain: modifiers on power plant output, HP, malfunction chance, and vehicle acceleration; threshold flag `&"malfunction_no_destroy"` (M08 reads it).
- Maintenance: bound to a `WorkshopModule` part (fixed size; def here). Level sets repair radius, max parts served and repair rate; repairs HP over time within radius (`apply_hp_delta` with positive values); player-set priority list; threshold: parts served survive one destruction check per battle (flag `&"survive_one_destruction"`, which M04 already honors).

### M12-T4 · Recon and Salvage crews (READY, after milestone 5)

**Build**
- Recon: Max View Range modifier (capped), night detection bonus, `&"recon_weak_points"` flag at threshold.
- Salvage: after a battle ends (signal from the app/battle flow), compute material returns for lost friendly units and enemy drops by level; none if this crew's vehicle was lost, except at the threshold. Emits `salvage_ready(returns)`; `game/scenes` connects it to the economy (M17), since crew doesn't use economy.

### M12-T5 · Crew Compartments, consumables and recruitment (DRAFT — OQ-06, OQ-21)

Compartment defs (small crew bonus, consumable slots), consumable effects (heat/radiation protection), human vs robot crews and where they come from, Crew Drills.

## Out of scope

UI (M19). Crew Drill minigames (OQ-21).
