# M00 · Foundation

- **Status:** READY
- **Folders:** `tools/`, `addons/`, `game/scenes/`, `game/modules/*/` (empty skeleton only), `project.godot`, `.gitignore`
- **Uses:** —
- **Design:** `docs/gdd/40-tech.md`, `CLAUDE.md`

## Purpose

Set up everything every later task relies on: folder skeleton, strict GDScript settings, the test runner, the boundary checker and a boot scene. After M00 no task should need to touch project settings.

The project already exists: Godot 4.7, Forward+, Jolt Physics, D3D12 on Windows, git with a remote. Keep those settings.

## Tasks

### M00-T1 · Folder skeleton and project settings (READY)

**Build**

1. For every module in `tools/module_graph.cfg`, create its folder with empty `public/`, `internal/`, `data/`, `scenes/`, `tests/` subfolders (a `.gdkeep` file in each so git keeps them). Module `CLAUDE.md` files already exist; don't change them.
2. Create `game/autoload/` (empty for now; M01 fills it).
3. In `project.godot`, set GDScript warnings so untyped code fails:
   - `debug/gdscript/warnings/untyped_declaration` = Error
   - `debug/gdscript/warnings/inferred_declaration` = Ignore (`:=` is allowed)
   - `debug/gdscript/warnings/unsafe_*` = Warn
   - Keep Jolt as the 3D physics engine; set `physics/common/physics_ticks_per_second` = 60.
4. Ask the owner for the path to their Godot 4.7 executable. Store it in `tools/local.cfg` (`[godot] path="…"`), and add `tools/local.cfg` to `.gitignore`. Also write `tools/local.cfg.example`.
5. Add `docs/`, `CLAUDE.md` and the module folders to git in the first commit of this task if they aren't committed yet.

**Done when**
- All module folders exist with their five subfolders.
- Opening the project headless (`godot --headless --editor --quit`) prints no errors.
- An untyped `var x = 1` in a throwaway script produces an error (then delete the script).

### M00-T2 · Test runner (READY)

**Build**

1. Install **gdUnit4** into `addons/gdUnit4/` (latest release that supports Godot 4.7; record the version in `docs/decisions/0002-tooling.md`) and enable the plugin.
2. `tools/run_tests.sh` (Git Bash, used by Claude) and `tools/run_tests.cmd` (double-click for the owner): read the Godot path from `tools/local.cfg`, run gdUnit4's command-line runner headless over `res://game`, exit non-zero on any failure, print a short summary.
3. One sample test in `game/core/tests/test_sanity.gd` that asserts `1 + 1 == 2`.

**Done when**
- `tools/run_tests.sh` passes with the sample test, and fails if the sample assertion is changed to fail (then revert).

### M00-T3 · Boundary checker (READY)

**Build** `tools/check_boundaries.gd`, a GDScript run with `godot --headless --script`, plus `.sh` and `.cmd` wrappers.

It must:

1. Load `tools/module_graph.cfg`. Fail if the graph has a cycle, if a `uses` entry names an unknown module, or if a non-presentation module uses a `presentation` module.
2. Build a map of every `class_name` in `game/` → the file and module that defines it, and whether that file is public (`<key>_api.gd`, anything under `public/`, or anything under `game/core/`).
3. Scan every `.gd`, `.tscn`, `.tres` and `.gdshader` file under `game/`. For each file, find its owning module by path. Flag:
   - any `res://game/modules/<other>/…` path where `<other>` is not in the owner's `uses`;
   - any path into another module that is not its `<key>_api.gd` or `public/`;
   - any identifier token matching a `class_name` from a module the owner may not use, or from another module's non-public files;
   - any `Input.` usage outside the `controls` module;
   - any reference from `game/core/` to `game/modules/`.
   `game/scenes/` (app) may reference any module's API and public types, never `internal/`.
4. Print each violation as `file:line: rule — detail`, and exit non-zero if there are any.

**Tests:** fixture folders under `tools/tests/fixtures/` with one allowed and one forbidden reference per rule; a small runner script proves each rule fires.

**Done when**
- The checker passes on the current repository and fails on each fixture violation.

### M00-T4 · Boot scene and test ground (READY)

**Build**

1. `game/scenes/boot.tscn` + script: the main scene. For now it loads `test_ground.tscn`.
2. `game/scenes/test_ground.tscn`: a flat 1 km × 1 km static ground (hard Ground Type is added later by M13), a directional light, a WorldEnvironment with a sky, and a camera looking at the origin.
3. Set `boot.tscn` as the project's main scene.

**Done when**
- Pressing Play shows the lit ground with no errors.

## Out of scope

Any game rule. Any core type (that is M01).
