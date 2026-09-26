# 41 · Milestones and acceptance (decision G16)

Each milestone ends in something the owner can play. Specs list which tasks belong to which milestone (`docs/specs/README.md`).

| Milestone | Name | Playable result |
|---|---|---|
| 0 | Skeleton | Folders, test runner, boundary checker, data registry. An empty boot scene runs. |
| 1 | Box on wheels | Place blocks, running gear and a Command Module in the builder; deploy and drive on flat ground. |
| 2 | Power | Power plant, conduits and power budget; speed depends on power and mass. |
| 3 | First shot | One cannon with AP and HE; Activation Groups; bonds break and blocks fall off. |
| 4 | Seen and unseen | Observation Ports, concealment, one AI enemy type, a Squad of allies. |
| 5 | Vertical slice | Small Region 1 map, a 30-minute loop, save and load. |

## "Done when" rule for every module task

A task is done only when:

1. Its checklist in the spec is complete.
2. The full test suite passes, including tests from other modules.
3. The boundary check passes.
4. The module's demo scene shows the new behavior, and the owner has been told how to see it.
