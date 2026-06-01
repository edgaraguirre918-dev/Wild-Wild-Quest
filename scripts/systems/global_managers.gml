/// @description Global Managers - Centralized game state and system initialization
/// @function init_global_managers()

// ============================================================================
// GLOBAL GAME STATE MANAGER
// ============================================================================

/// Initialize all global systems - call this in Create event of persistent object
function init_global_managers() {
	// Game state flags
	global.game_paused = false;
	global.game_running = true;
	global.current_room_type = "town"; // town, guild_hall, dungeon, combat
	global.current_day = 1;
	
	// Initialize subsystems (these are defined in their respective files)
	init_town_system();
	init_guild_system();
	init_character_system();
	init_quest_system();
	init_combat_system();
	init_save_system();
	
	show_debug_message("✓ Global managers initialized");
}

// ============================================================================
// DEBUG & UTILITY FUNCTIONS
// ============================================================================

/// Toggle pause state
function toggle_game_pause() {
	global.game_paused = !global.game_paused;
	show_debug_message("Game paused: " + string(global.game_paused));
}

/// Get current game time (in-game days)
function get_current_day() {
	if (!variable_instance_exists(global, "current_day")) {
		global.current_day = 1;
	}
	return global.current_day;
}

/// Advance time by one day
function advance_day() {
	global.current_day++;
	show_debug_message("Advanced to day: " + string(global.current_day));
	
	// Trigger daily events
	on_daily_tick();
}

/// Trigger daily tick events
function on_daily_tick() {
	// Update quests
	update_quests();
	
	show_debug_message("→ Daily tick triggered (Day " + string(global.current_day) + ")");
}

/// Log game state (for debugging)
function log_game_state() {
	show_debug_message("=== GAME STATE ===");
	show_debug_message("Day: " + string(get_current_day()));
	show_debug_message("Room: " + string(global.current_room_type));
	show_debug_message("Paused: " + string(global.game_paused));
	show_debug_message("==================");
}
