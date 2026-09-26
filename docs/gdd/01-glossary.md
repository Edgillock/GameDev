# Glossary

The only allowed names for game concepts. Use the **Term** in text and UI, and the **Code name** in code. "Replaces" lists the wording used in the original design document, so old notes can still be read.

Code name conventions: `PascalCase` = class, `snake_case` = field, `Enum.VALUE` = enum value.

## Game and modes

| Term | Code name | Meaning | Replaces |
|---|---|---|---|
| Campaign | `GameMode.CAMPAIGN` | The story and progression mode. | Normal Mode |
| Creative Mode | `GameMode.CREATIVE` | Infinite resources, instant building and crafting, everything unlocked. | Casual (Creative) Mode |
| Expeditions | `GameMode.EXPEDITION` | Post-game runs on new maps. **Not planned for v1.** | expedition mode |
| Flagship | `Flagship` | The vehicle carrying the protagonist. Always under the player's full control. | — |
| Squad | `Squad` | A numbered set (1–9) of AI vehicles that receive orders together, Command & Conquer style. | — |
| Order | `Order` | A command expressed as data (move, attack, fire group…). | dispatch commands |
| Direct Control | `ControlMode.DIRECT` | The player drives and aims the Flagship personally (third or first person). | manual override |
| Delivery Contract | `ContractType.DELIVERY` | Carry cargo to a place; needs a mandatory cargo module. | Escort missions |
| Farm / Extractor | `ProductionSite` | Timed production of crops (farm) or fuel and ore (extractor). | Farm |
| Crew Drill | `CrewDrill` | Minigame that gives crew XP; limited plays per period. | built-in minigames |
| Research Puzzle | `ResearchPuzzle` | Quiz or puzzle that unlocks Knowledge; unlimited attempts, no penalty. | knowledge quiz / puzzles |
| Reverse Engineering | `ReverseEngineering` | Spend materials on a trial build for a chance to unlock a technology without its key item. | Blind Box Mechanic |
| Time Acceleration | `TimeScale` | Fast-forwarding in-game time. | Fast-forward |
| Certification Trial | `CertificationTrial` | A benchmark run that produces a blueprint's Rated Stats. | verification benchmark tests |
| Rated Stats | `RatedStats` | The spec-sheet numbers of a blueprint. | panel attributes |
| Home Base | `HomeBase` | The only place new player vehicles are manufactured. | production/construction base |
| Logistics Node | `LogisticsNode` | Supply site. Ground version: **Depot**; air version: **Airfield**. | logistics station / transport node / logistics node |
| Raid | `RaidEvent` | An attack on a Logistics Node. | supply plunder events |
| Salvaging | `Salvage` | Recovering materials from wrecks. | wreck salvage gameplay |
| Scrip | `Scrip` | The basic currency. | basic currency |

## Vehicle structure

| Term | Code name | Meaning | Replaces |
|---|---|---|---|
| Box | `Box` | A rectangular cuboid. Every block, strut, tank and ammo rack is one. | orthogonal hexahedron |
| Armor Block | `ArmorBlock` | A box of armor material. | armor unit |
| Adhesive | `AdhesiveDef` | The glue material. | adhesive |
| Bond | `Bond` | One glued contact between two touching faces. | adhesive (on a face) |
| Strut | `Strut` | A box-shaped structural member with collision; compatibility 1 with every material. | Truss |
| Infill | `infill` (0–1) | How solid a block is; 1 = fully filled. | fill rate |
| Density | `density` (kg/m³) | | unit density |
| Chamfer | `chamfer` | Visual edge cut; changes neither stats nor collision. | chamfering |
| Command Module | `CommandModule` | Mandatory, one per vehicle. Holds the protagonist or a Brain-in-a-Vat. Destroyed = vehicle lost. | command room |
| Running Gear Unit | `RunningGear` | A wheel set, track unit or leg set. Carries transmission efficiency, rated load and terrain drag. There is no separate chassis part. | chassis / running gear |
| Mount Deck | `mount_deck` | The flat area on top of a running gear unit that other parts can sit on. | mounting platform |
| Workshop Module | `WorkshopModule` | The Maintenance crew's room. | maintenance room |
| Crew Compartment | `CrewCompartment` | Optional room that slightly improves crew and holds consumables. | crew cabin |
| Observation Port | `ObservationPort` | A point on the hull that casts detection rays. | observation point |
| Ammo Rack | `AmmoRack` | Box that stores a weapon's ammunition. | ammo storage |
| Salvage Rig | `SalvageRig` | Front-mounted tool for salvaging wrecks. | Salvage module |
| Weight Class | `weight_class` (T1–T6) | Size class of a vehicle; caps bounding box, mass and part count. | T1–T6 tonnage levels |
| Combat Rating | `combat_rating` | The AI's estimate of a vehicle's fighting strength. | vehicle rating |
| Ground Type | `GroundType.WATER / SOFT / MEDIUM / HARD` | Surface category under a running gear unit. | water/soft/medium/hard terrain |
| Terrain Drag | `terrain_drag` | Per-Ground-Type drag of a running gear unit. | terrain resistance coefficient |
| Family → Model → Variant | `WeaponFamily`, `model_id`, `variant_id` | Hierarchy used by running gear and weapons. | levels / models / variants |

## Power

| Term | Code name | Meaning | Replaces |
|---|---|---|---|
| Power Plant | `PowerPlant` | Produces power; drives running gear and feeds relays and weapons. | prime propulsion unit |
| Steam Engine | `PowerPlantType.STEAM` | | external combustion engine |
| Combustion Engine | `PowerPlantType.COMBUSTION` | | internal combustion engine |
| Diesel-Electric | `PowerPlantType.DIESEL_ELECTRIC` | | internal combustion engine hybrid electric drive |
| Fission Reactor | `PowerPlantType.FISSION` | One of the two reactor types. | nuclear power |
| Fusion Reactor | `PowerPlantType.FUSION` | One of the two reactor types. | nuclear power |
| Exotic Power Plant | `PowerPlantType.EXOTIC` | | special types |
| Energy Type | `EnergyType.THERMAL / ELECTRIC / EXOTIC` | Kind of power a part produces or needs. | surreal / exotic / special |
| Power Relay | `PowerRelay` | Receives power, converts its type, extends supply range. | Power Relay Node |
| Power Conduit | `Conduit` | Carries power between power parts and weapons. | Power Delivery Pipe |
| Loss per meter | `loss_per_m` | Fraction of power lost per meter of conduit (real number). | power loss rate |
| Exhaust Stack | `ExhaustStack` | Mandatory for some power plants; outlet must be in open air. | Exhaust Pipe |
| Fuel Tank | `FuelTank` | Box whose volume sets fuel capacity. | fuel tank |
| Fuel Line | `FuelLine` | Connects a fuel tank to a power plant it doesn't touch. Can be hit. | — |
| Drive Range | `drive_range` | Sphere or box around a power plant or relay; running gear inside it can draw power. | drive range |
| Active | `is_active` | On/off state of a part. | Boolean operating state |

## Damage

| Term | Code name | Meaning | Replaces |
|---|---|---|---|
| HP | `hp` | The only health value of a part. Performance can depend on HP %. | HP/durability, base HP |
| Damage Type | `DamageType.KINETIC / EXPLOSIVE / MATTER_WAVE / THERMAL / CHEMICAL` | | Kinetic / Explosive / Matter Wave / Energy / Chemical |
| Kinetic Penetration | `kinetic_penetration` | Attacker stat for kinetic damage. | kinetic penetration level |
| Kinetic Protection | `kinetic_protection` | Defender stat that shortens the kinetic damage volume. | kinetic protection level |
| Blast Power | `blast_power` | Attacker stat for explosive damage; sets blast radius. | explosive penetration level |
| Blast Protection | `blast_protection` | Defender stat that reduces explosive damage taken. | explosive protection level |
| Chemical Potency | `chemical_potency` | Attacker stat for chemical damage. | chemical penetration |
| Chemical Protection | `chemical_protection` | Defender stat that reduces chemical depth. | chemical protection level |
| Resistance | `kinetic_resistance`, `explosive_resistance`, `chemical_resistance` | Divides raw damage of that type. | resistance |
| Damage Volume | `damage_volume` | The line, cylinder or sphere inside which damage applies. | resolution range |
| check / resolve | — | Use "destruction check", "damage resolution", "resolution order". | judgment / judged |
| Overpressure | `overpressure` | Blast pressure field that breaks bonds. | overpressure |
| Heat Capacity | `heat_capacity` | Temperature rise = heat in ÷ (heat capacity × mass). | heat capacity (subtractive) |
| Heat Dissipation | `heat_dissipation` | Cooling per second. | heat capacity (cooling part) |
| Overheat Threshold | `overheat_temp` | | overheat temperature |
| Meltdown Threshold | `meltdown_temp` | Above it the part is destroyed regardless of HP. | meltdown temperature |
| Resonance Band | `resonance_band` (min–max Hz) | Frequencies at which matter-wave damage works on a material. | resonance frequency / band |
| Heat Synergy | `heat_synergy` | Chemical damage grows with target temperature. | synergy |
| Malfunction Chance | `malfunction_chance` | Chance a power part stops (or is destroyed) when hit or overheated. | hit failure rate |
| Destruction Blast | `destruction_blast` | Damage type, amount and radius released when a part is destroyed. | damage type/range after destruction |
| Ramming | `RamDamage` | Collision damage between vehicles. | collision and crushing |
| proportional to | — | | "propulsion to" (mistranslation) |

## Weapons

| Term | Code name | Meaning | Replaces |
|---|---|---|---|
| Weapon Class | `WeaponClass.BALLISTIC / DIRECTED_ENERGY / AREA_DENIAL / EW` | Classification by delivery method. | Projectile / Non-Contact / Mobility Restriction / Interference Type |
| Superweapon | `tags` contains `&"superweapon"` | A tag on certain heavy models in any class. | Superweapon Type |
| Power Mode | `PowerMode.UNPOWERED / UNDERPOWERED / NORMAL / OVERCLOCKED` | | low-power / overclock operation |
| Power Ratio | `power_ratio` | Supplied power ÷ rated power. | power ratio |
| Dispersion | `dispersion_deg` | Random angular spread when a shot leaves the barrel. | deviation angle |
| Accuracy stats | — | Dispersion and aim time. | fire-control parameters |
| Step function | — | Piecewise-constant function. | constant piecewise function |
| Activation Group | `ActivationGroup` | A numbered set (1–9) of weapons on one vehicle that respond to commands as a whole when called with its key. | — |
| Target Lock | `target_lock` | A weapon or group is aimed at and tracking a target. | target acquisition (weapon sense) |
| AP | `AmmoType.AP` | Full-bore solid shot. | general kinetic / homogeneous armor-piercing |
| APCR | `AmmoType.APCR` | | hard-core armor-piercing |
| HEAT | `AmmoType.HEAT` | | shaped-charge |
| APHE | `AmmoType.APHE` | | armor-piercing high-explosive |
| HESH | `AmmoType.HESH` | | squash-head |
| HE / Cluster HE | `AmmoType.HE`, `AmmoType.HE_CLUSTER` | | high-explosive charge / cluster HE |
| Chem / Cluster Chem | `AmmoType.CHEM`, `AmmoType.CHEM_CLUSTER` | | chemical charge / cluster chemical |

## Detection

| Term | Code name | Meaning | Replaces |
|---|---|---|---|
| Detection | `Detection` | Knowing an enemy exists and where it is. | target acquisition (seeing sense) |
| Max View Range | `max_view_range` | Length of detection rays. | maximum vision |
| Detection Range | `detection_range` | Range at which a specific ray hit counts as detected. | actual vision |
| Auto-Spot Range | `auto_spot_range` | Inside it both sides are always detected. | forced acquisition vision |
| Noise | `noise` | Accumulated signature from firing, engines, lights. | noise coefficient / noise penalty |
| Concealment | `concealment` | Paint/biome value that shortens enemy Detection Range. | concealment coefficient |
| Recon Masking | `recon_masking` | Lowers the chance that enemy Recon Scans reveal your parts. | camouflage coefficient |
| Recon Scan | `ReconScan` | The Recon crew's active skill. | recon skill |

## Crew

| Term | Code name | Meaning | Replaces |
|---|---|---|---|
| Crew | `Crew` | One team of crew members. | crew group |
| Crew Role | `CrewRole.POWERTRAIN / MAINTENANCE / RECON / SALVAGE / GUNNERY` | | Propulsion / Maintenance / Recon / Salvage / Weapons |
| Proficiency | `proficiency` | Crew level and XP. | operation proficiency / crew values |
| Trainee | `trainee` | The second crew slot on a weapon: gains XP, gives no bonus. | additional carried crew |

## Knowledge and Devices

Knowledge is recovered (data caches, Research Puzzles) and unlocks recipes and features. Devices are built or found and installed on a vehicle or base.

| Term | Kind | Code name | Replaces |
|---|---|---|---|
| Internal Ballistics | Knowledge | `&"knowledge.internal_ballistics"` | |
| External Ballistics | Knowledge | `&"knowledge.external_ballistics"` | |
| Control Theory | Knowledge | `&"knowledge.control_theory"` | |
| Scrap Sorting Manual | Knowledge | `&"knowledge.scrap_sorting"` | Garbage Classification Manual |
| Radio Communications | Knowledge | `&"knowledge.radio"` | Wireless Communication Technology |
| Additive Manufacturing | Knowledge | `&"knowledge.additive_manufacturing"` | Additive Manufacturing Technology |
| Computer Vision | Knowledge | `&"knowledge.computer_vision"` | |
| Electromagnetics | Knowledge | `&"knowledge.electromagnetics"` | |
| Wireless Power Transfer | Knowledge | `&"knowledge.wireless_power"` | Wireless Power Transmission Technology |
| Aeronautics | Knowledge | `&"knowledge.aeronautics"` | |
| Organic Chemical Engineering | Knowledge | `&"knowledge.organic_chemistry"` | |
| Advanced Metallurgy | Knowledge | `&"knowledge.advanced_metallurgy"` | Special Metal Materials Technology |
| Element Analyzer | Device | `&"device.element_analyzer"` | |
| Holo-Terminal | Device | `&"device.holo_terminal"` | Holographic Instrument |
| Ballistic Computer | Device | `&"device.ballistic_computer"` | |
| Night Vision Device | Device | `&"device.night_vision"` | |
| Brain-in-a-Vat (BiaV) | Device | `&"device.brain_in_a_vat"` | Brain-In-A-Vat |
| Brain-Computer Interface (BCI) | Device | `&"device.bci"` | |
| Satellite Uplink | Device | `&"device.satellite_uplink"` | Satellite Communicator |
| Material Printer | Device | `&"device.material_printer"` | |

## World

| Term | Code name | Replaces |
|---|---|---|
| Badlands | `Biome.BADLANDS` | Gobi (general badland) |
| Salt Flats | `Biome.SALT_FLATS` | Saline-Alkali |
| Desert | `Biome.DESERT` | |
| Volcanic Fields | `Biome.VOLCANIC` | Volcano |
| Snowfield | `Biome.SNOWFIELD` | |
| Oasis | `Biome.OASIS` | |
| Point of Interest (POI) | `PointOfInterest` | points of interest |
