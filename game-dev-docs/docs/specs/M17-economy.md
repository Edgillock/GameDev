# M17 · Economy & Home Base

- **Status:** DRAFT (T1 READY; T3 needs OQ-20)
- **Folder:** `game/modules/economy/`
- **Uses:** core, blueprint, progression
- **Design:** `docs/gdd/21-economy.md`

## Purpose

What the player owns and makes: inventory, materials, Scrip, crafting, manufacturing vehicles at the Home Base, Home Base sectors, farms and extractors, trade and contracts.

## Tasks

### M17-T1 · Inventory, materials and Scrip (READY)

`ItemDef` (materials by tier, fuels incl. Fission/Fusion reactor fuel placeholders, consumables, crops), stacks, `Inventory` (add/remove/has, capacity by storage), Scrip wallet. Implements `Saveable`.

### M17-T2 · Crafting and manufacturing queue (DRAFT)

Recipes (data), blueprint bill of materials (from part defs, volume × infill, bond area), manufacturing queue at the Home Base with build time; Creative Mode builds instantly.

### M17-T3 · Home Base sectors (DRAFT — OQ-20)

Fixed sectors with upgrade levels; each level raises build speed and unlocks part types.

### M17-T4 · Farms, extractors, trade and contracts (DRAFT)

Timed production on `GameClock` (in-game time), NPC trading (Scrip + barter), Delivery Contracts with mandatory cargo modules, Salvage Rig collection, and `EconomyApi.receive_salvage(returns)`. Economy does not use the crew module: `game/scenes` connects `CrewApi.salvage_ready` to `receive_salvage`. Reverse Engineering trial builds live here too: take the materials, then call `ProgressionApi.roll_reverse_engineering()`.
