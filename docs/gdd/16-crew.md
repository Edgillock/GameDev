# 16 · Crew

## Who the crew are (decision A12)

Mixed: **human survivors** are recruited early; **robot crews** become possible later. Where humans are recruited and what unlocks robot crews: OQ-06.

## Crews and roles

A **Crew** is one team. Each crew has one role and a **Proficiency** (level + XP).

| Role | Code | In short |
|---|---|---|
| Powertrain | `POWERTRAIN` | Power plants and mobility |
| Maintenance | `MAINTENANCE` | Repairs, via the Workshop Module |
| Recon | `RECON` | View range and the Recon Scan |
| Salvage | `SALVAGE` | Recovers materials after battles |
| Gunnery | `GUNNERY` | Operates weapons |

**XP sources:** Crew Drills (minigames, limited plays per period) and time spent operating (e.g. a weapon's time executing orders).

All crew bonuses are applied as **stat modifiers** through the common modifier system, never by editing base stats.

## Crew Compartments

- A vehicle can carry several Crew Compartments. They slightly improve crew stats (like ventilation in *World of Tanks*).
- Each holds a limited number of **consumables** with extra bonuses or protections (e.g. against heat or radiation effects on crew).
- Compartments are optional; without one there is simply no bonus.

## Powertrain

- Bonuses to power plant hardware: output, HP, malfunction chance.
- Mobility bonuses such as acceleration.
- At a certain level: when a power plant fails its malfunction check while overheated and active, it **shuts down instead of being destroyed**.

## Maintenance (decision C11)

- Bound to the **Workshop Module**, which has a **fixed size** and armor-style stats.
- Level raises the repair radius, the number of parts it can serve and the repair rate.
- The player can set repair priority among the parts it serves.
- It raises the HP of the parts it serves and regenerates their HP over time.
- At a certain level: parts it serves survive one destruction check (once per battle).

## Recon

- Runs the **Recon Scan** skill (see 15-detection).
- Max View Range grows with level, up to a cap.
- At a certain level: a chance to reveal where the enemy's weak-point parts are.
- Small bonus to detection at night.

## Salvage

- After a battle, friendly units lost in it have a chance to return part of their materials (not consumables such as ammo or fuel). Destroyed enemies have a chance to drop crafting materials.
- Doesn't work if the vehicle carrying this crew was lost (Command Module destroyed).
- Level raises the chance and the share returned.
- At a certain level: a chance to recover a lost unit whole, and a partial return even if this crew's own vehicle was lost.

## Gunnery (decision C16)

- Before Control Theory, every weapon needs a Gunnery Crew to fire.
- Proficiency improves weapon stats: reload speed, Target Lock speed and accuracy, and more.
- A crew mans **one weapon at a time** and keeps a separate proficiency for **each weapon family**. Switching families keeps a share of the proficiency. Mastering more families takes longer each time (more operating time or higher drill scores).
- Each weapon has up to two crew slots: the operating crew and a **Trainee**. The trainee gains XP but gives no bonus.
- At a certain level: ignores one weapon or Ammo Rack Destruction Blast.
