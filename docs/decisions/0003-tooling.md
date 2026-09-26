# 0003 · Tooling — September 2026

Test tooling installed by M00-T2 (2026-09-26).

| ID | Topic | Decision |
|---|---|---|
| T01 | Test framework | **gdUnit4 v6.2.1**, the latest release. Its compatibility table lists Godot 4.7 and 4.7.1; verified on 4.7.2. Installed in `addons/gdUnit4/` from the `v6.2.1` tag with gdUnit4's own export rules (`git archive`), so its internal test suite and its `AGENTS.md`/`CLAUDE.md` files are left out. The `.uid` and `.png.import` files Godot generated for it are committed so every machine shares them. |
| T02 | Test command | `tools/run_tests.sh` (Claude) and `tools/run_tests.cmd` (owner, double-click). Both read the Godot path from `tools/local.cfg`, prefer Godot's `_console.exe` twin on Windows, run `--import` first (a fresh checkout has no class cache), then gdUnit4's `GdUnitCmdTool.gd` over `res://game`. |
| T03 | Headless | Tests run with `--headless --ignoreHeadlessMode`. Real `InputEvent`s do not reach tests in headless mode, so input tests feed fake input state (as M06 already specifies). |
| T04 | Debug flags | gdUnit4's own `runtest.sh` passes `-d --remote-debug tcp://127.0.0.1:0`; ours does not. On 4.7.2 passing, failing, script-error and runtime-error runs gave identical results and exit codes without them, and they print misleading `ERROR` lines. |
| T05 | Exit codes | gdUnit4's codes are passed through: 0 passed, 100 a test failed or errored, **101 orphan nodes (counted as a failure: leaked memory)**, 104 unsupported Godot version, 105 script errors while loading tests. The scripts add 2 (missing `local.cfg` or Godot not found) and 1 (import failed). |
| T06 | Reports | `reports/` (git-ignored, with a `.gdignore` so Godot skips it): an HTML and XML report per run, `last_run.log`, `last_import.log`. |

**Upgrading gdUnit4:** clone the new tag, replace `addons/gdUnit4/` with `git archive <tag> addons/gdUnit4`, open the project once so Godot adds the `.uid` and `.import` files, run the whole suite, and add a row here.
