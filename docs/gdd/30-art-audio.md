# 30 · Art and audio

## Art direction (decisions C03, G12)

- **Low-poly, flat-shaded hard-surface models** with **realistic real-time lighting** (shadows, fog).
- **Pixel filter:** the frame renders at about 1/3 resolution and is upscaled crisp; shadows are dithered.
- **Per-biome color grading** (LUT) locked to the palette: desert ochre, salt-flat gray-white, volcanic-ash black, one saturated bright green accent.
- **Blueprint-style design mode:** the builder uses a minimalist wireframe look without lighting.
- **Damage visuals:** scorch decals, smoke and fire by part state, blocks falling off.
- **Edge-detect NPCs:** people and figures pass through an edge-detection/threshold shader — the "AI vision preprocessing" look.
- **Robot-vision HUD:** the interface is styled as the protagonist's visual overlay.

## Vehicle assets (from the original notes)

- Running gear: per Weight Class, about 3–5 models with 1–4 variants each. Basic suspension feedback plus a few animated moving parts (tracks, chains) driven by the simulated wheels.
- Mortars (from T2): loading mechanism models and animations; the link between loader and Ammo Rack is a procedurally generated animated part.
- Autocannons T1–T3; cannons T1–T5; see 14-weapons for counts.
- Some variants differ only in appearance, sound or effects.

## Sound (decision G13)

- **Engine voices by power plant type**, pitched by load: steam chuff, diesel rumble, electric whine, reactor hum.
- **Matter-wave tuning audio:** pitch and loudness rise as the frequency approaches the target's resonance band.
- **Distance-delayed gunfire:** sound travels about 343 m/s, which sells the scale of large vehicles.
- **Faction radio chatter** as ambient story. After Radio Communications, the chatter also hints at random events nearby that the player can take advantage of.
- No adaptive music layer planned (not selected).
