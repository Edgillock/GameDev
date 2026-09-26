# Build specs

One file per module. Each file is split into **tasks** small enough for one Claude session.

## How to run a task

Open Claude Code in `Y:\GameDev\game-dev` and say, for example:

> Implement task **M02-T1** from `docs/specs/M02-blueprint.md`.

Claude reads `CLAUDE.md`, the glossary, that task and the module's rules, builds it on a branch `task/M02-T1-…`, runs the tests and the boundary check, and tells you how to see the result. You review, try the demo scene, and merge.

Rules of thumb:

- Run tasks **in the order below**. A task lists what it needs; don't start it before those are merged.
- One task per session. Start a fresh session for the next task.
- If Claude logs an open question (OQ-xx) or change request (CR-xx), answer it in `docs/open-questions.md` before the task that depends on it.

## Task status words

| Word | Meaning |
|---|---|
| READY | Design is settled; build it. |
| DRAFT | Open questions remain; answer them first, then ask Claude to turn the task into READY. |
| NEEDS Mxx-Tn | Can't start until that task is merged. |

## Order of work

### Milestone 0 — Skeleton
M00-T1 → M00-T2 → M00-T3 → M00-T4 → M01-T1 → M01-T2 → M01-T3 → M01-T4

### Milestone 1 — Box on wheels
M02-T1 → M02-T2 → M02-T3 → M03-T1 → M03-T2 → M04-T1 → M04-T2 → M05-T1 → M05-T2 → M06-T1 → M06-T2 → M07-T1 → M07-T2 → M07-T3 → M07-T4

### Milestone 2 — Power
M08-T1 → M08-T2 → M08-T3 → M08-T5 → M07-T5

### Milestone 3 — First shot
M04-T3 → M09-T1 → M09-T2 → M09-T3 → M10-T1 → M10-T2 → M10-T3 → M10-T4 → **M10-T5 (Activation Groups)** → M06-T3 → M07-T6 → M19-T1

### Milestone 4 — Seen and unseen
M11-T1 → M11-T2 → M12-T1 → M12-T2 → M14-T1 → M14-T2 → M14-T3 → M06-T4 → M14-T4 → M14-T5

### Milestone 5 — Vertical slice
M13-T1 → M13-T2 → M13-T3 → M08-T4 → M05-T3 → M15-T1 → M15-T2 → M19-T2 → M19-T3 → M21-T1 → M21-T2 → M22-T1

### After the vertical slice
M09-T4 … T7, M10-T6, M11-T3, M12-T3 … T5, M07-T7, M13-T4, M14-T6, M16, M17, M18, M19-T4, M20, M21-T3/T4, M22-T2. Many of these are DRAFT: answer their open questions first.

## Module index

| ID | Module | Spec | Status |
|---|---|---|---|
| M00 | Foundation | M00-foundation.md | READY |
| M01 | Core | M01-core.md | READY |
| M02 | Blueprint | M02-blueprint.md | READY |
| M03 | Structure | M03-structure.md | READY |
| M04 | Vehicle Runtime | M04-vehicle.md | READY |
| M05 | Mobility | M05-mobility.md | READY |
| M06 | Controls | M06-controls.md | READY |
| M07 | Builder | M07-builder.md | READY (T7 DRAFT) |
| M08 | Power | M08-power.md | READY |
| M09 | Damage | M09-damage.md | READY |
| M10 | Weapons | M10-weapons.md | READY (T6 DRAFT) |
| M11 | Detection | M11-detection.md | READY |
| M12 | Crew | M12-crew.md | READY (T5 DRAFT) |
| M13 | World | M13-world.md | READY (T4 DRAFT) |
| M14 | AI Vehicles | M14-ai.md | READY (T6 DRAFT) |
| M15 | Save/Load | M15-save.md | READY |
| M16 | Progression | M16-progression.md | DRAFT |
| M17 | Economy & Home Base | M17-economy.md | DRAFT |
| M18 | Logistics | M18-logistics.md | DRAFT |
| M19 | HUD & Menus | M19-hud.md | READY (T4 DRAFT) |
| M20 | Story & Quests | M20-story.md | DRAFT |
| M21 | Audio | M21-audio.md | READY (T3–T4 DRAFT) |
| M22 | Blueprint Sharing | M22-sharing.md | READY (T2 DRAFT) |

## Spec template (for new or revised specs)

```
# Mxx · Name
Status · Folder · Uses · Design pages

## Purpose
## Public API sketch
## Data
## Tasks
### Mxx-Tn · Title  (READY | DRAFT | NEEDS …)
Goal · Build · Done when · Tests
## Out of scope
```
