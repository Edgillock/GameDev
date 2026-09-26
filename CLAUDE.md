# CLAUDE.md — rules for every session in this repository

This repository is a single-player vehicle design, combat and tactics game built with **Godot 4.7**, **GDScript (statically typed)** and **Jolt physics**. The owner is new to game development and works with Claude one module at a time. These rules exist so that each session builds one piece well without damaging the rest.

When a rule here conflicts with a spec, this file wins. When the owner tells you something different in the conversation, the owner wins.

---

## 1. Before writing any code

Read, in this order, and nothing else unless a spec links it:

1. This file.
2. `docs/gdd/01-glossary.md` — the only allowed names for game concepts, in text and in code.
3. The spec task you were given: `docs/specs/Mxx-<name>.md`, section `Mxx-Tn`. If the owner did not name a task, ask which one. Never pick one yourself.
4. The module's own `CLAUDE.md` (`game/core/CLAUDE.md` or `game/modules/<name>/CLAUDE.md`).
5. The public API (`<name>_api.gd` and `public/`) of every module listed under **Uses** in that module's `CLAUDE.md`.
6. The design pages (`docs/gdd/…`) the spec links to.

Do **not** read other specs, other modules' `internal/` folders, or old design drafts. If you feel you need them, that is a sign the task needs a change request (section 4).

## 2. Scope lock — the most important rule

- **One spec task per session.** Do exactly that task. Do not start the next task, even if it looks small.
- **Edit only your module's folder** (`game/modules/<name>/`, or the folders the M00/M01 specs list), plus append-only edits to `docs/open-questions.md`.
- **Never edit** another module's files, `tools/module_graph.cfg`, `project.godot`, the autoload list, the input map, or anything in `docs/gdd/` or `docs/specs/` — unless your spec task explicitly says so.
- **Never refactor, rename, reformat or "clean up"** code outside your task, even if it looks wrong. Log it as an open question instead.
- **Spec marked `Status: DRAFT`?** Don't build it. Tell the owner which open questions must be answered first.
- **Unsure whether something is in scope?** It isn't. Ask.

## 3. Architecture

```
game-dev/
├─ CLAUDE.md                 this file
├─ addons/gdUnit4/           test framework (installed by M00)
├─ docs/
│  ├─ gdd/                   game design, split by topic (read-only for Claude)
│  ├─ specs/                 build instructions, one file per module (read-only for Claude)
│  ├─ decisions/             decision log
│  └─ open-questions.md      append-only parking lot for anything unclear
├─ game/
│  ├─ core/                  M01 — shared types every module may use
│  ├─ modules/<name>/        one folder per module (see below)
│  ├─ autoload/              M01 — the Services autoload
│  └─ scenes/                M00 — boot scene and top-level composition only
└─ tools/
   ├─ module_graph.cfg       which module may use which (owner-controlled)
   ├─ run_tests.sh / .cmd    runs every test
   └─ check_boundaries.sh / .cmd   fails on forbidden cross-module references
```

### 3.1 Module folder layout

```
game/modules/<name>/
├─ CLAUDE.md          purpose, owns, uses, must-not-touch, status
├─ <name>_api.gd      class_name <Name>Api — the ONLY entry point other modules call
├─ public/            data types other modules may use (Resources, enums, value classes)
├─ internal/          everything else; invisible to other modules
├─ data/              .tres files (all gameplay numbers live here)
├─ scenes/            demo_<name>.tscn and module-private scenes
└─ tests/             gdUnit4 tests
```

### 3.2 Dependency rules

- A module may reference **only** `game/core/` and the `<name>_api.gd` + `public/` of modules listed as `uses` for it in `tools/module_graph.cfg`. `tools/check_boundaries` enforces this.
- The graph has no cycles. **Presentation modules** (`controls`, `builder`, `hud`, `audio`) may use anything they list; no other module may use them. Game rules never depend on UI.
- **Need something from a module you may not use?** Use dependency inversion: the interface lives in `game/core/` (M01), the higher module implements it and registers it in `Services`, the lower module calls the interface. Adding such an interface to core is a change request, not something you do in passing.
- **Per-vehicle systems** (mobility, power, damage, weapons, detection, crew) extend `core.VehicleSystem` and register a factory with `Services`. The vehicle runtime (M04) attaches every registered system when it spawns a vehicle, without knowing which modules exist.
- **Module signals live on an events object**, because API functions are static and GDScript has no static signals (see `docs/decisions/0002-repo-setup.md`). A module with signals declares them in `public/<name>_events.gd` (`class_name <Name>Events extends RefCounted`) and exposes it through its API:

  ```gdscript
  static func events() -> PowerEvents:
      return Services.get_or_create(&"power.events", PowerEvents.new) as PowerEvents
  ```

  Others connect with `PowerApi.events().power_changed.connect(...)`. Only the owning module emits its events. Signals on instances (a `Vehicle`, `GameClock`) stay on those instances. There is no global event bus.
- **Orders are data.** Input, AI and any future network layer all produce `core.Order` objects and submit them through `VehicleApi.submit_order()` or the AI squad API. Only the `controls` module reads `Input`.

### 3.3 Game rules vs. visuals

- Game rules live in plain typed classes (`RefCounted`/`Resource`) that tests can run without a scene tree.
- Nodes are thin: they read state, display it, and forward input or physics callbacks.
- Simulation runs in `_physics_process`. No gameplay logic in `_process`.
- Randomness only through the core `Rng` service (seedable), never `randf()` directly.

## 4. When something is missing or unclear

- **Never invent game design.** If the spec or design says TBD, add a clearly named placeholder value in the module's `data/` with the comment `# TBD OQ-xx`, and continue.
- **Something another module should provide?** Append a change request to `docs/open-questions.md`:

```
### CR-<next number> — <short title>
- From: Mxx-Tn (<module>)
- Needs: <what, from which module or core>
- Why: <one or two sentences>
- Workaround used: <none | what you did locally>
```

- **Design unclear?** Append an open question in the same file using the `OQ-<next number>` format already there, then ask the owner in plain words.

## 5. Coding rules (GDScript)

- **Static typing everywhere**: typed variables, parameters, return types, typed arrays (`Array[PartDef]`). The project treats untyped declarations as errors.
- Names: files and folders `snake_case`; `class_name` in `PascalCase`; constants and enum values `UPPER_SNAKE`; signals in the past tense (`part_destroyed`); private members start with `_`.
- **Use glossary names exactly.** If the glossary gives a code name, use it verbatim.
- **No gameplay numbers in code.** Speeds, damage, costs, thresholds, ranges: all in `.tres` data. Pure technical constants (e.g. a physics epsilon) may be named `const` values.
- Every public function in `<name>_api.gd` and `public/` has a `##` doc comment stating what it does, units, and edge cases.
- Units: meters, kilograms, seconds, newtons, watts, degrees Celsius, degrees for angles in data (radians internally). Name fields with units when ambiguous (`dispersion_deg`, `loss_per_m`).
- Keep files small: one class per file, roughly under 300 lines. Split before it grows.
- Comments explain *why*, not *what*.

## 6. Tests

- Framework: gdUnit4. Tests live in `game/modules/<name>/tests/` (core: `game/core/tests/`).
- Every rule you implement gets a test. Every bug you fix gets a test that failed before the fix.
- Run the **whole** suite before finishing: `tools/run_tests.sh` (or `.cmd`).
- **Never delete, skip or weaken an existing test** to make it pass. If another module's test fails after your change, your change broke a contract: fix your change.
- Each module has `scenes/demo_<name>.tscn`, a small scene the owner can open and press Play to see the module working.

## 7. Git

- Work on a branch per task: `task/Mxx-Tn-short-name`, created from `main`.
- Commit in small steps with messages like `M08-T2: add power flow solver`.
- Never merge into `main` or push to it. The owner reviews and merges.
- **Local sessions** (Claude Code on the owner's PC): do not push unless the owner asks.
- **Cloud sessions** (claude.ai/code): the machine is discarded when the session ends, so push the task branch to `origin` when the task is done. Godot is not preinstalled there: download the Linux build of the same version (4.7.2) and use it for the tests and checks in section 8.

## 8. Finishing a task — checklist

1. Full test suite passes.
2. `tools/check_boundaries` passes.
3. Godot opens the project headless without script errors: `godot --headless --editor --quit`.
4. The module's `CLAUDE.md` **Status** section is updated (which tasks are done, what's next).
5. Work is committed on the task branch (and pushed, in a cloud session).
6. Tell the owner, in plain words:
   - what now works;
   - how to see it (which demo scene to open, which keys to press);
   - any placeholders (`TBD OQ-xx`) or change requests you logged.
