/// @description obj_game_manager - Create Event
/// Initialize all game systems

// Make this object persistent so it survives room transitions
persistent = true;

// Initialize all game systems
init_global_managers();

// Set up frame rate
game_set_speed(60, gamespeed_framerate);

// Debug information
show_debug_message("========================================");
show_debug_message("WILD WILD QUEST - Game Manager Created");
show_debug_message("========================================");
show_debug_message("Platform: " + os_get_config());
show_debug_message("Version: 1.0 (Early Development)");
show_debug_message("========================================");
