# 00 · Vision

Index of design pages:

| Page | Topic |
|---|---|
| 00-vision | This page: pitch, setting, scope, core loop |
| 01-glossary | Canonical names |
| 10-vehicle-structure | Blocks, bonds, struts, Command Module, Weight Classes |
| 11-mobility | Running gear and movement |
| 12-power | Power plants, relays, conduits, fuel, exhaust |
| 13-damage | Damage types and how damage is resolved |
| 14-weapons | Weapon classes, ammo, power modes, **Activation Groups** |
| 15-detection | Observation Ports, concealment, noise, Recon Scan |
| 16-crew | Crew roles and proficiency |
| 17-controls | Camera, Flagship control, Squads, key contexts |
| 18-builder | Construction tools and build rules |
| 20-world | Map, regions, biomes, weather, POIs, time |
| 21-economy | Currency, materials, production, Home Base |
| 22-logistics | Logistics Nodes and transports |
| 23-progression | Knowledge and Devices |
| 24-ai-and-factions | Factions and AI behavior |
| 25-story | Protagonist, campaign flow, endings |
| 30-art-audio | Art direction and sound |
| 40-tech | Technical requirements |
| 41-milestones | Milestones and acceptance rules |

## Pitch

An open-world sandbox on a hand-made map about designing, building and commanding vehicles. The heart of the game is vehicle construction, simulated combat and real-time tactics, plus exploring the world. Progression is kept minimal; visual and audio feedback are a priority.

Genre: vehicle construction + simulated combat + real-time tactics.

## Setting

A post-war wasteland in the spirit of *Mortal Engines*. The world feels technologically broken: advanced machines next to crude salvage.

- Palette: desert ochre, salt-flat gray-white, volcanic-ash black, with small accents of saturated bright green.
- The protagonist is an embodied AI (a robot). It was at factory settings when the war began and its data link was cut, so it has basic theoretical knowledge but almost no applied technical knowledge. Recovering that knowledge is the backbone of progression (see 23-progression).
- The protagonist is a vehicle architect and commander: it designs and modifies vehicles, explores, completes the main story, and unlocks new technology and larger Weight Classes.

## Positioning

- Single-player PvE indie game.
- **No multiplayer in v1.** The code is structured so multiplayer could be added later (orders are data; the simulation never reads input directly). PvP and local co-op from the original notes are future ideas, not v1.
- Art: low-poly hard-surface models, realistic lighting, pixel filter (see 30-art-audio).

## World structure

- A fixed, hand-made map with four regions. The player always starts in Region 1 (Badlands). Region 1 connects to Region 2; Region 2 branches to Regions 3 and 4.
- Which biomes sit in Regions 2–4 is not decided yet (OQ-01).

## Camera

- Third-person orbit/top-down camera for building, driving, combat and exploration.
- First-person view when the player takes Direct Control of the Flagship.
- Free camera, available from the start.

## Core loop

**Build vehicles → explore → fight → upgrade.**

### One-time content

- **Campaign.** The main story doubles as the tutorial: building and driving basics, exploring, main-story battles, unlocking the basic Knowledge, learning the world and story. The player has a lot of freedom in how they approach it.
- **Research Puzzles.** Unlocking some Knowledge or items starts a quiz or puzzle. No penalty, unlimited attempts. Some Knowledge (e.g. Organic Chemical Engineering) has several stages, each with its own puzzle.
- **Post-game.** After the finale, the map spawns advanced challenges and NPCs that unlock advanced technology. (Expeditions are not planned.)
- **Creative Mode.** Infinite resources, instant building and crafting, all technology and materials available.

### Short-term repeatable

- **NPC encounters.** Random neutral and hostile NPCs. Defeat hostiles for resources; trade with neutrals. Some NPCs may unlock content ahead of the current story progress.
- **Exploration and gathering.** Materials and Scrip respawn at intervals (in-game time). Salvaging unlocks with the Scrap Sorting Manual, a story reward.
- **Delivery Contracts.** Carry supplies, valuables or goods to a location using a mandatory cargo module; earn special rewards or unlock content.
- **Farms and Extractors.** Timed production of basic resources such as fuel.
- **Crew Drills.** Low-pressure minigames that give XP to a specific crew role. Limited plays per period; refresh on a timer.
- **Reverse Engineering.** Spend materials on trial builds for a small chance to unlock a technology without its key item (see 21-economy).

### Long-term repeatable

- Designing, modifying and sharing vehicle blueprints (file sharing; see 40-tech). Certification Trials produce Rated Stats.
- One finale whose epilogue changes with the side quests completed.

## Out of scope for v1

Multiplayer (online or local), player-designed aircraft, a factory-line production sim, seasons, procedural map generation, an in-game community server, Expeditions.
