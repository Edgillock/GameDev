# M22 · Blueprint Sharing

- **Status:** READY (T2 DRAFT — needs OQ-08)
- **Folder:** `game/modules/sharing/`
- **Uses:** core, blueprint
- **Design:** `docs/gdd/40-tech.md`

## Tasks

### M22-T1 · Blueprint export and import (READY)
Export a blueprint as a single shareable file (the M02 format plus a small header: game version, author, Rated Stats if present, thumbnail PNG embedded as base64). Import into `user://blueprints/` with validation; missing parts listed, never silently dropped. Gate: Holo-Terminal unlocked (Creative Mode: always).

### M22-T2 · Certification Trials (DRAFT — OQ-08)
A set of local benchmark runs (e.g. speed, climb, firing range, armor test) whose scores become Rated Stats stamped into the file, and an automatic role category from those stats.
