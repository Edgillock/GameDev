# Audio — module M21

- **Spec:** `docs/specs/M21-audio.md` (read the task you were given)
- **Design:** `docs/gdd/30-art-audio.md`
- **Kind:** presentation
- **Public surface:** `audio_api.gd` (`class_name AudioApi`) and `public/`

## Owns

- All sound playback; listens to module signals

## Uses (the only things this module may reference)

- `game/core/`
- `vehicle`: its `vehicle_api.gd` and `public/` only
- `power`: its `power_api.gd` and `public/` only
- `weapons`: its `weapons_api.gd` and `public/` only
- `damage`: its `damage_api.gd` and `public/` only
- `world`: its `world_api.gd` and `public/` only

## Must not

- Reference any module not listed under **Uses**.
- Reach into another module's `internal/`, `data/` or `scenes/`, or use node paths into another module's nodes.
- Put gameplay numbers in code (they belong in `data/*.tres`).
- Edit files outside this folder (except appending to `docs/open-questions.md`).
- Read `Input` directly (only `controls` reads input; everything else receives Orders).

## Folder layout

```
audio_api.gd   public entry point
public/        data types other modules may use
internal/      private implementation
data/          .tres files
scenes/        demo_audio.tscn and private scenes
tests/         gdUnit4 tests
```

## Status

Update this list at the end of every task (check the box, add one line on what's next).

- [ ] M21-T1 Audio framework and engine voices
- [ ] M21-T2 Weapon and impact sounds with distance delay
- [ ] M21-T3 Matter-wave tuning audio
- [ ] M21-T4 Radio chatter
