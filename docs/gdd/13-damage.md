# 13 · Damage

## Health

- Every part has **one** health value: `hp` (decision A02). There is no separate durability.
- Some parts lose performance as HP falls (curves in data, per part).
- At 0 HP a part is destroyed. Some parts then release a **Destruction Blast**.

## Stats per damage type (decision A09)

| Damage type | Attacker stat | Defender stats |
|---|---|---|
| Kinetic | `kinetic_penetration` | `kinetic_protection`, `kinetic_resistance` |
| Explosive | `blast_power` | `blast_protection`, `explosive_resistance` |
| Chemical | `chemical_potency` | `chemical_protection`, `chemical_resistance` |
| Thermal | heating rate, max temperature | `heat_capacity`, `heat_dissipation`, `overheat_temp`, `meltdown_temp` |
| Matter-Wave | frequency, power density | `resonance_band` |

- **Resistance** divides raw damage of its type.
- **Protection**, together with the attacker stat, shapes or reduces the damage volume.
- A projectile can carry several damage components (e.g. APHE: kinetic, then explosive). See 14-weapons for the ammo mapping.

## Resolution order

Overpressure → Kinetic → Explosive → Thermal, Chemical, Matter-Wave.

## Kinetic

- Damage volume: a **line or cylinder**, no falloff.
- Cylinder diameter depends only on the projectile (caliber / object size).
- Cylinder length depends on the projectile's `kinetic_penetration` and the `kinetic_protection` of what it passes through.
- Damage follows the kinetic energy formula (½ m v²), divided by `kinetic_resistance`.
- Hits armor, parts and bonds inside the volume.

## Explosive (decision C12)

- Damage volume: a **sphere**. Radius is fixed per shell by its `blast_power`.
- Falloff: `max(0, 1 − x / R)` (x = distance from center, R = radius).
- Each object inside takes `blast damage × falloff`, reduced by its own `blast_protection` and divided by `explosive_resistance`. How protection reduces damage: OQ-19 (placeholder: × clamp(blast_power ÷ blast_protection, 0, 1)).
- **Overpressure:** a pressure field with the same falloff. Wherever pressure exceeds a bond's effective strength, the bond fails instantly and the block it held falls off. Overpressure resolves before kinetic and explosive damage.

## Matter-Wave

- The weapon emits on a frequency the player can tune within the weapon's range. Each change of frequency has a restart delay.
- Each weapon/variant has a frequency range and a maximum effective range.
- Damage only applies to the **first object** the ray hits (no penetration), within range, and only if the frequency lies inside that object's `resonance_band` (decision C14: every material has one).
- Inside the band, HP drains continuously; the rate is proportional to the **power density** at the hit point, which falls with distance along the ray.
- Outside the band: no damage.
- Feedback: the closer the frequency to the band, the higher the pitch / louder the sound.
- Hints: Recon and unlocked materials can mark resonance bands. Bands of partly filled blocks can't be hinted.

## Thermal (flame and laser)

- **Flame:** damage volume is a sphere centered on the first point the flame hits; radius is proportional to distance within range.
- **Laser:** same method, fixed radius, higher heating.
- Inside the sphere: a small, constant HP drain (no resistance applies — heat stats are the defense; decision C13), plus a **heating field** whose rate falls linearly with radius.
- Each weapon has a maximum temperature it can drive a target to.
- Temperature model (decision A08): rise = heat in ÷ (`heat_capacity` × mass); cooling per second = `heat_dissipation`.
- **Above `overheat_temp`:** the object's kinetic, explosive and chemical resistances are multiplied by an overheat factor (data; starting value 0.5).
- **Above `meltdown_temp`:** the object is destroyed regardless of HP.
- Power Plants, Relays and Conduits that are overheated and active run malfunction checks at a fixed interval; failure destroys them.
- A flamethrower modification can add chemical damage.

## Chemical

- Damage volume: a sphere of fixed radius. Several rays of equal length (= radius) are cast, evenly spread over the sphere.
- For each ray that reaches an object, the depth of effect follows Beer–Lambert (decision G20): `damage(d) = D₀ × e^(−k·d)`, with `k = chemical_protection ÷ chemical_potency`.
- Damage is dealt over time at a low constant rate, divided by `chemical_resistance`.
- **Heat Synergy:** `rate × (1 + α × max(0, T − T_ref) ÷ T_ref)` — hotter targets corrode faster.

## Destruction

- HP 0 → part destroyed.
- Power Plants, Relays, Conduits, Fuel Tanks, some weapons and Ammo Racks release their `destruction_blast` (type, amount, radius).
- Bonds that fail detach blocks; any group without a path to the Command Module becomes debris (see 10-vehicle-structure).
- Command Module destroyed → vehicle lost.
