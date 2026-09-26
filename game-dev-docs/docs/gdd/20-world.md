# 20 · World

## Map (decision C01)

- A fixed, hand-made map built in the editor. Four regions.
- Region 1 (Badlands) is always the start. Region 1 → Region 2 → branches to Region 3 and Region 4.
- Which biomes go in Regions 2–4: **left open for now** (OQ-01).
- The map has zones of different **risk levels**; building Logistics Nodes in riskier zones raises the chance of Raids and other random events (see 22-logistics).

## Biomes

### Badlands (Region 1)

- The starting biome. Basic weather only: clear, overcast, rain.
- Hard ground, low terrain drag.
- Lots of destructible terrain and cover.

### Desert

- High terrain drag; medium and soft ground.
- In clear weather, every vehicle's Concealment drops somewhat; certain appearance items offset this.
- Event: **sandstorm** — greatly reduces every vehicle's view range.

### Volcanic Fields

- Heat: slowly raises the temperature of every part that has a temperature.
- Raises the Malfunction Chance of certain power plant types, raises conduit loss, and raises the dispersion of certain weapon types.
- Mostly hard ground; lava areas are medium or soft.
- Event: **eruption** — magma areas appear (thermal damage) and rocks fall from the sky (kinetic damage).

### Salt Flats

- Nearly flat, hard ground.

### Snowfield

- Hard, medium and soft ground side by side.

### Oasis

- Farming land for functional crops. Crops can be taken home so the Home Base can grow them. After Organic Chemical Engineering, crops can be turned into industrial materials: fuels, chemicals and other consumables.
- All medium or soft ground; high terrain drag.
- Some areas give a high Concealment bonus.

## Weather (decision G07 — all types)

Each weather type sets: view range multiplier, Ground Type modifier, Concealment modifier, Noise modifier (values in data).

| Weather | Where | Effect |
|---|---|---|
| Clear / Overcast | Everywhere | Baseline; overcast slightly lowers view range |
| Rain | Badlands and others | Hard ground behaves as medium; mud |
| Sandstorm | Desert | View range × 0.3 |
| Snow / Blizzard | Snowfield | Softer ground, lower view range |
| Fog | Salt Flats mornings | Short view range; sound carries |
| Ash fall | Volcanic Fields | Lower view range; clogs exhausts |
| Heat wave | Hot biomes | Power plants overheat faster |
| Night | Everywhere | View range drops sharply without night vision |

The Satellite Uplink shows live weather on the minimap. No seasons in v1 (decision G19).

## Time and Time Acceleration (decision C19)

- Most of the time (e.g. long drives) the player can speed up time.
- Events still run during acceleration; certain events force it to stop.
- All refresh timers (resource respawns, farms, Crew Drill plays) run on **in-game time**. Accelerating is not free: fuel burns and random events (raids, weather) still roll.

## Points of Interest (decision G04 — all types)

| POI | What's there |
|---|---|
| Wreck fields | Salvaging |
| Ruined towns | Materials and story logs |
| Abandoned depots | Sites to claim for Logistics Nodes |
| Research sites | Research Puzzles and Knowledge |
| Trader caravans / mobile towns | Trade and contracts |
| Enemy outposts | Combat, loot, blueprint drops |
| Signal towers | Reveal a map area and its weather |
| Tech caches | Raise Reverse Engineering odds for a related technology |
