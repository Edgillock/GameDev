# 40 · Technical requirements

## Stack (decisions G14, G15)

- **Godot 4.7**, Forward+ renderer, Direct3D 12 on Windows (as set in `project.godot`).
- **GDScript with static typing.** Measured hot spots (damage rays, detection) may move to C++ (GDExtension) later, only if profiling shows the need.
- **Jolt physics** (already selected in the project).
- **Windows first**; Linux and Steam Deck later.

## Engineering rules

- **All gameplay numbers in data:** parts, materials, ammo, weather, crew curves are Resource files (`.tres`). No gameplay numbers in scripts.
- **Game rules separate from visuals:** rules in plain typed classes that tests run without a scene.
- **Automated tests:** gdUnit4, runnable from the command line.
- **Versioned save and blueprint formats:** every file carries a format version; old versions are migrated on load.
- Module boundaries enforced by `tools/check_boundaries` (see `CLAUDE.md`).

## Single-player, multiplayer-ready (decision C02)

- No multiplayer code in v1.
- The simulation receives **Orders** as data and never reads input directly. Only the controls module reads input.
- Randomness goes through a seedable `Rng` service.

## Physics budget (decision C24)

- Physics simulates each vehicle's rigid body, its suspension casts, projectiles and debris.
- Tracks, chains and linkages are animated, not simulated.
- A frame-rate budget was not set (OQ-11). Profile before optimizing.

## Detection rays

Rays are scheduled in a per-frame budget and spread across frames; ports on distant or off-screen vehicles may update less often. The rule's outcome must not change with frame rate.

## Blueprint sharing (decision G18)

- Blueprints are exported and imported as files (for sharing on Discord, forums…).
- Certification Trials run locally and stamp Rated Stats into the file.
- Same blueprint format for player vehicles, AI blueprint pools and shared files.
- Which trials exist and how stats are computed: OQ-08.
