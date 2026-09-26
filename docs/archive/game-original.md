# Game Design Document

## Project Overview

- A semi-sandbox, semi-open-world game with fixed regions, fixed map content, and a high-freedom main storyline (mainly intended for tutorial and gameplay introduction), gameplay primarily focused on vehicle construction/combat and world exploration, with a minimalist progression system, and an emphasis on visual and auditory feedback: a vehicle construction + simulated combat + real-time strategy/tactics game.
- The world map is divided into four regions. The player always spawns in Region 1. Region 1 connects to Region 2. Region 2 branches to Region 3 and Region 4.
- The main perspective is third-person top-down/surround view (vehicle construction and interaction, combat, exploration), with a small amount of first-person view (entered during manual override) and free camera view (available after unlocking the free camera).
- The world setting is similar to the novel *Mortal Engines* and its film adaptation: a post-future-war apocalyptic-style scene (main color palette: desert orange-yellow / saline-alkali gray-white / volcanic ash black, with a small amount of high-saturation, high-brightness green and other colors), with content elements conveying a sense of technological discontinuity.
- The player character is initially set as an embodied intelligent agent (robot), with only basic knowledge capability. The setting is: when the protagonist was at factory settings, the war began and data transmission was interrupted, so the protagonist only has basic theoretical knowledge and near zero applied technical knowledge.
- The protagonist will act as a vehicle architect and commander, building or modifying vehicles on their own, freely exploring the map (the map is semi-randomly generated: quest points and biome types/counts are fixed; map boundary shape, area size, and point-of-interest distribution vary slightly according to randomness; or it may be a completely fixed zoned map, TBD), completing main storyline tasks, and unlocking new technologies and buildable vehicle size/tonnage scales.

## Core Game Positioning

Main single-player PVE + small-scale PVP indie game, stylized (primarily hard-surface, polygonal elements) / semi-realistic (the level of realistic detail is at most *The Legend of Zelda: Breath of the Wild* level, leaning toward *Iron Nest*). Supports small-scale local multiplayer functions (multiple vehicles in local multiplayer / multiple players cooperating on a single vehicle, TBD). Right now, prefer polygonal elements + pixelated art + realistic lighting & texturing

## Core Gameplay Loop

One-sentence summary: build vehicles, explore the map, battle, upgrade.

### One-Time

- Normal Mode: basic vehicle construction/operation tutorial, operating vehicles to explore world scenes, completing main-story battles, unlocking all basic technologies, understanding the worldview and story. When unlocking specific technologies and/or corresponding items, some trigger minigames such as knowledge quiz Q&A and/or puzzles; completing them unlocks the content (no penalty, unlimited attempts). Some technologies, such as Organic Chemical Engineering, have multiple unlock stages, each stage with different questions or puzzle content.
- After completing the main storyline, the world map randomly refreshes advanced challenge scenes/NPCs (or expedition mode: entering a new map/dimension with limited resources, similar to Terraria hardmode, etc.), allowing advanced technologies to be unlocked. If the fixed map content plan is adopted, each map region has its own main storyline content and ending, as well as unique resources and/or technologies.
- Casual (Creative) Mode: infinite resources, instant builds and crafts, all types of technologies/materials, etc. are available; players can freely explore gameplay, strategies, maps, etc.

### Short-Term Repeatable

- NPC/PVE interactions: randomly spawned neutral or hostile NPCs: hostile NPCs can be defeated to farm resources, or resources can be traded with neutral NPCs. Specific NPCs may probabilistically unlock content or resources that cannot be obtained in the main storyline / that exceed the current main storyline progress.
- Map exploration and resource gathering. Crafting materials and basic currency refresh randomly at intervals. After reaching specific main storyline progress, the wreck salvage gameplay is unlocked.
- Escort missions: transporting specific supplies/valueables/commodities, etc. to specific locations (implemented by installing specific, mandatory modules on the vehicle), obtaining special rewards or unlocking specific content.
- Farm: timed production of basic resources (such as fuel and other materials).
- Built-in minigames: zero pressure; different minigames allow players to farm corresponding types of crew experience to improve the performance of specific vehicle crew groups. They can be played many but limited times within a period, and refresh on a timer.
- leave interfaces/sockets for potential multiplayer functions (likely left for the community to do)
- Blind Box Mechanic: the player can consume a certain amount of materials for trial production, with a low probability of unlocking the technology or item corresponding to a key item without having obtained that key item. If successful, the technology is permanently unlocked and does not require the key item. After obtaining certain key items / encountering certain NPCs / going through certain battles, the trial production success rate of other related but not-yet-unlocked technologies increases. For example: if another NPC vehicle or hostile vehicle is equipped with a certain weapon, each time the player engages the NPC or enters a target-acquisition state, etc., the trial production success rate slightly increases; or collecting certain items at points of interest, etc. This success rate has a stacking cap.

### Long-Term Repeatable

- Vehicle construction, modification, uploading blueprints to the game’s built-in player community, and downloading blueprints from the community. Before uploading, the player must operate the vehicle to pass several specific verification benchmark tests. The scores of each test are calculated into panel attributes according to specific rules. The community has filtering rules to facilitate searching for vehicles, and has an automatic algorithm that determines vehicle role and categorizes/stores vehicles based on blueprint panel attributes. The form is similar to the *SimplePlanes* works community. (TBD, investment unknown)
- Multiple possible endings based on side quest completion.

## Detailed Mechanics and Systems

### Vehicle Combat: Main Parts Involved in Damage Judgment/Resolution and Their Judgment Mechanisms

#### Vehicle Chassis

- Divided into different types. Different types of chassis have different parameters/properties and power type compatibility. Current parameters: mass, center of mass, HP/durability (HP/durability is usually high, resistance is usually high, can be destroyed), kinetic/explosive/chemical resistance; kinetic/explosive/chemical protection level. Additional parameters: transmission efficiency (real number between 0 and 1, used to multiply the power from the prime propulsion unit to determine actual drive power); rated load (load factor: determined by actual load mass divided by rated load mass. The load factor is used, together with actual drive power and terrain resistance coefficient, to calculate the achievable forward/reverse/steering top speed under those conditions, and the acceleration achievable to reach that top speed; function model TBD); four resistance coefficients on water/soft/medium/hard terrain.
- To improve the realism of running gear feedback, it is expected that each running gear applies force separately. Each running gear’s force output is determined jointly by its actual drive power, load factor, and terrain resistance. This force output divided by vehicle mass gives acceleration. (The specific mechanism algorithm is TBD; the above mechanism may fail to correctly simulate vehicle operation on low-friction surfaces.)
- Each running gear has an independent HP/durability value. When HP/durability is depleted, that running gear is judged destroyed. A decrease in running gear durability causes some of its numerical values to change (such as transmission efficiency and resistance coefficients).
- Running gear comes with a certain area of mounting platform. The running gear’s suspension must participate in physics simulation, used to simulate feedback effects such as hits on the vehicle’s upper structure and weapon recoil.
- Some running gear has a modification system. After applying a specific modification, it becomes a variant of that running gear, inheriting all original properties while parameters change. The variants of each running gear form a tech tree. Each variant can be unlocked by obtaining blueprints/key progress items. A variant can be crafted directly or obtained by adding materials to the base model.

#### Power System

- prime propulsion unit: functions to drive running gear, power relay nodes, or weapons. Currently divided into external combustion engine (steam engine), internal combustion engine, internal combustion engine hybrid electric drive, nuclear power, and special types. The prime propulsion unit type determines the base fuel type it consumes and the output energy type. If used to drive running gear, the target running gear must be within its drive range (sphere-like or orthogonal hexahedron). Specific types of prime propulsion units have mandatory attachments, such as fuel tanks (orthogonal hexahedron shape, volume determines fuel capacity, inherits all prime propulsion unit parameters) and exhaust pipes. Both must directly contact the prime propulsion unit. When driving running gear, power is distributed to determine power-to-weight ratio, top speed, steering, etc.; it can also directly supply corresponding weapon types. When a prime propulsion unit directly supplies a weapon, it must be connected to the weapon by a delivery pipe; supplied power decays with distance, and the type must match the weapon. Currently there are two ranges: running gear/weapon drive range; mass, center of mass; HP/durability; Boolean operating state; hit failure rate (a variable with an initial value, increasing as durability decreases. Each time it is hit, a check is made; if failure is determined, it stops operating; if failure is determined while overheated + operating, it is directly destroyed); kinetic/explosive/chemical resistance; kinetic/explosive/chemical protection level; overheat temperature; meltdown temperature; damage type/range after destruction, etc. Additional parameters: fuel consumption rate; output power; noise.
- The same prime propulsion unit can have different variants. Each variant has different parameters, such as fuel/output energy type, noise level, output power, etc.
- Power Relay Node: functions to receive energy from the prime propulsion unit, expand power supply range, convert energy type, and supply weapons. Divided into electric, thermal, and surreal/exotic three types. Thermal and electric are mutually compatible (e.g., a thermal engine can supply a thermal engine or electric motor, and vice versa). It connects to the prime propulsion unit through power delivery pipes. It consumes part of the prime propulsion unit’s power x, and can itself output power kx; kx does not exceed the maximum output power P. Its role is to supply weapons. It inherits all properties/parameters of the prime propulsion unit, but generally has lower HP and higher destruction damage.
- Power Delivery Pipe: functions to directly connect prime propulsion units, power relay nodes, and weapons. According to the transmitted energy type, it is divided into electric, thermal, and special. Under each category there are further subdivisions by material/performance. HP/durability does not change its performance parameters; when depleted, it is directly destroyed (cutting off energy supply). It inherits most parameters of power modules (various resistances, HP/durability, Boolean operating state, overheat temperature (judgment effect same as prime propulsion unit)), usually has lower HP/durability, and like other power modules has destruction damage; the damage type and value are related to the pipe category and subdivision. Additional parameters: power loss rate (positive integer, used to multiply pipe path length to calculate power loss, and deducted from input power).
- Exhaust Pipe: applicable to specific types of prime propulsion units. One end directly connects to the prime propulsion unit; the exhaust end must be in an open/semi-open space. The exhaust pipe inherits all parameter types of pipes, with destruction damage of zero. Additional parameters: exhaust efficiency. Exhaust efficiency \(= \min\{1.15, 0.8 + \text{exhaust height coefficient}\}\). Exhaust height coefficient: in the construction interface, determined by the z-distance between the exhaust pipe’s exhaust end and the vehicle bottom. Exhaust efficiency is used as a multiplier to calculate the prime propulsion unit’s actual output power.

#### Weapon System

Current weapon types:

- Projectile Type (traditional artillery, including direct fire and indirect fire (i.e., mortars), can load different ammo types to achieve different damage types and effects. Depending on weapon type or variant, powered by electric energy or thermal energy. Has low-power operation and overclock operation properties: in low-power operation, rate of fire decreases, with a lower limit; after overclock, rate of fire increases, while fire-control parameters decrease. Current ammo types: general kinetic projectile, high-explosive charge projectile, cluster high-explosive projectile, chemical charge projectile, cluster chemical charge projectile)
- Non-Contact Type (such as matter wave (matter wave damage, can have low-power operation and overclock properties), flame or laser, etc. (energy damage; flame after modification can also have chemical damage), generally has low-power operation and overclock properties)
- Mobility Restriction Type (such as destroying running gear (explosive and/or kinetic damage), area change of terrain resistance, etc. This type of weapon requires no power supply, but uses are extremely limited)
- Interference Type (reduces enemy specific weapon target-acquisition efficiency and other parameters, no damage)
- Superweapon Type (usually has multiple stacked damage effects and/or large area and/or high numerical damage. Features include extremely limited uses and/or extremely high power demand and/or extremely long cooldown, etc. Laser and matter wave are considered to belong to this category)

Current damage types:

- Kinetic (small, no damage falloff line or cylindrical resolution range. Range determined jointly by projectile caliber/object size and initial velocity (if the range is a cylinder, cylinder diameter is related only to the projectile’s own parameters, while cylinder length is related to both projectile parameters (i.e., kinetic penetration level) and armor parameters (kinetic protection level)). Deducts HP and durability, effective against both armor and adhesive within range. Damage is resolved by direct object hit; damage function follows the kinetic energy formula.)
- Explosive (larger, spherical resolution range with radial damage falloff (or can maintain constant no falloff, TBD). Resolution range size is determined by the weapon’s explosive penetration level and the target’s explosive protection level. Deducts base HP and durability. Falloff coefficient formula is \(\max \{0, (1 - x / R)\}\). Has property: overpressure. Within the damage resolution range there is a pressure field whose attenuation model is the same as damage falloff: in regions where pressure is higher than adhesive strength, all adhesive directly fails, and associated armor directly falls off. Overpressure judgment priority is higher than kinetic and explosive damage.)
- Matter Wave (can dynamically adjust emission frequency within a fixed range to adapt to different protective materials. Different matter wave weapons and their variants have different frequency ranges and maximum effective ranges. Has property: resonance. When the frequency is within the resonance band of the armor and/or adhesive and the target is within effective range, continuously deducts a large amount of durability from the affected object; the deduction rate is positively correlated with power density at the point of action. If the frequency is not within the resonance band, no damage is resolved. Power density: determines the distance from emission source to affected object along the ray; power density decays along distance. Damage resolution only applies to the first object touched by the ray, i.e., there is no penetration effect. Each time the player adjusts frequency, the weapon has a restart delay. The closer the current frequency is to the target’s resonance frequency, the more audio feedback is given (such as pitch rising or loudness increasing, etc.). This weapon can cooperate with recon skills and whether the affected object’s material has been unlocked to give the player hints, such as marking the resonance frequency band.)
- Energy (Flame: damage resolution range is a sphere centered at the first intersection point of the firing direction vector and the affected object; sphere radius is propulsion to distance within range; damage within range has no falloff and continuously deducts a small amount of HP and durability. Has property: overheat. Each weapon’s maximum temperature value differs. Within the resolution range there is a heating rate field; heating rate decays linearly along the radius. When temperature exceeds the affected object’s overheat temperature, greatly reduces the affected object’s kinetic/explosive/chemical resistance, or directly greatly increases the corresponding damage resolution multiplier; if temperature exceeds meltdown temperature, ignores HP/durability and directly determines destruction. For prime propulsion units, power relay nodes, etc., when temperature exceeds their overheat temperature and they are operating, even without being hit, hit failure rate checks are performed at the game tick interval used for being hit; if failure is determined while overheated, they are directly destroyed. Laser: damage resolution method is the same as flame; resolution range is a fixed-radius sphere; heating rate field values are higher than flame; heating rate falloff mode is the same.)
- Chemical (fixed-radius spherical ray model; generates several detection rays evenly spaced in solid angle and equal in length (length equals the resolution range sphere radius). For rays that can reach the affected object, their action depth is determined by the affected object’s chemical protection and the weapon’s chemical penetration, similar to the Beer-Lambert light absorption model; specific formula TBD). Over a period of time, deducts HP and durability at a lower constant rate. Has property: synergy. Raw damage dealing rate is positively correlated with the affected object’s temperature; function model TBD.)

Modifications: Some weapons have a modification system. After applying a specific modification, they become a variant of that weapon, inheriting all original properties while parameters change. The variants of each weapon form a tech tree. Each variant is unlocked by obtaining a blueprint. A variant can be crafted directly or obtained by adding materials to the base weapon. Changed parameters include but are not limited to: whether low-power operation is possible (Boolean), whether overclock operation is possible (Boolean), HP/durability, damage type, damage value, etc. Specific parameters refer to weapon category subdivisions.

Power supply: Weapon type determines the required energy type; some weapons can run at low power or overclock based on supplied power. Currently, weapons themselves do not have the function of converting energy type.

Weapon Entity: The vast majority of weapons have a body and an ammo storage. Both inherit most properties and parameter types of general armor (various resistances/protection levels; HP/durability; Boolean operating state; overheat temperature). Projectile weapons additionally have parameters: muzzle velocity (participates in calculating flight trajectory, range, and kinetic damage); deviation angle (used to determine deviation when the projectile leaves the barrel); recoil (participates in simulation); noise (participates in concealment calculation). Currently, laser, matter wave, and other weapons have a minimum operating power threshold; below that threshold they cannot work. Projectile weapons only have rated power; they can also run at low speed without power supply, and over-power can increase rate of fire and increase deviation angle. Some weapon entities and/or their ammo storages have damage effects similar to relay node destruction when destroyed. The performance improvement/degradation judgment model for weapons with low-power/overclock operation functions is a constant piecewise function. The independent variable for judgment is power ratio (supplied power divided by rated power).

#### Armor System

- Armor: used to withstand damage. Currently all armor units have the following parameters/properties: unit density, center of mass, fill rate, HP/durability (positive integer), kinetic/explosive/chemical resistance (positive real number; during damage resolution, raw damage is divided by this value to achieve a multiplier effect; kinetic/explosive/chemical protection level: independent of resistance, and together with the weapon’s penetration capability determines resolution range); overheat temperature, heat capacity (positive real number; during heating judgment, heat capacity is subtracted from the heating rate to obtain the final heating rate; and after heating stops, determines cooling rate). Additional parameters: fill rate (the amount of material required for crafting and armor unit mass are determined by volume and fill rate). The resonance frequency of non-fully-filled armor units changes with fill rate, and cannot be hinted by recon skills.
- Adhesive: used to connect armor units. It has no collision and no physical volume, but is still treated as an entity when participating in ray detection. It is attached to up to three faces of each armor unit; those three faces have constant orientation. It is used to determine the connection state and connection relationship between armor units. After the vehicle is formally deployed, if an armor unit has no connections, it is automatically judged as a general dropped object and participates in physics simulation. On the basis of inheriting most armor unit parameter types (various resistances, HP/durability), it additionally has parameters: resonance frequency, strength, compatibility (positive real number; looked up by enumerated type according to different adhesives and different bonding objects; used to multiply strength. When adhesive on each face participates in strength judgment, strength is recorded as the lower strength side of the two sides of that adhesive).
- Truss: used to interconnect armor units/weapons/running gear. It is similar to adhesive and inherits all adhesive parameter types, but has collision/physical volume, and has unit volume mass; its compatibility parameter with any material is always 1. It has multiple types with different parameters/performance depending on material. Like armor units, it is forced to be an orthogonal hexahedron, and its dimensions can be freely adjusted with a finite minimum step.

#### Concealment System

- A fixed number of observation points can be placed on the vehicle surface, used to emit detection rays. Players can customize observation point placement. Observation points can be destroyed.
- All observation points share one game tick time; every specific number of game ticks, detection rays are generated once. A single observation point generates a fixed number of fixed-length detection rays distributed evenly in solid angle. Rays can be blocked by specific objects. The maximum ray length is maximum vision. The maximum distance at which a target can be detected is actual vision. The distance from observation point to target point is target distance.
- If a single detection ray touches a target, actual vision is calculated according to the concealment coefficient at the contact point, and actual vision is compared with target distance. If actual vision is greater than target distance, that ray is judged to have successfully detected. Actual vision formula: maximum vision - (maximum vision - forced acquisition vision) * (concealment coefficient - noise coefficient). Forced acquisition vision: when enemy and friendly distance is less than forced acquisition vision, both sides remain in a successful acquisition state regardless of whether ray detection succeeds.
- Noise penalty: when weapons fire / specific components operate / specific judgment conditions are met (such as turning on a searchlight at night), the penalty accumulates in the noise coefficient and participates in vision calculation. The noise penalty for firing at night or turning on a searchlight at night is greatly increased compared to daytime.
- When a ray is judged to have successfully detected, it is judged as successful target acquisition. Recon crew proficiency can affect reconnaissance capability.
- Target acquisition and attack desire: enemies judge based on their own vehicle rating and the player vehicle rating, performance, etc., and/or the components/cargo the player vehicle has: when target acquisition succeeds, the behavior mode adopted, such as fleeing, neutral, or hostile.
- Night conditions greatly reduce the vision of all vehicles that do not have night vision equipment.

#### Crew System

Crew system:

- A vehicle can carry multiple different crew cabins. Their role is to slightly improve crew values, similar to ventilation equipment in *World of Tanks*; at the same time, crew cabins can be equipped with a limited number of consumables, providing additional bonuses or resistances (such as reducing crew efficiency effects from heat, radiation, etc.).
- It is allowed not to carry a crew cabin; the effect is no crew efficiency bonus.

#### Logistics System

Logistics system:

- After unlocking Control Theory and Satellite Communicator, the player can independently produce basic-model logistics stations and ground transport vehicles (these vehicles are independent entities, only executing basic automatic pathfinding between stations according to programs specified by the player, and participating in damage judgment from player and hostile vehicles); after additionally unlocking Aeronautics, the player can independently produce and build basic-model transport aircraft and their variants.
- Some ground transport vehicles and transport aircraft have multiple modules. Each module has multiple variants. Different variants can affect various parameters of the vehicle/aircraft (such as unit energy consumption, speed, etc.) and the types and quantities of materials required for manufacturing. Before manufacturing, the player must select all module variants one by one.
- Blueprints for other models of ground transport vehicles and transport aircraft can be obtained from specific NPCs. Blueprint vehicles usually do not have modular modification properties, but their overall performance is superior to independently producible/manufacturable models and their variants.
- Ground transport vehicles/transport aircraft respectively have corresponding transport nodes. A single node has vehicle manufacturing/repair functions. Its function is to manufacture and repair transport vehicles and player vehicles (materials required are measured according to degree of damage), and at the same time provide various supplies to player vehicles (including operable AI vehicles), such as fuel, ammunition, etc. Each node can choose to be equipped with multiple types of storage units, and the quantity can be selected, to increase storage capacity.
- Transport nodes can be equipped with observation posts and defensive facilities to deal with randomly refreshed supply plunder events. The weapons used by defensive facilities are part of the vehicle weapon series. After unlocking Wireless Communication Technology, the player can remotely manually operate weapons within the node.
- The map will contain regions of different risk levels. Building logistics nodes in regions of different risk levels has different probabilities of triggering different random events.

#### Miscellaneous

Fast-forward function:

- In most situations in the game, such as long-distance travelling, the player is allowed to fast-forward to save time.
- During fast-forward, event judgment still participates; specific events will force exit from fast-forward state.

Salvage module:

- Usually installed on the front of the vehicle, used for wreck salvage.
- Can cause low, continuous kinetic damage.
- Salvage module size determines item collection rate, damage per second, etc.

Collision and crushing:

- Physical contact between the player vehicle and other non-friendly vehicles produces collision damage, type kinetic; specific damage values and mechanisms TBD.
- Crushing: if two vehicles whose own level and running gear level both differ by 2 levels or more collide, the lower-level vehicle receives high-multiplier damage.

Season system (TBD):

- Main effects are changing crop maturity speed, probability/duration of various weather, some environmental colors, and other entity damage (TBD).

## Vehicle Construction: Components and Construction Rules

### Basic Construction Tools

- Batch selection (can hold a specific key such as Ctrl and left-click with the mouse for multi-select, or create a resizable, movable cuboid selection area for clipping selection), copy-paste, undo and redo.
- Module save/load: save selected content as a preset module; recall preset modules.
- Mirror operation: place 1-2 mirror planes; operations on one side of the plane are automatically synchronized to the other side.
- Decal drawing/saving: similar to a paint interface; players can select paints, customize 2D appearance elements, and save them (TBD, risk point exists).
- Blueprint save/load: save all content in the current work area.

### Power

[left blank]

### Weapons

- Usually includes a weapon body and an ammo storage. The ammo storage is a rectangular cuboid with adjustable dimensions (has minimum and maximum volume, and minimal adjustment step size). Weapons and ammo storages are not forced to be placed in pairs during vehicle design. Players can separately place weapons and ammo storages, then select a weapon and the ammo storage bound to it. A single weapon can bind at most 2 ammo storages; the order of clicks determines order of use.
- Ammo storage volume determines maximum ammo capacity; the straight-line distance between its center and the corresponding weapon’s center determines reload speed bonus/penalty.

### Armor

- Each armor unit must be an orthogonal hexahedron, and its maximum and minimum edge lengths and total volume are limited according to game progress. Length, width, and height dimensions can be adjusted through a finite step (with a minimum step size). Adjustment method: when in adjustment mode, click to select a free face, then use the scroll wheel or drag to adjust size along that face’s normal direction, while other faces remain unchanged; a free vertex can also be selected to change multiple dimensional sizes simultaneously. can reference the adjustment operations of the minecraft mod called axiom.
- Initially, basic armor, trusses, and adhesive are all unlocked. Adhesive usage is propulsion to bonding area.
- After unlocking the Material Printer, armor fill rate can be adjusted. Armor unit material consumption is calculated according to fill rate and volume.
- The Material Printer can change armor unit surface textures without changing other attributes.
- Each armor unit can undergo chamfering (square/circular/asymmetric square) operations. Chamfer size is limited according to armor unit edge length. Chamfering does not change any armor unit parameters, including collision body.

### Appearance

- From early to mid-game progress, paints and text decals can be unlocked along with the introduction of the concealment mechanism.
- Different paints have different attributes, usually with parameters: concealment coefficient under various biomes and/or climate conditions (positive real number, used for detection ray).
- Paints/specific appearance attachments/ornaments, etc. have parameter: camouflage coefficient. For the components they cover, it can reduce the probability that the enemy uses recon skills to learn information about one’s armor, weak points, etc.
- Appearance elements such as ornaments/attachments are gradually unlocked after completing specific tasks, exploring specific points of interest, and salvaging specific wrecks.
- After unlocking the Material Printer, the appearance (texture) of armor units made with it can be changed.

### Additional

- When the blueprint is determined and production/construction begins, each part and component must first be manufactured and then assembled. The connection relationships and energy distribution among the various production units of the production/construction base are generated by a simple default algorithm, and the player is also allowed to manually optimize at any time.
- The production/construction base has a simple management-sim/factory production-line optimization gameplay: energy supply such as electricity is limited, and factors such as power and production unit level restrict the rate at which each unit produces parts. Another idea: the maximum scale and functions of each area of the player’s production base are completely fixed. As the game progresses, the player can unlock more areas and selectively invest resources as needed to upgrade areas with different functions, improving overall production capacity. (whether this serves as a separate gameplay is tbd. maybe it would just appear as a progressive unlocking process, where the player can choose what sectors to unlock based on the current situation)
- If production-line/management-sim gameplay is adopted, the optimization gameplay is in the form of drag-and-drop pipeline programming on a 2D plane.
- TBD feature: vehicle design and construction are carried out in two independent interfaces/systems. The design interface has a minimalist art style, with rendering similar to blueprints/wireframes, no lighting/shadow effects, etc.; the construction process can involve simple, procedural animation demonstrations, such as production line operation, automatic component assembly, etc.

### Community

Form similar to *SimplePlanes* (TBD).

### Vehicle Operation: Input Methods, Operable Quantities

[left blank]

## Human Crew Progression: Categories and Stage Bonuses

### Propulsion

- Propulsion system hardware performance bonuses, such as power, HP/durability, failure rate, etc.
- Maneuverability bonuses, such as power climb rate (acceleration).
- When crew reaches a specific level, if the prime propulsion unit is judged to have failed while overheated + operating, the destruction is converted to shutdown.

### Maintenance

- This crew group is bound to a fixed-size component (maintenance room). This component inherits most armor attributes; its size and parameters change with crew group level (currently its size increases synchronously with level).
- The maintenance room has an effective range. One crew group can only affect a specific number of components within a specific range.
- It improves the HP of specific components and gives certain speed of HP/durability recovery to specific resistances. Recovery rates for each associated component can be allocated by operation. When reaching a specific level, it can make all components it affects exempt from one destruction judgment.

### Recon

- Learns partial enemy configuration information beyond visual range, mainly armor, weapon, and power information. This function is implemented as a skill with cooldown. The skill effective range is consistent with maximum vision range. Each use of the skill —
- Maximum vision range can increase with crew level (has an upper limit).
- When crew reaches a specific level, there is a probability of learning the region where enemy weak-point components are located.
- Recon crew proficiency can provide a small bonus to night target acquisition.

### Salvage

- When carrying this type of crew, friendly units lost in battle have a probability of being partially returned as raw materials at settlement (excluding consumables such as ammunition/fuel). At the same time, destroyed enemy units also have a probability of dropping crafting materials.
- If the vehicle carrying this crew is completely destroyed in battle (command room destroyed), the return does not take effect.
- Crew level increase raises return probability and proportion.
- When crew reaches a specific level, there is a probability of directly returning the original unit, and even when the vehicle is completely destroyed, part of the materials can still be returned.

### Weapons

- Before Control Theory is unlocked, all weapon operation must be equipped with crew.
- Crew proficiency correspondingly improves weapon parameters, including but not limited to reload speed, target acquisition accuracy/speed, etc.
- Each crew group can only operate a single weapon and its variants. If switching to another weapon of the same type or a different type of weapon, proficiency (level) is reduced by a certain proportion. One crew group can maximize operation proficiency for all weapons. As the number of operable weapons increases, the time required to reach maximum proficiency or the minigame score required increases accordingly.
- When crew reaches a specific level, it can exempt one instance of weapon and/or ammo storage destruction damage.
- Each weapon can be equipped with at most two crew groups. One group is the crew operating the weapon; the other group is additional carried crew. Both the weapon-operating crew and additional carried crew can increase proficiency according to the weapon’s operating time (i.e., total time the weapon executes player commands).

## Environment (Biome)

### Volcano

- High temperature: slowly raises the temperature of all components with temperature attributes.
- Direct debuff: reduces the success rate of specific categories of prime propulsion units, increases the power loss rate of pipe transport, increases the deviation angle of specific categories of weapons.
- Mainly hard terrain; lava areas are medium/soft terrain (affects running gear terrain resistance).
- Has event: volcanic eruption. Some magma areas are generated on the surface, with flame-type damage; at the same time, rocks that cause kinetic damage randomly fall from the sky.

### Desert

- Terrain resistance is relatively large; medium/soft terrain.
- When weather is clear, it reduces the concealment coefficient of all vehicles in that environment to a certain extent; this effect can be offset by specific appearance elements.
- Has event: sandstorm. Greatly reduces the vision of all vehicles in that environment.

### Gobi (General badland)

- The environment of the player’s initial region. Only basic weather such as clear/overcast/rainy.
- Hard terrain, low terrain resistance.
- Has more destructible terrain and cover.

### Saline-Alkali

- Quasi-flat terrain, hard terrain.

### Snowfield

- Has hard/medium/soft terrain simultaneously.

### Oasis

- Set as a human functional crop planting area. Specific functional crops can be obtained, enabling the player base to independently produce crops. After unlocking Organic Chemical Engineering technology, corresponding industrial raw materials can be produced, including but not limited to various fuels, minerals, and other consumables.
- All medium/soft terrain, high terrain resistance.
- Specific areas provide relatively high concealment bonus.

## Points of Interest: Currency: Item Resources: Random Weather

[left blank]

## Level/Flow/Content Structure

[left blank]

## Key Progress Items: Can Unlock Specific Functions/Items or Provide Bonuses

### Internal Ballistics

- Unlocks propellant improvements for projectile weapons: can change multiple weapon parameters, such as reload time, initial velocity, deviation angle, etc. Also affects firing noise penalty.

### External Ballistics

- Unlocks various projectile variants (by default only homogeneous armor-piercing and ordinary high-explosive are available). Variants include but are not limited to hard-core armor-piercing, shaped-charge, armor-piercing high-explosive, squash-head, and other charge projectile types.

### Control Theory

- Unlocks automated control technology.
- Gives projectile weapons overclock attributes.
- Allows all weapons to acquire targets according to player commands without crew (does not conflict with the crew system; having crew can additionally improve parameters or obtain other bonuses).

### Garbage Classification Manual

- Unlocks wreck salvage gameplay.
- Unlocks resource gathering from garbage gameplay.

### Element Analyzer

- Directly learns the types and quantities of materials that can be extracted from salvageable wrecks.

### Wireless Communication Technology

- Allows vehicles equipped with a Brain-In-A-Vat to receive and obey player commands.
- Allows the player to remotely operate logistics node weapon stations and temporarily change transport vehicle/aircraft routes and destinations.

### Additive Manufacturing Technology

- Unlocks fill rate option: consume fewer materials and achieve equal or slightly inferior parameter performance at lighter weight.
- Unlocks independent manufacturing of composite materials.

### Computer Vision

- Combined with Control Theory, unlocks autonomously target-acquiring suicide ground swarm technology.
- Combined with Control Theory and Aeronautics technology, unlocks autonomous drone swarm technology.

### Electromagnetics

[No content in source.]

### Wireless Power Transmission Technology

- Allows electric-type prime propulsion units or relay nodes to supply specific components without pipes, but power still decays with distance.

### Aeronautics

- Unlocks independent production/manufacturing capability for basic-model fixed-wing aircraft (including swarm drones).
- Unlocks independent production/manufacturing capability for basic-model multirotor aircraft.

### Organic Chemical Engineering

- Unlocks technology to convert organic waste into fuel and other raw materials.
- Unlocks lightweight materials suitable for logistics transport vehicles.
- Unlocks technology to convert various functional crops into fuel and other materials.
- Unlocks specific item synthesis (can serve as high-value currency or side content prerequisite).

### Special Metal Materials Technology

- Unlocks more advanced metal materials for weapons/armor, etc. in stages.

### Holographic Instrument

- Unlocks community vehicle upload/download gameplay.

### Ballistic Computer

- After unlocking, improves target acquisition accuracy of all friendly weapons, and simultaneously displays enemy weapon impact point ranges in real time.

### Night Vision Device

- Unlocks night vision function, and greatly improves the player vehicle’s night vision.

### Brain-In-A-Vat

- Unlocks automatic cooperation of multiple vehicles; vehicles other than the player’s vehicle are all autonomously controlled by AI.
- One such item can only affect one AI-controlled vehicle. After unlocking Wireless Communication Technology, AI-controlled vehicles can obey player commands and cannot be manually overridden in first person.
- The number of coordinated units has relatively strict limits.

### Brain-Computer Interface

- After unlocking, running components can be overridden, and all mandatory delays of dispatch commands are eliminated.
- Can link with the Holographic Instrument to synchronously view various vehicle information in real time, such as weapon loading state and component damage.

### Satellite Communicator

- Unlocks minimap function: unexplored areas have weak hints such as outlines and icons.
- The minimap also includes real-time regional weather information.

## NPCs and AI Enemies

[No content in source.]

## Scene and Asset Requirements

### NPC and Other Figures

- Similar to incomplete drafts / edge extraction / threshold-filtered images, expressing the effect of an AI vision module preprocessing images.

### Vehicle-Related Items (Armor, Weapons, Running Gear, and Other Components)

- Vehicles are divided by tonnage (tonnage also corresponds to 3D dimensions and upper limit of part count) into T1 to T6, six levels. T1 is about 10 meters / 50-ton class; T2 about 25 meters / 250-ton class; T3 about 50 meters / 1000-ton class; T4 about 100 meters / 5000-ton class; T5 about 150 meters / 10,000-ton class; T6 about 200 meters / 40,000-ton class. The tonnage/part count corresponding to dimensions is TBD.
- Running gear levels are consistent with vehicle tonnage levels. Under each level there are about 3-5 different models. Each model has 1-4 variants. Some variants include a small amount of appearance/sound/effect changes. Running gear should include basic suspension physics feedback and a small number of additional moving parts with physical effects, such as chains. All models resembling moving parts should participate in physics simulation to ensure continuity and realism.
- Indirect-fire weapons (mortars) become available when vehicles reach T2 level. They are divided into 5 levels. Under each level there are 1-3 models. Each model includes 1-4 variants. Some variants include a small amount of appearance/sound/effect changes. They should have loading mechanism models and animations; the connection between the loading mechanism and ammo storage should be a procedurally connected animated component.
- Direct-fire artillery: includes rapid-fire (autocannons) and general artillery. Autocannons have only 3 levels; each level has 1-3 variants. General artillery is divided into 5 levels; under each level there are 1-6 models; each model has 1-4 variants.

## Art and Sound Specifications

[No content in source.]

## Technical Implementation Requirements

[No content in source.]

## Acceptance Criteria and Items to Confirm

[No content in source.]