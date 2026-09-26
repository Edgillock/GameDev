# 11 · Mobility

## Running Gear Units

A Running Gear Unit is one wheel set, track unit or leg set. A vehicle can have many. Each unit has:

- mass, center of mass, `hp`, resistances and protections;
- **energy type compatibility** (which power it can take);
- `transmission_efficiency` (0–1): multiplies the power it receives to give usable drive power;
- `rated_load` (kg);
- `terrain_drag` for each Ground Type (water, soft, medium, hard);
- suspension settings (spring, damping, travel) and grip;
- a **Mount Deck**: a flat area on top that other parts can sit on.

Running gear Weight Classes match vehicle Weight Classes. Each class has about 3–5 models, each with 1–4 variants. Some variants only change appearance, sound or effects.

## Movement is physics-driven (decision C04)

- The whole vehicle is one rigid body in Jolt.
- Each Running Gear Unit is a suspension ray/shape cast that pushes on that body: spring and damper force, drive force and friction force, applied at its contact point.
- Hits, weapon recoil and slopes therefore move the vehicle naturally, and low-friction surfaces behave correctly.

### Starting formulas (tunable; decision G20)

- **Maximum drive force** of a unit:
  `F_max = P × transmission_efficiency × exhaust_efficiency ÷ max(v, v_min)`
  where P is the power it receives, v its ground speed, v_min a small data constant.
- **Grip limit:** `μ(ground type) × normal load on the unit`.
- **Overload:** `load_factor = actual load ÷ rated_load`. Above 1.0, drive force and grip are multiplied by `1 ÷ load_factor²`, and the suspension bottoms out.
- Terrain Drag adds resistance by Ground Type.

## Power supply

A unit only drives if it sits inside the **Drive Range** of a Power Plant or Power Relay with a compatible energy type (decision C21). See 12-power.

## Damage

- Each unit has its own HP. At 0 it is destroyed and stops working.
- Performance depends on HP %: transmission efficiency drops and terrain drag rises as HP falls (curve in data).

## Visual moving parts (decision C24)

The hull and suspension are physically simulated. Tracks, chains and linkages are **animated procedurally** from the simulated wheel positions; they are not physics objects.

## Ramming

- Contact between the player's vehicle and a non-friendly vehicle causes kinetic damage.
- Starting formula (decision G20): energy `E = ½ × μ × v_rel²` (μ = reduced mass of the two vehicles), split between them by inverse mass.
- **Crush rule:** if two colliding vehicles differ by **2 or more Weight Classes and their running gear also differs by 2 or more classes**, the smaller vehicle takes ×3 damage.

## Ground Types by biome

See 20-world.
