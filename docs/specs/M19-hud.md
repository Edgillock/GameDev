# M19 · HUD & Menus

- **Status:** READY (T4 DRAFT)
- **Folder:** `game/modules/hud/`
- **Uses:** core, vehicle, power, weapons, detection, crew, world, ai, economy, progression, logistics (read-only use of their APIs)
- **Design:** `docs/gdd/14-weapons.md`, `docs/gdd/17-controls.md`, `docs/gdd/30-art-audio.md`
- **Kind:** presentation

## Purpose

Every in-game screen. The HUD only **reads** module APIs and **submits Orders**; it never changes game state directly. Style: the robot's vision overlay (placeholder theme first).

## Tasks

### M19-T1 · Activation Group bar (NEEDS M10-T5, M06-T3)

**Build**
- A bar showing groups 1–9 that have members: number, name, color; active groups highlighted.
- For each group: standing order (Hold fire / Fire at will), fire pattern (Salvo / Ripple), Power Mode, locked target — each clickable, sending a `WeaponGroupOrder` to the Flagship.
- Expanding a group shows its members with their `MemberState` (ready, reloading with progress, out of arc, no power, no ammo, no crew, destroyed) and ammo count.
- A **Weapon Groups panel** (toggle key from the input map) to add/remove weapons from groups in the field (`ASSIGN`/`UNASSIGN` orders) and a "Save to blueprint" button (through `WeaponsApi`).
- Data comes from `WeaponsApi.group_status()` each frame (cheap) or on `active_groups_changed`.

**Done when** (Milestone 3) the owner can see which groups are active, what each member is doing, and change group settings with the mouse.

### M19-T2 · Driving HUD (READY)
Speed, throttle, power budget summary (`PowerApi.runtime_report`), vehicle damage silhouette (part HP), detected contacts as markers, crosshair with each active group's predicted impact point, Time Acceleration indicator.

### M19-T3 · Menus and pause (READY)
Main menu, pause menu, save/load slots (`SaveApi`), settings (key rebinding through the input map, volume, graphics).

### M19-T4 · Minimap and weather (DRAFT)
Unlocked by the Satellite Uplink: faint outlines of unexplored areas, icons, live weather. Needs the map layout.
