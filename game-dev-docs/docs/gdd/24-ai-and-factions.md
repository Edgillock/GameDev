# 24 · AI and factions

## Factions (decision G10 — all)

| Faction | Attitude | Role |
|---|---|---|
| Scavenger clans | Hostile | Fast, light vehicles; raid your Logistics Nodes |
| Traction towns | Neutral | Rolling markets and quest hubs (the *Mortal Engines* nod) |
| Remnant war machines | Hostile | Autonomous pre-war robots guarding advanced technology; source of matter-wave weapons |
| Lost units | Neutral / ally | Robots like the protagonist, stuck at factory settings; story NPCs and possible allies |
| Oasis growers | Neutral | Crops and chemistry quests |
| Bounty hunters | Hostile | Appear when you carry valuable cargo |

Neutral and hostile NPCs spawn at random. Hostiles can be defeated for resources; neutrals trade.

## AI behavior (decision G11 — all)

- **Same rules as the player.** AI vehicles are built from blueprints with the same parts, physics, damage and Activation Groups. No hidden AI stats. This halves the code to maintain.
- **Stance from Combat Rating.** On Detection, an AI chooses flee, keep distance or attack by comparing its Combat Rating with the player's, the player vehicle's condition, and the parts or cargo it carries.
- **Morale and surrender.** Badly damaged AI retreats; a surrendered vehicle gives extra salvage.
- **Blueprint pools.** Each faction × region × Weight Class has a hand-made pool of designs.
- **Squad tactics.** AI groups flank, focus fire and pull back damaged units.

## Allied AI vehicles

- Each needs a Brain-in-a-Vat. Before Radio Communications they act on their own and follow the Flagship; after it they obey Squad orders (see 17-controls).
- Their gunners use Activation Group orders, the same as the player.

## NPC look

People and figures are drawn like unfinished sketches / edge-detected, threshold-filtered images — the look of an AI vision system preprocessing what it sees (see 30-art-audio).
