/// @description obj_game_manager - Clean Up Event
/// Clean up all systems before game closes

// Clean up all global systems
cleanup_town_system();
cleanup_guild_system();
cleanup_character_system();
cleanup_quest_system();
cleanup_combat_system();
cleanup_save_system();

show_debug_message("========================================");
show_debug_message("WILD WILD QUEST - Game Manager Destroyed");
show_debug_message("========================================");
