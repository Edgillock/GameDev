# 10 · Vehicle structure

## What a vehicle is made of

A vehicle is a set of **boxes** placed on a grid:

- **Armor Blocks** — structure and protection.
- **Struts** — structural members that tie parts together.
- **Bonds** — glue between touching faces (Adhesive).
- **Functional parts** — Running Gear Units, Power Plants, Power Relays, Power Conduits, Fuel Tanks, Fuel Lines, Exhaust Stacks, weapons, Ammo Racks, Crew Compartments, the Workshop Module, Observation Ports, the Salvage Rig, cargo modules, and exactly one **Command Module**.

There is **no separate chassis part** (decision A01). All the stats the original notes gave to "the chassis" belong to each Running Gear Unit (see 11-mobility).

## Command Module

- Every vehicle has exactly one Command Module. The builder refuses to deploy a vehicle without one.
- On the Flagship it houses the protagonist; on an AI vehicle it houses a Brain-in-a-Vat.
- **Destroyed Command Module = vehicle lost** (decision A16). This is what "completely destroyed" means everywhere else (e.g. Salvage crew rules).

## Grid and orientation (decision A03)

- Blocks, struts, tanks and ammo racks are **axis-aligned boxes**; they never rotate.
- Size and position snap to a grid step that depends on the Weight Class: 0.1 m at T1; other classes TBD (OQ-03).
- Functional parts (weapons, running gear, power plants…) can face any of the six axis directions in 90° steps.
- Sloped looks come from chamfers only.

## Armor Blocks

- Always a box. Minimum/maximum edge length and total volume are limited by game progress.
- Resized in steps of the grid (see 18-builder for the controls).
- Stats:
  - `density` (kg/m³); mass = volume × density × infill (infill scaling of mass TBD: linear as a starting point).
  - center of mass (computed).
  - `infill` 0–1 (adjustable only with the Material Printer; default 1). Material cost ∝ volume × infill.
  - `hp` (integer).
  - `kinetic_resistance`, `explosive_resistance`, `chemical_resistance` (positive real; raw damage is divided by these).
  - `kinetic_protection`, `blast_protection`, `chemical_protection` (see 13-damage).
  - `overheat_temp`, `meltdown_temp`, `heat_capacity`, `heat_dissipation` (see 13-damage).
  - `resonance_band` (decision C14). Infill shifts the band; the band of a partly filled block cannot be revealed by Recon.
- Starting unlocks: basic armor, struts and adhesive are available from the start.

## Bonds and Adhesive

- Adhesive has no collision and no volume, but bonds are hit by damage rays like any other object.
- **Ownership:** each block owns the bonds on its +X, +Y and +Z faces. So each contact between two blocks is owned by exactly one of them.
- A face can touch several neighbors; there is one bond per touching neighbor, and its **bond area** is the overlap area.
- Adhesive usage (material cost) is proportional to bond area.
- Bond stats: `hp`, the three resistances and protections, `resonance_band`, `strength`, and **compatibility** — a lookup table of adhesive × bonded material. Effective strength of a bond = the lower of `strength × compatibility(side A)` and `strength × compatibility(side B)`.
- Bonds define which parts are connected. After deployment, any block or group of blocks with **no connection path to the Command Module** (through bonds and struts) becomes loose debris and is simulated as a separate physics object. (The original notes said "an armor unit with no connections"; extending this to disconnected groups is a clarification.)

## Struts

- Box-shaped, with collision and mass (per-volume mass).
- Same stat types as bonds, but compatibility with every material is always 1.
- Several strut materials with different stats.
- Resizable like armor blocks.

## Chamfers

- Each armor block edge can be chamfered: square, round or asymmetric square.
- Chamfer size is limited by the block's edge lengths.
- **Visual only:** chamfers change no stats and not the collision shape.

## Weight Classes

Each class caps a vehicle's **bounding box, total mass and part count** (decision C05). The part count cap protects performance.

| Class | Size (approx.) | Mass (approx.) | Part count cap |
|---|---|---|---|
| T1 | 10 m | 50 t | TBD |
| T2 | 25 m | 250 t | TBD |
| T3 | 50 m | 1,000 t | TBD |
| T4 | 100 m | 5,000 t | TBD |
| T5 | 150 m | 10,000 t | TBD |
| T6 | 200 m | 40,000 t | TBD |

Exact caps and grid steps per class: OQ-03. How classes unlock: OQ-02.

## Variants and tech trees

Running gear and weapons use the hierarchy **Family → Model → Variant** (decision C20). A variant inherits everything from its model and changes some stats. Variants form a tech tree; each is unlocked by a blueprint or key item. A variant can be crafted directly, or made by adding materials to the base model.

## Other parts (details elsewhere)

| Part | Page |
|---|---|
| Running Gear Unit | 11-mobility |
| Power Plant, Power Relay, Power Conduit, Fuel Tank, Fuel Line, Exhaust Stack | 12-power |
| Weapons, Ammo Racks | 14-weapons |
| Observation Port | 15-detection |
| Crew Compartment, Workshop Module | 16-crew |
| Salvage Rig, cargo modules | 21-economy |
