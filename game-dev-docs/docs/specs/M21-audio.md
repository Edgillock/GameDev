# M21 · Audio

- **Status:** READY (T3–T4 DRAFT)
- **Folder:** `game/modules/audio/`
- **Uses:** core, vehicle, power, weapons, damage, world
- **Design:** `docs/gdd/30-art-audio.md`
- **Kind:** presentation

## Purpose

All sound playback. Audio listens to module signals; no module calls audio.

## Tasks

### M21-T1 · Audio framework and engine voices (READY)
Audio buses (master, engines, weapons, impacts, ambience, radio), a pool of 3D players, engine loops per power plant type pitched and mixed by load (placeholder sounds generated or CC0, sources listed in `data/credits.md`).

### M21-T2 · Weapon and impact sounds with distance delay (READY)
On `weapon_fired` and `damage_applied`: play at the event position, delayed by distance ÷ 343 m/s from the listener; distance filtering.

### M21-T3 · Matter-wave tuning audio (DRAFT — needs M10-T6)
Tone whose pitch and loudness follow `DamageApi` band proximity while tuning.

### M21-T4 · Radio chatter (DRAFT — needs M20)
Faction chatter as ambience; after Radio Communications, lines that hint at nearby random events.
