# 12 · Power

## Power Plants

A Power Plant produces power. It can:

- drive Running Gear Units inside its **Drive Range** (a sphere or a box around it);
- feed Power Relays and weapons through **Power Conduits**.

### Types

| Type | Code | Notes |
|---|---|---|
| Steam Engine | `STEAM` | External combustion. |
| Combustion Engine | `COMBUSTION` | Internal combustion. |
| Diesel-Electric | `DIESEL_ELECTRIC` | Combustion engine driving generators; electric output. |
| Fission Reactor | `FISSION` | Reactor type 1. |
| Fusion Reactor | `FUSION` | Reactor type 2. How it differs from fission: OQ-18. |
| Exotic | `EXOTIC` | Special types. |

The type sets the **fuel** it burns and the **energy type** it outputs. Variants of a plant can change fuel, energy type, noise, output power and more.

### Stats

mass, center of mass, `hp`, `is_active`, `malfunction_chance`, the three resistances and protections, `overheat_temp`, `meltdown_temp`, `heat_capacity`, `heat_dissipation`, `destruction_blast`, `drive_range`, fuel consumption rate, output power, noise, output energy type, fuel type.

### Malfunctions

- `malfunction_chance` starts at a base value and rises as HP falls.
- Every hit triggers a malfunction check. Fail → the plant shuts down. Fail while **overheated and active** → the plant is destroyed.
- While overheated and active, a malfunction check also runs at a fixed interval even without hits.
- Powertrain crew at a certain level turns "destroyed" into "shut down" (see 16-crew).

### Mandatory attachments

Some plant types need a **Fuel Tank** and/or an **Exhaust Stack** to run.

## Fuel Tanks and Fuel Lines (decision C22)

- A Fuel Tank is a box; its volume sets fuel capacity.
- It shares HP, resistances and protections with the power stat set and has its **own** Destruction Blast. It has no output power.
- A tank feeds a plant either by **touching it**, or through a **Fuel Line** routed like a conduit.
- A Fuel Line has HP; destroyed = that tank's supply is cut. Leak behavior and other details: OQ-17.

## Exhaust Stacks

- One end touches the Power Plant; the outlet must be in open or semi-open air.
- `exhaust_efficiency = min(1.15, 0.8 + exhaust height coefficient)`. The height coefficient comes from the outlet's height above the vehicle's lowest point (mapping in data).
- Exhaust efficiency multiplies the plant's output power.
- Same stat types as conduits; Destruction Blast is zero.

## Power Relays

- Types: Electric, Thermal, Exotic.
- Receives power x through a conduit and outputs `k × x`, never more than its maximum output P_max (k = conversion efficiency).
- Converts between thermal and electric energy.
- Extends supply range: **Running Gear Units inside its Drive Range, and weapons connected to it by conduit, can draw from it** (decision C21).
- Same stat types as a Power Plant; usually lower HP and a bigger Destruction Blast.

## Power Conduits

- Types: Electric, Thermal, Exotic; each with subtypes by material and performance.
- HP does not change performance; at 0 HP the conduit is destroyed and cuts the supply.
- Stats: resistances, protections, `hp`, `is_active`, `overheat_temp` (same overheat rule as power plants), `destruction_blast` (depends on subtype), `loss_per_m`.
- Usually lower HP than other power parts.
- Loss (decision G20): `P_out = P_in × max(0, 1 − loss_per_m × length)`.

## Energy type rules

- A weapon's energy type must match its supply. Weapons never convert energy; relays do.
- **Wireless Power Transfer** (Knowledge): electric Power Plants and Relays can feed specific parts without conduits; power still falls off with distance.

## Building power (decision G01)

- **Drive Range preview:** placing a plant or relay shows its range as a translucent shape; running gear inside it lights up.
- **Conduit auto-routing:** click start and end; the conduit routes around blocks; waypoints can be dragged. Length and loss update live.
- **Power budget panel:** per network: supply, demand, conduit loss, exhaust efficiency.
- **Validation badges:** exhaust not in open air; tank neither touching nor linked; weapon unpowered; wrong energy type.
- **Color by energy type** in the power view: thermal orange, electric cyan, exotic green.
- **Power priority groups:** when demand exceeds supply, the player ranks what gets power first (drive, Activation Groups, …).
