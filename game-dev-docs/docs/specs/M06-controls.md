# M06 · Controls

- **Status:** READY
- **Folder:** `game/modules/controls/`
- **Uses:** core, vehicle, ai
- **Design:** `docs/gdd/17-controls.md`, `docs/gdd/14-weapons.md` (Activation Groups)
- **Kind:** presentation — the **only** module allowed to read `Input`.

## Purpose

Cameras, and turning player input into Orders. The Flagship receives orders through `VehicleApi.submit_order()`; Squads receive orders through `AiApi` (M14).

## Input actions

Define every action in the project Input Map (this module's tasks may edit the input map). Names are `snake_case` with a context prefix, e.g. `drive_throttle_up`, `drive_steer_left`, `drive_brake`, `drive_fine`, `drive_fire`, `drive_lock_target`, `drive_first_person`, `weapon_group_1` … `weapon_group_9`, `weapon_group_modifier_add` (Shift), `view_toggle` (Tab), `cmd_select`, `cmd_order`, `cmd_assign_modifier` (Ctrl), `squad_1` … `squad_9`, `cmd_attack_move`, `cmd_stop`, `cmd_stance_wheel`, `time_accel_up`, `time_accel_down`, `camera_free`. Default keys as in 17-controls. Never check raw keycodes.

## Tasks

### M06-T1 · Input actions and Flagship driving (READY)

**Build**
- Create the actions above (all of them now, so later tasks don't touch the input map again).
- `FlagshipController` node: holds a reference to the Flagship `Vehicle`. Each physics tick builds one `DriveOrder` from the drive actions (throttle, steer, brake, fine throttle scales throttle by a data factor) and submits it.
- Wire into `game/scenes/test_ground.tscn`: spawn a fixture Flagship and attach the controller (this task may edit that scene).

**Done when** the owner can press Play and drive the fixture vehicle with W/A/S/D/Space.

**Tests:** given a fake input state, the controller produces the expected `DriveOrder`.

### M06-T2 · Cameras: orbit, first person, free (READY)

**Build**
- Drive camera: orbit around the Flagship (mouse to orbit, wheel to zoom, smoothing), collision so it doesn't clip into terrain.
- First-person toggle (`drive_first_person`): camera at the Command Module (or an Observation Port later) facing forward.
- Free camera (`camera_free`): fly with WASD + mouse; available from the start.
- Camera data (distances, speeds, smoothing) in `data/`.

**Done when** the owner can switch between the three cameras while driving.

### M06-T3 · Activation Group input (NEEDS M10-T5)

**Build** — in the Drive view:
- `weapon_group_n` → `WeaponGroupOrder(SELECT, [n])`.
- Shift + `weapon_group_n` → `ADD_TO_ACTIVE` if n is not active, else `REMOVE_FROM_ACTIVE`.
- Mouse aim → `AimOrder(point)` every physics tick while any group is active (ray from the camera through the cursor to the world).
- `drive_fire` pressed / released → `FIRE_START` / `FIRE_STOP` for the active set.
- `drive_lock_target` on an enemy → `LOCK_TARGET` with a `TargetRef`; on empty ground → `RELEASE_TARGET`.
- Group commands without dedicated keys (hold fire / fire at will, Power Mode, ammo, fire pattern) are sent from the HUD group bar (M19-T1), not from here.

**Tests:** fake input sequences produce the right orders (select, add, remove, fire start/stop, lock).

### M06-T4 · Command view and Squad input (NEEDS M14-T3)

**Build**
- `view_toggle` switches between Drive view and Command view. In Command view: a tactical top-down camera (pan with WASD/edge scroll, zoom, rotate), the Flagship keeps its last `DriveOrder` cleared to idle.
- Selection: click and box-select allied AI vehicles (visual selection rings).
- Squads: Ctrl + `squad_n` assigns the selection to Squad n; `squad_n` selects it (double-tap centers the camera).
- Orders to the selection via `AiApi`: right-click ground → move; right-click enemy → attack; `cmd_attack_move` + click → attack-move; Shift + right-click → queue waypoint; `cmd_stop`; hold `cmd_stance_wheel` → radial menu for hold fire / return fire / free fire / retreat.
- In Command view the number keys mean Squads; in Drive view they mean Activation Groups (OQ-14 assumption).

**Tests:** selection logic (click, box, add with Shift); number-key meaning follows the view.

## Out of scope

What orders do (M05, M10, M14). HUD widgets (M19).
