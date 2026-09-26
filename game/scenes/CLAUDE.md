# game/scenes — composition root (owned by M00)

This folder holds the boot scene, test grounds and the top-level scenes that put modules together (world + Flagship + HUD). It is the only place allowed to reference every module's API (`uses=["*"]` in `tools/module_graph.cfg`).

## Rules

- Scenes here only **wire modules together**: instance module scenes, pass API references, connect signals. No game rules here.
- Edit this folder only in M00 tasks, or in a task whose spec says "wire into `game/scenes/...`".
- Keep one scene per purpose: `boot.tscn`, `test_ground.tscn`, `main.tscn`.

## Status (M00 · Foundation)

Update this list at the end of every M00 task (check the box, add one line on what's next).

- [x] M00-T1 Folder skeleton and project settings
- [ ] M00-T2 Test runner
- [ ] M00-T3 Boundary checker
- [ ] M00-T4 Boot scene and test ground

Next: M00-T2 installs gdUnit4 and the test runner scripts. `tools/local.cfg` (git-ignored) holds the Godot path; copy it from `tools/local.cfg.example`.
