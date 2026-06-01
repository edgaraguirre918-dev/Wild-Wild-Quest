/// @description Save/Load System - Game state persistence
/// @function init_save_system()

function init_save_system() {
	// Save system config
	global.save_system = {
		save_directory: working_directory + "saves/",
		current_save_slot: 1,
		auto_save_enabled: true,
		auto_save_interval: 300 // Every 5 minutes in frames (at 60fps)
	};
	
	// Create saves directory if it doesn't exist
	if (!directory_exists(global.save_system.save_directory)) {
		directory_create(global.save_system.save_directory);
	}
	
	show_debug_message("✓ Save system ready at: " + global.save_system.save_directory);
}

/// Save game to file
/// @param {int} slot - Save slot number
/// @returns {bool} success
function save_game(slot) {
	var filename = global.save_system.save_directory + "save_slot_" + string(slot) + ".json";
	
	// Create save data struct
	var save_data = {
		version: "1.0",
		timestamp: date_current_datetime(),
		
		// Game state
		current_day: global.current_day,
		room_type: global.current_room_type,
		
		// Town data
		town: {
			name: global.town.name,
			level: global.town.level,
			population: global.town.population,
			treasury: global.town.treasury,
			happiness: global.town.happiness,
			resources: global.town.resources,
			buildings: ds_map_to_array(global.town.buildings)
		},
		
		// Guild data
		guild: {
			name: global.guild.name,
			level: global.guild.level,
			treasury: global.guild.treasury,
			reputation: global.guild.reputation,
			quests_completed: global.guild.quests_completed,
			adventurers: ds_list_to_array(global.guild.adventurers)
		},
		
		// Character data
		characters: {
			npcs: ds_map_to_array(global.characters.npcs),
			rescued_count: ds_list_size(global.characters.rescued)
		}
	};
	
	// Convert to JSON
	var json_string = json_stringify(save_data);
	
	// Write to file
	var file = file_text_open_write(filename);
	file_text_write_string(file, json_string);
	file_text_close(file);
	
	show_debug_message("✓ Game saved to slot " + string(slot));
	return true;
}

/// Load game from file
/// @param {int} slot - Save slot number
/// @returns {bool} success
function load_game(slot) {
	var filename = global.save_system.save_directory + "save_slot_" + string(slot) + ".json";
	
	if (!file_exists(filename)) {
		show_debug_message("! Save file not found: " + filename);
		return false;
	}
	
	// Read file
	var file = file_text_open_read(filename);
	var json_string = file_text_read_string(file);
	file_text_close(file);
	
	// Parse JSON
	var save_data = json_parse(json_string);
	
	// Restore game state
	global.current_day = save_data.current_day;
	global.current_room_type = save_data.room_type;
	
	// Restore town
	global.town.name = save_data.town.name;
	global.town.level = save_data.town.level;
	global.town.population = save_data.town.population;
	global.town.treasury = save_data.town.treasury;
	global.town.happiness = save_data.town.happiness;
	global.town.resources = save_data.town.resources;
	
	// Restore guild
	global.guild.name = save_data.guild.name;
	global.guild.level = save_data.guild.level;
	global.guild.treasury = save_data.guild.treasury;
	global.guild.reputation = save_data.guild.reputation;
	global.guild.quests_completed = save_data.guild.quests_completed;
	
	show_debug_message("✓ Game loaded from slot " + string(slot));
	return true;
}

/// Convert ds_map to array for JSON serialization
/// @param {int} ds_map_id
/// @returns {array} array representation
function ds_map_to_array(map_id) {
	var arr = array_create(0);
	var key = ds_map_find_first(map_id);
	
	while (key != undefined) {
		array_push(arr, {
			key: key,
			value: map_id[? key]
		});
		key = ds_map_find_next(map_id, key);
	}
	
	return arr;
}

/// Convert ds_list to array for JSON serialization
/// @param {int} list_id
/// @returns {array} array representation
function ds_list_to_array(list_id) {
	var arr = array_create(0);
	var i = 0;
	repeat(ds_list_size(list_id)) {
		array_push(arr, list_id[| i]);
		i++;
	}
	return arr;
}

/// Check if save slot exists
/// @param {int} slot
/// @returns {bool} exists
function save_slot_exists(slot) {
	var filename = global.save_system.save_directory + "save_slot_" + string(slot) + ".json";
	return file_exists(filename);
}

/// Delete save slot
/// @param {int} slot
/// @returns {bool} success
function delete_save_slot(slot) {
	var filename = global.save_system.save_directory + "save_slot_" + string(slot) + ".json";
	
	if (file_exists(filename)) {
		file_delete(filename);
		show_debug_message("✓ Save slot " + string(slot) + " deleted");
		return true;
	}
	
	return false;
}

/// Get list of all saves
/// @returns {array} array of save slot numbers that exist
function get_save_list() {
	var saves = array_create(0);
	
	for (var i = 1; i <= 10; i++) {
		if (save_slot_exists(i)) {
			array_push(saves, i);
		}
	}
	
	return saves;
}

/// Clean up save system
function cleanup_save_system() {
	show_debug_message("✓ Save system cleaned up");
}
