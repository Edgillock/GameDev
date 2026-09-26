# Open questions and change requests

Claude appends here instead of guessing. The owner answers by editing the **Answer** line (or tells Claude in chat). Answered items move into `docs/gdd/` and get `Status: answered`.

Formats:

```
### OQ-<n> — <title>
- Raised by: <who / which task>
- Blocks: <spec tasks it blocks, or "nothing yet">
- Question: …
- Answer: (open)

### CR-<n> — <title>
- From: Mxx-Tn (<module>)
- Needs: <what, from which module or core>
- Why: …
- Workaround used: …
- Status: open
```

---

## Open questions

### OQ-01 — Which biomes go in Regions 2–4?
- Raised by: design triage (G08, "leave this for now")
- Blocks: M13 world content beyond Region 1
- Question: Region 1 is Badlands. Where do Salt Flats, Desert, Volcanic Fields, Snowfield and Oasis go?
- Answer: (open)

### OQ-02 — How do Weight Classes unlock?
- Raised by: design triage (G09 "weight class gates" not selected)
- Blocks: M16 progression
- Question: Main-story milestones, Knowledge, Home Base upgrades, or something else?
- Answer: (open)

### OQ-03 — Weight Class caps and grid steps
- Raised by: design triage (C05)
- Blocks: nothing yet (placeholders from the table in 10-vehicle-structure)
- Question: Exact bounding box, mass and part-count caps per class; grid step per class (T1 = 0.1 m).
- Answer: (open)

### OQ-04 — What does the Brain-Computer Interface do?
- Raised by: design triage (C15: AI vehicles take Squad orders only)
- Blocks: nothing yet
- Question: The original "override running components" and "remove order delays" no longer fit. Keep only the Holo-Terminal live status link, or give it a new effect?
- Answer: (open)

### OQ-05 — Protagonist name and story beats
- Raised by: design triage
- Blocks: M20 story
- Answer: (open)

### OQ-06 — Crew recruitment and robot crews
- Raised by: design triage (A12 mixed crew)
- Blocks: M12 crew recruitment (not the crew rules themselves)
- Question: Where are human crews recruited? What unlocks robot crews (Control Theory, Brain-in-a-Vat, something else)? Do they differ in stats?
- Answer: (open)

### OQ-07 — Combat Rating formula
- Raised by: design triage (A07)
- Blocks: M14-T4 (AI stance)
- Question: Which Rated Stats go in and with what weights? Placeholder: sum of firepower, protection and mobility scores, scaled by current HP %.
- Answer: (open)

### OQ-08 — Certification Trials
- Raised by: original notes (community)
- Blocks: M22
- Question: Which trials (speed run, climb, firing range, armor test…), and how their scores become Rated Stats and auto role categories.
- Answer: (open)

### OQ-09 — Decal / paint editor scope
- Raised by: original notes ("risk point")
- Blocks: builder decal task (not scheduled)
- Answer: (open)

### OQ-10 — Separate design and construction interfaces?
- Raised by: original notes (TBD feature)
- Blocks: nothing yet
- Answer: (open)

### OQ-11 — Performance budget
- Raised by: design triage (G15 performance budget not selected)
- Blocks: nothing yet; decide before Milestone 3
- Question: Target hardware and frame rate with how many vehicles of which classes.
- Answer: (open)

### OQ-12 — Superweapons
- Raised by: design triage (C09)
- Blocks: superweapon models (not scheduled)
- Question: Which models carry the Superweapon tag, and their limits (uses, cooldown, power).
- Answer: (open)

### OQ-13 — Activation Groups: count and membership (assumed)
- Raised by: owner request for Activation Groups
- Blocks: nothing (assumption in use)
- Assumed: 9 groups per vehicle; a weapon can belong to several groups. Confirm or change.
- Answer: (open)

### OQ-14 — Number-key contexts (assumed)
- Raised by: Activation Groups + Command & Conquer-style Squads both want keys 1–9
- Blocks: nothing (assumption in use)
- Assumed: Drive view → keys 1–9 call Activation Groups; Command view → keys 1–9 select Squads, Ctrl+1–9 assigns; Tab switches views. Confirm or change.
- Answer: (open)

### OQ-15 — How many allied AI vehicles?
- Raised by: original notes ("relatively strict limits")
- Blocks: M14-T5 (Squad caps)
- Question: Cap by progress (e.g. 2 → 5 → 9) or only by Brain-in-a-Vat count?
- Answer: (open)

### OQ-16 — Ammo damage components (proposed)
- Raised by: design triage
- Blocks: M10-T3 for ammo beyond AP and HE
- Question: Confirm the mapping in 14-weapons (APHE = kinetic then explosive, HESH = explosive with strong overpressure, …).
- Answer: (open)

### OQ-17 — Fuel Line details
- Raised by: design triage (C22 allow fuel lines)
- Blocks: M08 fuel line damage effects
- Question: Do broken lines leak or catch fire? Is there a length or cost rule?
- Answer: (open)

### OQ-18 — Fission vs Fusion Reactors
- Raised by: owner note on the Reactor term
- Blocks: reactor data in M08
- Question: How do they differ (output, fuel, heat, Destruction Blast, unlock)?
- Answer: (open)

### OQ-19 — How Blast Protection reduces explosive damage
- Raised by: design triage (C12)
- Blocks: nothing (placeholder in use: × clamp(blast_power ÷ blast_protection, 0, 1))
- Answer: (open)

### OQ-20 — Home Base sectors
- Raised by: design triage (C07)
- Blocks: M17 Home Base
- Question: Final sector list and what each upgrade level gives.
- Answer: (open)

### OQ-21 — Research Puzzles and Crew Drills content
- Raised by: original notes
- Blocks: M16 puzzles, M12 drills
- Answer: (open)

### OQ-22 — Post-game challenges
- Raised by: design triage (Expeditions not selected)
- Blocks: nothing yet
- Answer: (open)

### OQ-23 — Weapon family spans (proposed)
- Raised by: design triage (C20)
- Blocks: weapon data beyond T1
- Proposed: autocannon T1–T3, cannon T1–T5, mortar T2–T6. Confirm.
- Answer: (open)

---

## Change requests

(none yet)
