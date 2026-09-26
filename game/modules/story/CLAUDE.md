# Story & Quests — module M20

- **Spec:** `docs/specs/M20-story.md` (read the task you were given)
- **Design:** `docs/gdd/25-story.md`
- **Kind:** meta
- **Public surface:** `story_api.gd` (`class_name StoryApi`) and `public/`

## Owns

- Quests, dialogue, endings, story logs

## Uses (the only things this module may reference)

- `game/core/`
- `progression`: its `progression_api.gd` and `public/` only
- `world`: its `world_api.gd` and `public/` only

## Must not

- Reference any module not listed under **Uses**.
- Reach into another module's `internal/`, `data/` or `scenes/`, or use node paths into another module's nodes.
- Put gameplay numbers in code (they belong in `data/*.tres`).
- Edit files outside this folder (except appending to `docs/open-questions.md`).
- Read `Input` directly (only `controls` reads input; everything else receives Orders).
- Depend on UI: no references to `controls`, `builder`, `hud` or `audio`.

## Folder layout

```
story_api.gd   public entry point
public/        data types other modules may use
internal/      private implementation
data/          .tres files
scenes/        demo_story.tscn and private scenes
tests/         gdUnit4 tests
```

## Status

Update this list at the end of every task (check the box, add one line on what's next).

- [ ] M20-T1 Quest framework
- [ ] M20-T2 Region 1 campaign content
