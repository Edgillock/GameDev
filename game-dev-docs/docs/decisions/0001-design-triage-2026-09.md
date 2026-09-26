# 0001 · Design triage — September 2026

Decisions made by the owner on the GDD Triage Board (review of the original `game.md`, 389 lines). IDs match the board. New decisions go into new numbered files in this folder.

## Terms

| ID | Topic | Decision |
|---|---|---|
| A01 | Chassis vs running gear | Modular Running Gear Units; no chassis part |
| A02 | HP vs durability | One value: HP; performance curves on HP % |
| A03 | Grid and rotation | Axis-aligned blocks on a fine grid; functional parts rotate in 90° steps |
| A04 | "Prime propulsion unit" | Power Plant |
| A05 | Key items | Two kinds: Knowledge and Devices |
| A06 | "Target acquisition" | Split: Detection vs Target Lock |
| A07 | "Vehicle rating" | Both: Weight Class (ramming) + Combat Rating (AI) |
| A08 | Heat model | Heat Capacity + Heat Dissipation |
| A09 | Penetration names | Type-specific: Kinetic Penetration, Blast Power, Chemical Potency (+ matching protections) |
| A10 | "Blind Box" | Reverse Engineering |
| A11 | Stealth stats | Concealment + Recon Masking |
| A12 | Crew | Mixed: humans early, robots later |
| A13 | "Holographic Instrument" | Holo-Terminal |
| A14 | "Garbage Classification Manual" | Scrap Sorting Manual |
| A15 | "Truss" | Strut |
| A16 | Vehicle destroyed | Command Module destroyed |
| T49 | Nuclear power | Two reactor types: Fission Reactor and Fusion Reactor |
| — | Other renames | All ~90 proposed renames accepted (see 01-glossary) |

## Contradictions

| ID | Topic | Decision |
|---|---|---|
| C01 | Map | Hand-made fixed map |
| C02 | Multiplayer | Single-player v1, multiplayer-ready structure |
| C03 | Art | Low-poly + realistic lighting + pixel filter |
| C04 | Movement | Physics-driven |
| C05 | Weight Class caps | Bounding box + mass + part count |
| C06 | Who builds | Home Base builds; nodes repair and resupply |
| C07 | Production depth | Sector upgrades |
| C08 | Overclock | Locked for all weapons until Control Theory; then every eligible weapon |
| C09 | Weapon categories | Class by delivery; Superweapon as a tag |
| C10 | Material Printer | Additive Manufacturing unlocks the Material Printer |
| C11 | Workshop size | Fixed size; level raises reach |
| C12 | Explosive radius | Fixed radius; protection reduces damage |
| C13 | Overheating | Resistances × factor; direct flame/laser damage ignores resistance |
| C14 | Resonance | Every material has a Resonance Band |
| C15 | AI vehicle control | **Owner's own answer:** full control of the Flagship only; AI vehicles are ordered in groups (move to a location, fire at a target), Command & Conquer style |
| C16 | Gunnery crew | One weapon at a time; mastery per family; second slot is a trainee |
| C17 | Salvaging unlock | Scrap Sorting Manual is the story reward |
| C18 | Endings | One finale, epilogue flavored by side quests |
| C19 | Timers | In-game time; Time Acceleration has costs |
| C20 | Level scales | Everything on T1–T6; Family → Model → Variant |
| C21 | Relays | Relays can feed running gear and weapons |
| C22 | Fuel tanks | Allow Fuel Lines |
| C23 | Aircraft | Transports and drone swarms only |
| C24 | Tracks/chains | Physics for hull and suspension; animate the rest |
| C25 | Detection formula | Clamp to 0–1 |
| C26 | Free camera | Available from the start |

## Empty sections

| ID | Topic | Decision |
|---|---|---|
| G01 | Power building | All six ideas |
| G02 | Controls | **Unanswered → recommended defaults used:** tank driving, weapon groups, RTS layer, gamepad-ready input. Weapon groups expanded into **Activation Groups** by owner request (below) |
| G03 | Recon Scan | **Unanswered → recommended defaults used:** scan cone; active scans add Noise |
| G04 | POIs | All eight |
| G05 | Currency | Scrip + barter |
| G06 | Materials | All four sets |
| G07 | Weather | All types |
| G08 | Region biomes | Left open (OQ-01) |
| G09 | Flow | Region 1 tutorial, Region 2 hub, branch choice, length target |
| G10 | Factions | All six |
| G11 | AI behavior | All five |
| G12 | Art | All six |
| G13 | Sound | Engine voices, matter-wave tuning audio, distance-delayed gunfire, radio chatter. **Owner addition:** after Radio Communications, radio chatter hints at random events the player can exploit |
| G14 | Language | GDScript with static typing |
| G15 | Practices | Godot 4.7 + Jolt, data files, rules/visuals split, gdUnit4, versioned formats, Windows first |
| G16 | Milestones | All, plus "done when" per task |
| G17 | Electromagnetics | Coilgun/railgun, electric drive upgrades, EW jammers and radar, EM shielding |
| G18 | Community | File sharing first |
| G19 | Seasons | Cut for v1 |
| G20 | Formulas | All seven starting formulas |

## Build

| ID | Topic | Decision |
|---|---|---|
| B01 | Git | One branch per task; owner merges |
| B02 | Where the design lives | In the repo (`docs/gdd`) and in the claude.ai Project "Game Dev" |
| B03 | Spec size | Module specs split into numbered tasks |

## Added after triage (owner request, 2026-09-26)

**Activation Groups.** Every weapon can be assigned to activation groups; calling a group with its shortcut key makes all weapons in it respond to commands as a whole. Written into 14-weapons, 17-controls, 18-builder and specs M06, M07, M10, M19. Assumptions: 9 groups, multi-membership (OQ-13); number keys switch meaning between Drive and Command views (OQ-14).
