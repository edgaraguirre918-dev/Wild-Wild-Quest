/// @description obj_game_manager - Step Event
/// Called every frame to update game systems

// Don't run if game is paused
if (global.game_paused) {
	exit;
}

// Update quest progress
update_quests();

// DEBUG: Press Space to advance day
if (keyboard_check_pressed(vk_space)) {
	advance_day();
	show_debug_message("DEBUG: Manual day advance - Day " + string(get_current_day()));
}

// DEBUG: Press P to toggle pause
if (keyboard_check_pressed(ord("P"))) {
	toggle_game_pause();
}

// DEBUG: Press L to log game state
if (keyboard_check_pressed(ord("L"))) {
	log_game_state();
	show_debug_message("--- Guild Status ---");
	show_debug_message(get_guild_status());
	show_debug_message("--- Town Status ---");
	show_debug_message(get_town_status());
	show_debug_message("--- Rescued Characters ---");
	show_debug_message("Count: " + string(get_rescued_count()));
}

// DEBUG: Press D to display detailed debug info
if (keyboard_check_pressed(ord("D"))) {
	show_debug_message("=== DETAILED DEBUG INFO ===");
	show_debug_message("Adventurers: " + string(global.guild.adventurer_count));
	show_debug_message("Available quests: " + string(get_available_quests_count()));
	show_debug_message("NPCs: " + string(global.characters.npc_count));
	show_debug_message("Rescued: " + string(get_rescued_count()));
	show_debug_message("Town population: " + string(global.town.population));
	show_debug_message("Town treasury: " + string(global.town.resources.gold));
	show_debug_message("Guild treasury: " + string(global.guild.treasury));
	show_debug_message("===========================");
}
