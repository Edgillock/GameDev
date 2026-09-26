# M18 · Logistics

- **Status:** DRAFT — build after the vertical slice
- **Folder:** `game/modules/logistics/`
- **Uses:** core, vehicle, ai, economy
- **Design:** `docs/gdd/22-logistics.md`

## Purpose

Logistics Nodes (Depots, Airfields), transports and their routes, resupply and repair of player vehicles, and Raids.

## Tasks

### M18-T1 · Nodes and storage (DRAFT)
Node placement at claimable sites, storage units, repair (cost scales with damage) and resupply of player and allied vehicles; no new player vehicles (Home Base only). Gate: Control Theory + Satellite Uplink.

### M18-T2 · Transports and routes (DRAFT)
Modular transport defs (module variants chosen before manufacturing), NPC blueprint transports, player-set routes between nodes using the AI driver (M14-T1); transport aircraft between Airfields after Aeronautics (simple flight paths, no player-designed aircraft). After Radio Communications: temporary route changes.

### M18-T3 · Raids and node defenses (DRAFT)
Risk levels per map zone — logistics doesn't use the world module, so this needs a change request adding `risk_level_at(pos)` to core `EnvironmentQuery` (implemented by M13); raid chance by risk, observation posts and weapon stations (vehicle weapon families), remote operation of node weapons after Radio Communications.
