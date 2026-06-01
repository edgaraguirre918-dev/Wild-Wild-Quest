# Wild Wild Quest

A roguelike game combining **Animal Crossing-style town management** with **Darkest Dungeon-inspired tactical adventures**.

## Game Concept

- **Town Management**: Build and grow a medieval town with various buildings
- **Guild System**: Recruit and manage a guild of adventurers
- **Quest System**: Send parties on dangerous quests to dungeons
- **Character Rescue**: Save NPCs from dungeons who can become townsfolk or join your guild
- **Progression**: Expand your town and enhance your guild over time

## Technical Stack

- **Engine**: GameMaker 2024
- **Resolution**: 16x16 pixel art sprites
- **Target Platform**: Desktop (extensible to other platforms)
- **Language**: GML (GameMaker Language)

## Project Structure

```
scripts/
├── systems/              # Core game systems
│   ├── global_managers.gml
│   ├── town_system.gml
│   ├── guild_system.gml
│   ├── quest_system.gml
│   ├── combat_system.gml
│   └── character_system.gml
├── utilities/            # Helper functions
│   ├── data_manager.gml
│   ├── save_load.gml
│   └── debug_tools.gml
├── data/                 # Game data definitions
│   ├── character_data.gml
│   ├── building_data.gml
│   ├── quest_data.gml
│   └── item_data.gml
└── ui/                   # UI management
    ├── ui_manager.gml
    └── ui_elements.gml

sprites/
├── characters/           # 16x16 character sprites
├── tiles/                # Map tilesets
├── ui/                   # UI elements
└── effects/              # Particle effects

rooms/
├── rm_main_menu
├── rm_town
├── rm_guild_hall
├── rm_quest_dungeon
└── rm_combat

objects/
├── obj_game_manager      # Persistent game state
├── obj_player_character
├── obj_npc
├── obj_building
└── obj_enemy
```

## Development Phases

### Phase 1: Core Architecture & Town System
- Global game manager setup
- Town building system
- NPC spawning and basic AI
- Save/load system

### Phase 2: Guild & Character System
- Adventurer creation and management
- Character stats and progression
- Equipment system
- Character class definitions

### Phase 3: Quest & Dungeon System
- Quest generation
- Dungeon procedural generation
- Turn-based combat mechanics
- Loot and rescue mechanics

### Phase 4: Polish & Optimization
- UI refinement
- Performance optimization
- Audio integration
- Balance adjustments

## Getting Started

1. Clone the repository
2. Open in GameMaker 2024
3. Run `Create` button to initialize the game
4. Check console for debug information

## Development Notes

- All systems are modular and can be developed independently
- Save system is JSON-based for easy debugging
- Combat uses turn-based mechanics for strategic depth
- Town generation is data-driven via GML structs

---

**Lead Developer**: @edgaraguirre918-dev  
**Status**: Early Development
