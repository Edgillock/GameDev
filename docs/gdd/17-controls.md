# 17 · Controls

## Principles

- **The Flagship is always under the player's full control** (decision C15).
- **AI vehicles are commanded in Squads**, Command & Conquer style: select them, then order them to move somewhere or fire at a target. The player never drives an AI vehicle directly.
- Every control goes through Godot **Input Map actions**; nothing is hard-coded to a key. Gamepad support can be added by binding actions.
- Input becomes **Orders** (data). Only the controls module reads input.

> Defaults on this page for driving and the RTS layer come from the recommended options, because the controls card was left unanswered. Confirm or change them.

## Views

| View | Camera | Number keys 1–9 | Toggle |
|---|---|---|---|
| **Drive view** | Third-person orbit around the Flagship; first-person Direct Control on request | **Activation Groups** of the Flagship | Tab |
| **Command view** | Tactical top-down camera | **Squads** | Tab |

The number keys change meaning by view so weapon groups and squads don't collide. *(Assumption, OQ-14.)* A free camera is available from the start.

## Driving the Flagship (Drive view)

| Action | Default |
|---|---|
| Throttle forward / reverse | W / S |
| Steer | A / D |
| Brake | Space |
| Fine throttle | hold Shift |
| Aim | Mouse |
| Fire active Activation Groups | Left mouse |
| Call Activation Group n | 1–9 |
| Add/remove group n to the active set | Shift + 1–9 |
| Target Lock on target under cursor | Right mouse |
| First-person Direct Control on/off | F |
| Time Acceleration | configurable |

## Activation Groups

Full rules in 14-weapons. In short: every weapon can be assigned to one or more of 9 groups; pressing a group's key makes all its weapons respond to commands together (aim, fire as Salvo or Ripple, hold fire / fire at will, Target Lock, Power Mode, ammo switch). The HUD shows a group bar with each member's state.

## Commanding AI vehicles (Command view)

Requirements (from the original design): each AI vehicle needs a **Brain-in-a-Vat**. Before **Radio Communications**, Brain-in-a-Vat vehicles act on their own and follow the Flagship. After it, they accept orders.

| Action | Default |
|---|---|
| Select a vehicle | Left click |
| Box-select | Left drag |
| Assign selection to Squad n | Ctrl + 1–9 |
| Select Squad n | 1–9 (double-tap: center camera) |
| Move | Right click on ground |
| Attack target | Right click on an enemy |
| Attack-move (engage anything on the way) | A + left click |
| Queue waypoints | Shift + right click |
| Stop | S |
| Stance wheel: hold fire / return fire / free fire / retreat | hold Q |

The number of AI vehicles the player can field is tightly limited (one Brain-in-a-Vat each; caps by progress: OQ-15).

## Brain-Computer Interface

The original notes said the BCI lets the player "override running components" and removes "mandatory delays" on orders. With AI vehicles now commanded only through Squads, what the BCI does is open: OQ-04. It still links with the Holo-Terminal to show live vehicle status (loading state, part damage).

## Not included

No tactical pause (not selected). No direct control of AI vehicles.
