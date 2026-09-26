# M13 · World

- **Status:** READY (T4 DRAFT)
- **Folder:** `game/modules/world/`
- **Uses:** core, vehicle, damage
- **Design:** `docs/gdd/20-world.md`

## Purpose

The environment: Ground Types on terrain, biomes, weather, day and night, Time Acceleration, and the maps. Implements core `EnvironmentQuery`.

## Public API sketch

```gdscript
class_name WorldApi
static func register() -> void
static func current_weather(pos: Vector3) -> WeatherState
static func set_time_scale(scale: float) -> Error     # refuses while a forcing event is active
static func events() -> WorldEvents      # signals live here (CLAUDE.md §3.2)
# public/world_events.gd: class_name WorldEvents extends RefCounted
signal weather_changed(area_id: StringName, weather: WeatherState)
signal forced_realtime(reason: StringName)
```

Public types: `BiomeDef`, `WeatherDef` (view range ×, Ground Type shift, concealment modifier, noise modifier, ambient temp), `WeatherState`, `BiomeArea` (a node/volume marking a biome region), `WorldEvents`.

## Tasks

### M13-T1 · Ground types and the environment service (READY)

**Build**
- Terrain surfaces carry a Ground Type: via `PhysicsMaterial` resources named by ground type or collider metadata `ground_type` (pick one, document it in the module CLAUDE.md).
- `BiomeArea` volumes with a `BiomeDef`.
- Implement `EnvironmentQuery` (ground type at a point; view range, concealment and ambient temperature from biome + weather + time of day).
- Mark the M00 test ground as HARD (this task may edit `test_ground.tscn` for that).

**Tests:** query returns the right ground type and biome values in fixture areas.

### M13-T2 · Day, night, weather and Time Acceleration (READY)

**Build**
- Day/night: sun angle and light color from `GameClock`; night factor from data.
- Weather state machine per biome area: weights per biome (data) for the weather types in 20-world; transitions over in-game time; Rng stream `&"weather"`.
- Weather effects exposed through `EnvironmentQuery` (view range ×, Ground Type shift like rain → hard behaves as medium, concealment and noise modifiers).
- Time Acceleration: `set_time_scale()` changes `GameClock.time_scale` (1× … N× from data). Certain events (combat detected, raid) emit `forced_realtime` and reset to 1×. Timers elsewhere must use `GameClock`, so they speed up too (C19).

**Tests:** weather transitions are deterministic with a seed; rain shifts ground type; forced realtime resets scale.

### M13-T3 · Region 1 test map (READY)

**Build** a small Badlands map (about 2 × 2 km) for the vertical slice: hard ground with low drag, some destructible cover (simple static bodies with HP handled as world props — damage through `DamageApi.apply_area` hooks is a later task), a start area, a wreck field, one enemy outpost location, one research site location (placeholders). Terrain art: flat-shaded low-poly.

**Done when** the owner can drive around the map at 1× and accelerated time.

### M13-T4 · Biome effects and events (DRAFT — needs OQ-01)

Volcanic heat and debuffs, eruptions (magma areas: thermal; falling rocks: kinetic via `DamageApi`), sandstorms, Desert clear-weather concealment drop, Oasis concealment areas, POIs, risk zones. Needs the region/biome layout.

## Out of scope

Seasons (cut). Quests (M20). Logistics risk events (M18).
