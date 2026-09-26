# 0002 · Repository setup — September 2026

Decisions made by the owner before the first build task (2026-09-26).

| ID | Topic | Decision |
|---|---|---|
| R01 | Folder layout | `CLAUDE.md`, `docs/`, `game/` and `tools/` sit at the project root, next to `project.godot`, as every path in the specs assumes. They were first committed under `game-dev-docs/`. |
| R02 | Cloud sessions | Claude sessions on claude.ai/code push their `task/Mxx-Tn-…` branch when the task is done, because the cloud machine is discarded afterwards. Local sessions still push only when asked. Nobody but the owner merges into `main`. See `CLAUDE.md` §7. |
| R03 | Line endings | `.cmd` and `.bat` files are checked out with CRLF (Windows batch files misparse labels with LF); everything else stays LF. |
| R04 | Module signals | GDScript has no static signals, and a static function cannot emit an instance signal (both checked on Godot 4.7.2). Module APIs are static, so each module with signals puts them on an events object, `public/<name>_events.gd` (`<Name>Events extends RefCounted`), reached through `<Name>Api.events()`. The object is created on first use and held by `Services` (`Services.get_or_create`, added to M01-T1), so subscribers can connect before the module's `register()` runs and no module keeps hidden static state. Specs M08–M15 and M17 updated. Signals on instances (`Vehicle`, `GameClock`, `Unlocks`) are unchanged. |
