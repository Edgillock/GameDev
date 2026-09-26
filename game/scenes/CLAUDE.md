# game/scenes — composition root (owned by M00)

This folder holds the boot scene, test grounds and the top-level scenes that put modules together (world + Flagship + HUD). It is the only place allowed to reference every module's API (`uses=["*"]` in `tools/module_graph.cfg`).

## Rules

- Scenes here only **wire modules together**: instance module scenes, pass API references, connect signals. No game rules here.
- Edit this folder only in M00 tasks, or in a task whose spec says "wire into `game/scenes/...`".
- Keep one scene per purpose: `boot.tscn`, `test_ground.tscn`, `main.tscn`.
