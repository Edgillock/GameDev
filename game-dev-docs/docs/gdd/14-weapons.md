# 14 · Weapons

## Weapon Classes (decision C09)

Every weapon belongs to exactly one class, by how it delivers its effect:

| Class | Examples | Power |
|---|---|---|
| **Ballistic** | Cannons, autocannons, mortars (direct and indirect fire) | Electric or thermal, by type/variant |
| **Directed Energy** | Flamethrowers, lasers, matter-wave emitters | Needs a minimum power to work |
| **Area Denial** | Running-gear breakers (explosive/kinetic), terrain-drag fields | None; very limited uses |
| **Electronic Warfare (EW)** | Jammers that lower enemy Target Lock efficiency and other stats; no damage | By type |

**Superweapon** is a tag, not a class. It marks certain heavy models in any class: stacked damage effects, large areas or very high damage, balanced by very limited uses, very high power draw or very long cooldowns. List and rules: OQ-12.

## Ammunition (Ballistic)

| Ammo | Available | Damage components (proposed, OQ-16) |
|---|---|---|
| AP (solid shot) | From start | Kinetic |
| HE | From start | Explosive |
| APCR | External Ballistics | Kinetic (higher penetration, smaller diameter) |
| HEAT | External Ballistics | Kinetic jet (high penetration, short) |
| APHE | External Ballistics | Kinetic, then explosive after penetrating |
| HESH | External Ballistics | Explosive with strong overpressure |
| Cluster HE | TBD | Several small explosive submunitions |
| Chem / Cluster Chem | TBD | Chemical |

Different ammo gives different damage types and effects. Internal Ballistics improves propellants (reload time, muzzle velocity, dispersion, firing noise).

## Weapon parts

- Most weapons have a **body** and one or two **Ammo Racks**. Both share armor-style stats (resistances, protections, HP, `is_active`, `overheat_temp`).
- Ballistic weapons also have: muzzle velocity (trajectory, range, kinetic damage), `dispersion_deg`, recoil (applied to the physics body) and noise (feeds detection).
- Some weapon bodies and Ammo Racks release a Destruction Blast when destroyed.

## Ammo Racks

- A box with adjustable size (minimum and maximum volume, grid step). Volume sets capacity.
- Weapons and racks are placed separately and don't have to sit together. The player selects a weapon, then the racks bound to it: **up to 2 racks per weapon; the click order is the order of use.**
- Reload modifier from the distance d between rack center and weapon center (decision G20): `reload_time × (1 + k × max(0, d − d_free))`.

## Power and Power Modes

- The weapon's type sets the energy type it needs. Weapons never convert energy.
- `power_ratio = supplied power ÷ rated power`. Performance follows a **step function** of power ratio (data).
- Directed Energy weapons have a minimum power; below it they don't work.
- Ballistic weapons have a rated power; with no power they still fire, slowly (Unpowered).
- Power Modes: **Unpowered**, **Underpowered** (lower fire rate, with a floor), **Normal**, **Overclocked** (higher fire rate, worse dispersion and aim time).
- **Overclocking is locked for every weapon until Control Theory is unlocked**; after that, every weapon whose variant allows it (`can_overclock`) can overclock (decision C08). `can_underpower` is also a per-variant flag.

## Variants

Weapons follow Family → Model → Variant. A variant inherits everything and changes some of: `can_underpower`, `can_overclock`, HP, damage type, damage values, and more. Each variant is unlocked by a blueprint; it can be crafted directly or made by adding materials to the base weapon.

## Weapon families across Weight Classes (decision C20)

All families use the T1–T6 scale. Starting spans (OQ-23):

| Family | Classes | Models per class | Variants per model |
|---|---|---|---|
| Autocannon | T1–T3 | 1–3 | 1–4 |
| Cannon (general artillery) | T1–T5 | 1–6 | 1–4 |
| Mortar (indirect fire) | T2–T6 | 1–3 | 1–4 |

Some variants only change appearance, sound or effects. Mortars need a loading mechanism with animation; the link between the loader and its Ammo Rack is a procedurally generated animated part.

## Crew and automation

- Before **Control Theory**, a weapon only fires if it has a Gunnery Crew.
- After Control Theory, weapons can take Target Lock and fire on player orders without crew. Crew still improves them (see 16-crew).
- **Target Lock** (decision A06): the weapon is aimed at a target and tracking it. Affected by Gunnery Crew proficiency, the Ballistic Computer and enemy EW.

## Activation Groups

Every weapon on a vehicle can be assigned to **Activation Groups**. When the player calls a group with its shortcut key, all weapons in that group respond to commands **as a whole**.

### Groups

- Each vehicle has **9 Activation Groups**, called with keys **1–9** in the Drive view (rebindable; see 17-controls). *(9 groups: assumption, OQ-13.)*
- A weapon can belong to **several groups** at once (e.g. the main gun in group 1 "Main guns" and group 9 "Everything"). *(Assumption, OQ-13.)*
- A group has an optional name and color (default "Group 1" … "Group 9").
- Group membership is stored in the blueprint, so a vehicle keeps its groups when saved, shared or rebuilt.
- A weapon in no group can still be commanded by selecting it on its own.

### Assigning weapons

- **In the builder:** the weapon's properties show nine group toggles; a group panel lists each group's members and lets you rename and recolor groups.
- **In the field:** the HUD Weapon Groups panel lets the player add or remove weapons from groups while driving. Changes can be saved back to the blueprint.

### Calling a group

- Press a group key → that group becomes the **active group**; all its weapons slew toward the aim point.
- **Shift + group key** adds or removes a group from the active set, so several groups can be active together.
- Commands always apply to every weapon in the active set.

### Group commands

| Command | What every member does |
|---|---|
| **Aim** | Computes its own firing solution to the shared aim point: straight line for direct fire, ballistic arc for mortars. |
| **Fire** | Every member that is ready fires. Each group has a fire pattern: **Salvo** (together) or **Ripple** (staggered by an interval set per group). |
| **Hold fire / Fire at will** | Standing order per group. *Fire at will* needs a Gunnery Crew or Control Theory; the automatic gunner picks targets from detected enemies. |
| **Target Lock** | Locks on the target under the cursor; members keep tracking it until released or the target is lost. |
| **Power Mode** | Sets Underpowered / Normal / Overclocked for all members. Members that can't use the mode stay in Normal. Overclocked only after Control Theory. |
| **Ammo switch** | Members that carry the chosen ammo switch; others keep their current ammo. |

### Members that can't act

Members that are out of their traverse arc, unpowered (Directed Energy below minimum), out of ammo, destroyed, reloading, or without crew before Control Theory are **skipped**, never block the rest of the group, and show their state in the HUD group bar.

### Same system for AI

AI vehicles use the same Activation Groups. The AI gunner issues the same group orders a player would. Group commands are **Orders** (data), so input, AI and any future network layer share one code path.
