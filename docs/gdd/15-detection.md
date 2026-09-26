# 15 · Detection and concealment

Two separate ideas (decision A06):

- **Detection** — your side knows an enemy exists and where it is. This page.
- **Target Lock** — a weapon is aimed at and tracking a target. See 14-weapons.

## Observation Ports

- Each vehicle can carry a fixed number of Observation Ports on its surface, placed by the player. They can be destroyed.
- All ports share one timer: every N physics ticks, each port casts a fixed number of fixed-length rays spread evenly over the sphere.
- Rays are blocked by certain objects (terrain, solid parts).
- Ray length = **Max View Range**.

## Detection rule

When a ray hits an enemy:

```
detection_range = max_view_range − (max_view_range − auto_spot_range) × clamp(concealment − noise, 0, 1)
```

(clamped, decision C25). `concealment` is the value at the hit point; `noise` is the target's current Noise. If `detection_range` > distance to the hit point, the ray **detects** the target.

- **Auto-Spot Range:** when two hostile vehicles are closer than this, both are detected regardless of rays.
- A single successful ray means the target is detected.
- Recon crew proficiency improves detection (see 16-crew).

## Noise

- Firing weapons, running certain parts and some conditions (e.g. a searchlight at night) add Noise, which decays over time.
- Firing or using a searchlight **at night** adds much more Noise than in daytime.
- Distance-delayed sound is a presentation effect only (see 30-art-audio).

## Night

Night greatly reduces the view range of every vehicle without night vision equipment (Night Vision Device).

## Concealment and Recon Masking (decision A11)

- **Concealment** comes from paint. Each paint has a Concealment value per biome and weather condition (positive real). Clear weather in the Desert lowers every vehicle's Concealment; certain appearance items offset this.
- **Recon Masking** comes from paints, attachments and ornaments. It lowers the chance that an enemy Recon Scan reveals your armor, weak points and other details for the parts it covers.
- Certain areas (e.g. parts of the Oasis) give a Concealment bonus.

## Recon Scan (the Recon crew's skill)

The original notes stopped mid-sentence here. Defaults used (you didn't answer that card; confirm or change):

- **Scan cone:** each use scans a cone for 5 s; revealed parts are drawn on the target's silhouette.
- **Active scans are loud:** each use adds Noise.
- Reveals part of the enemy's configuration beyond visual range: mainly armor, weapons and power.
- It has a cooldown. Its range equals Max View Range.
- At a certain Recon crew level: a chance to reveal where weak-point parts are.
- Can mark resonance bands of materials you have unlocked (not for partly filled blocks).

## How AI reacts to detection

When an AI detects the player, it chooses flee, keep distance or attack by comparing **Combat Ratings** (its own vs the player's), the player vehicle's condition, and the parts or cargo it carries (see 24-ai-and-factions). Combat Rating formula: OQ-07.

## Performance

Many ports × many rays × many vehicles is expensive. Rays are scheduled in a budget spread across frames (see 40-tech).
