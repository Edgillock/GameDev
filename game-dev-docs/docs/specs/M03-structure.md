# M03 · Structure

- **Status:** READY
- **Folder:** `game/modules/structure/`
- **Uses:** core, blueprint
- **Design:** `docs/gdd/10-vehicle-structure.md`

## Purpose

Works out how the parts of a blueprint hold together: which faces are bonded, how strong each bond is, which parts are connected to the Command Module, and the vehicle's mass properties. Pure data and math, no nodes.

## Public API sketch

```gdscript
class_name StructureApi
static func build_graph(bp: Blueprint) -> StructureGraph
static func mass_properties(bp: Blueprint, graph: StructureGraph) -> MassProperties
```

Public types: `StructureGraph`, `Bond`, `MassProperties`, `SplitResult`.

`StructureGraph` (RefCounted, mutable at runtime):
- `bonds: Array[Bond]`; `bonds_of(part_uid)`; `neighbors(part_uid)`.
- `remove_part(uid) -> SplitResult`, `damage_bond(bond_id, amount) -> SplitResult`, `break_bond(bond_id) -> SplitResult`.
- `main_group() -> PackedInt32Array` (parts connected to the Command Module), `detached_groups() -> Array[PackedInt32Array]`.

`Bond`: `id`, `owner_uid`, `other_uid`, `axis` (+X/+Y/+Z of the owner), `area_m2`, `center_m`, `adhesive_id`, `hp`, `effective_strength`, `resonance_band_hz`, `is_strut_contact`.

## Tasks

### M03-T1 · Bond computation (READY)

**Build**
- For every part, look at its +X, +Y and +Z faces. For every other part whose opposite face lies in the same plane and overlaps, create one `Bond` owned by the first part. Overlap area in m².
- Adhesive: the owner part's `adhesive_id`, else the blueprint default.
- `effective_strength = min(strength × compat(owner material), strength × compat(other material))`, where a Strut side always counts as compatibility 1.
- Bond HP and resonance band from the adhesive def (HP scales with area: `hp_per_m2` in the adhesive data).
- Use a spatial hash on grid cells so this stays fast for thousands of parts.

**Tests:** two touching blocks → one bond with the right owner and area; partial overlap area; a face touching three neighbors → three bonds; no bond across a gap; strut compatibility rule; 5,000-part fixture builds in under 200 ms (log the time).

### M03-T2 · Connectivity, detached groups and mass properties (READY)

**Build**
- Connectivity over bonds with HP > 0. The group containing the Command Module is the **main group**; every other connected group is **detached**.
- `remove_part`, `damage_bond`, `break_bond` update the graph incrementally and return a `SplitResult` listing any newly detached groups.
- `MassProperties`: total mass, center of mass, and an inertia tensor approximated from part boxes (sum of box inertias + parallel-axis). Mass per part = volume × density × infill for material parts, `base_mass_kg` for functional parts.
- `validate_connectivity(bp) -> ValidationReport` adds `NOT_CONNECTED` issues for parts outside the main group (the builder shows them).

**Tests:** breaking the only bond between two halves splits them; breaking one of two parallel bonds doesn't; removing the Command Module makes everything detached; mass and center of mass of a known L-shape; inertia of a single box matches the formula.

## Out of scope

Applying damage (M09 decides how much; this module only applies the result). Physics bodies (M04).
