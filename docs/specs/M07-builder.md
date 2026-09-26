# M07 · Builder

- **Status:** READY (T7 DRAFT)
- **Folder:** `game/modules/builder/`
- **Uses:** core, blueprint, structure, vehicle, controls, power, weapons, detection
- **Design:** `docs/gdd/18-builder.md`, `docs/gdd/10-vehicle-structure.md`, `docs/gdd/12-power.md`, `docs/gdd/14-weapons.md`
- **Kind:** presentation

## Purpose

The build mode: a scene where the player designs a blueprint. Every edit goes through `BlueprintApi` helpers as a **command object** so undo/redo is exact. The builder never changes game rules; it shows the reports other modules produce.

## Architecture

- `BuilderSession`: holds the current `Blueprint`, the undo stack, the selection, the active tool.
- `EditCommand` (internal): `do()`, `undo()`, `description`. Every change is one command (or a `CompositeCommand`).
- Tools are small classes (`PlaceTool`, `ResizeTool`, `SelectTool`, `ChamferTool`, `ConduitTool`, `GroupTool`…); one is active at a time.
- Visuals redraw from the blueprint after each command (simple and correct first; optimize later).
- Look: blueprint/wireframe style, no lighting (30-art-audio) — a simple unshaded grid and outlined boxes is enough for now.

## Tasks

### M07-T1 · Builder scene, grid and part placement (READY)

**Build**
- `scenes/builder.tscn`: orbit camera around the work area, a ground grid at the blueprint's grid step, a part palette listing every `PartDef` from the Registry that is unlocked, grouped by kind.
- Place: ghost preview snapped to the grid; faces of existing parts snap the ghost against them; R rotates functional parts through the six facings; left click places (rejected with a red ghost if it would overlap); right click / Delete removes.
- Show the quick validation report (M02-T3) in a side panel, live.

**Done when** the owner can place a Command Module, blocks and running gear and see the validation panel update.

### M07-T2 · Resize and chamfer (READY)

**Build**
- Resize mode (Axiom-style): hover highlights a face; click-drag or scroll moves that face along its normal in grid steps; the opposite face stays put. Clicking a vertex drags three faces at once. Limits from the def's min/max size; overlaps rejected.
- Chamfer tool: pick an edge, choose square/round/asymmetric, size limited by edge lengths; stored in the part's `chamfers`; drawn visually only.

**Tests:** resize commands undo exactly; limits enforced.

### M07-T3 · Selection, copy/paste, undo/redo, mirror, presets (READY)

**Build**
- Ctrl + click multi-select; a box selection volume (resizable and movable like a part) selects everything inside.
- Copy / paste (paste as a ghost group, placed like a part), delete selection.
- Undo / redo (Ctrl+Z / Ctrl+Y) over every command.
- Mirror: up to 2 mirror planes through the grid; commands on one side create mirrored commands on the other side (facing mirrored too). Parts on the plane are not duplicated.
- Presets: save the selection as a preset file (`user://presets/`, blueprint-fragment format from M02), place presets from the palette.

**Tests:** mirror of an asymmetric placement; undo of a mirrored paste restores exactly.

### M07-T4 · Save, load, validate and test drive (READY)

**Build**
- Save / load blueprints (M02) with a simple file list UI.
- Full validation panel: blueprint report + connectivity report (M03) + reports from other modules as they appear; clicking an issue selects its parts.
- "Test drive": if there are no ERRORs, switch to the test ground and spawn the blueprint as the Flagship (wire through `game/scenes/` — this task may edit `test_ground.tscn`/`boot.gd` for the scene switch only). A key returns to the builder with the blueprint intact.

**Done when** the owner can build a box on wheels, test-drive it and come back to edit it. (Milestone 1.)

### M07-T5 · Power tools (NEEDS M08-T2)

**Build** the power building rules from 12-power:
- Drive Range preview when placing or selecting a Power Plant or Relay; running gear inside lights up.
- Conduit and Fuel Line tool: click source, click target; auto-route through free grid cells (A* on the grid), stored as a path in the part's props (`"power.path"`); drag waypoints; length and loss shown live.
- Power budget panel and validation badges from `PowerApi.analyze_blueprint()`.
- Power view layer: color parts and conduits by energy type (thermal orange, electric cyan, exotic green).
- Power priority groups UI writing blueprint props through `PowerApi` helpers.

### M07-T6 · Weapon placement, Ammo Rack binding and Activation Group assignment (NEEDS M10-T5)

**Build**
- Place weapons (facing + traverse arc preview) and Ammo Racks (resizable).
- Bind racks: select a weapon, click up to 2 racks; the click order is the order of use; lines show bindings. Stored through `WeaponsApi` helpers (not by writing props directly).
- **Activation Group assignment:** the weapon properties panel shows 9 toggles (groups 1–9). A group panel lists each group's members, name and color; rename and recolor there. Selecting several weapons and toggling a group applies to all of them (one undoable command). All stored through `WeaponsApi` helpers into the blueprint.
- Validation from `WeaponsApi.validate_blueprint()` (unbound weapons, racks bound to nothing, etc.).

**Tests:** assigning a multi-selection to a group is one undo step; group names survive save/load.

### M07-T7 · Paint and appearance (DRAFT — needs OQ-09)

Assign paints (Concealment / Recon Masking from M11) to parts. The decal editor is out of scope until OQ-09 is answered.

## Out of scope

Game rules. Manufacturing and costs (M17). The separate design/construction interfaces (OQ-10).
