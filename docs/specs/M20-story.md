# M20 · Story & Quests

- **Status:** DRAFT — answer OQ-05 first
- **Folder:** `game/modules/story/`
- **Uses:** core, progression, world
- **Design:** `docs/gdd/25-story.md`

## Tasks

### M20-T1 · Quest framework (DRAFT)
Quest defs (steps, conditions, rewards through `ProgressionApi.grant`; item rewards need economy, which story may not use — wire them in `game/scenes` or raise a change request when this task becomes READY), quest log, main vs side quests, epilogue flags from completed side quests (C18), story logs at POIs, radio chatter hooks (after Radio Communications) that point to random events.

### M20-T2 · Region 1 campaign content (DRAFT)
The tutorial arc from 25-story: first T1 build, power and armor basics, first fight, first Research Puzzle, Scrap Sorting Manual reward, road to Region 2.
