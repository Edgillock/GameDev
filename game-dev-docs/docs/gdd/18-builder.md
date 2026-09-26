# 18 · Builder

## Basic tools

- **Selection:** Ctrl + left click to multi-select; a resizable, movable box selection area that selects everything inside it.
- **Copy, paste, undo, redo.**
- **Module presets:** save a selection as a preset module; place presets later.
- **Mirror:** place 1–2 mirror planes; edits on one side are mirrored to the other.
- **Decals and paint:** a paint-style editor for 2D appearance elements, saved for reuse. Flagged as risky in the original notes; scope: OQ-09.
- **Blueprint save/load:** saves everything in the current work area.

## Resizing boxes (armor blocks, struts, tanks, ammo racks)

Modeled on the Minecraft mod *Axiom*:

- In resize mode, click a face, then scroll or drag to move that face along its normal; other faces stay put.
- Click a vertex to change several dimensions at once.
- Sizes snap to the Weight Class grid step; min/max edge length and volume are limited by progress.
- Chamfer tool: square, round or asymmetric square, size limited by edge lengths; visual only.

## Material Printer tools (after the Material Printer is unlocked)

- Adjust a block's **infill**. Material cost follows infill × volume.
- Change a block's **surface texture**; no other stat changes.

## Placing weapons

- Place weapon bodies and Ammo Racks independently.
- Bind racks: select a weapon, then click up to 2 racks; click order = order of use.
- **Assign Activation Groups:** the weapon's properties panel shows 9 group toggles; a group panel lists members and lets you rename and recolor groups. See 14-weapons.

## Placing power parts

See the building rules in 12-power: Drive Range preview, conduit and fuel-line routing, power budget panel, validation badges, energy-type colors, power priority groups.

## Validation before deploying

The builder refuses to deploy, and says why, when:

- there is no Command Module, or more than one;
- the vehicle exceeds its Weight Class caps (bounding box, mass, part count);
- a part is not connected to the Command Module's structure;
- any power validation badge is red (warning only for "weapon unpowered").

## Manufacturing

- When a blueprint is final and production starts, every part is first manufactured and then assembled at the **Home Base** (decision C06). Only the Home Base builds new player vehicles.
- Build speed depends on the Home Base's sector upgrades (see 21-economy).
- Creative Mode: instant.
- Possible later feature: separate design and construction interfaces — design in a minimalist blueprint/wireframe look without lighting; construction shown with simple procedural animations (production line, parts assembling). OQ-10.

## Appearance unlocks

- Paints and text decals unlock from early to mid game, alongside the concealment mechanic.
- Paints have Concealment per biome/weather; paints, attachments and ornaments have Recon Masking (see 15-detection).
- Ornaments and attachments unlock by completing tasks, exploring POIs and salvaging certain wrecks.
