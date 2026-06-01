/// @description Town System - Building management, resource tracking, NPC scheduling
/// @function init_town_system()

function init_town_system() {
	// Town state struct
	global.town = {
		name: "Wild Wild Quest",
		level: 1,
		population: 10,
		treasury: 500, // Starting gold
		happiness: 75, // 0-100
		
		// Building data
		buildings: ds_map_create(),
		building_count: 0,
		
		// NPCs in town
		npcs: ds_list_create(),
		
		// Town upgrades
		upgrades: ds_list_create(),
		
		// Resources
		resources: {
			wood: 100,
			stone: 50,
			food: 150,
			gold: 500
		}
	};
	
	// Initialize default buildings
	add_building_to_town("tavern", 1, 1);
	add_building_to_town("smithy", 3, 1);
	add_building_to_town("marketplace", 5, 1);
	
	show_debug_message("✓ Town system ready - " + global.town.name);
}

/// Add a building to the town
/// @param {string} building_type - Type of building (tavern, smithy, marketplace, etc.)
/// @param {int} x - Grid X position
/// @param {int} y - Grid Y position
function add_building_to_town(building_type, x, y) {
	var building = {
		type: building_type,
		grid_x: x,
		grid_y: y,
		level: 1,
		condition: 100, // 0-100 condition
		workers: 0,
		production: 0
	};
	
	global.town.buildings[? global.town.building_count] = building;
	global.town.building_count++;
	
	show_debug_message("Building added: " + building_type + " at (" + string(x) + ", " + string(y) + ")");
}

/// Get building by type
/// @param {string} building_type
/// @returns {struct} building struct or undefined
function get_building_by_type(building_type) {
	var key = ds_map_find_first(global.town.buildings);
	while (key != undefined) {
		if (global.town.buildings[? key].type == building_type) {
			return global.town.buildings[? key];
		}
		key = ds_map_find_next(global.town.buildings, key);
	}
	return undefined;
}

/// Upgrade a building
/// @param {string} building_type
/// @returns {bool} success
function upgrade_building(building_type) {
	var building = get_building_by_type(building_type);
	if (building == undefined) return false;
	
	var upgrade_cost = 100 * building.level; // Cost scales with level
	
	if (global.town.resources.gold >= upgrade_cost) {
		global.town.resources.gold -= upgrade_cost;
		building.level++;
		show_debug_message("Building upgraded: " + building_type + " -> Level " + string(building.level));
		return true;
	}
	
	return false;
}

/// Add resources to town
/// @param {string} resource_type - "gold", "wood", "stone", "food"
/// @param {int} amount
function add_town_resource(resource_type, amount) {
	if (global.town.resources[? resource_type] != undefined) {
		global.town.resources[? resource_type] += amount;
	}
}

/// Spend town resources
/// @param {string} resource_type
/// @param {int} amount
/// @returns {bool} success
function spend_town_resource(resource_type, amount) {
	if (global.town.resources[? resource_type] == undefined) return false;
	if (global.town.resources[? resource_type] < amount) return false;
	
	global.town.resources[? resource_type] -= amount;
	return true;
}

/// Update town happiness
/// @param {int} change - Positive or negative value
function update_town_happiness(change) {
	global.town.happiness = clamp(global.town.happiness + change, 0, 100);
	show_debug_message("Town happiness: " + string(global.town.happiness) + "%");
}

/// Grow town population
/// @param {int} count - Number of new NPCs
function grow_population(count) {
	global.town.population += count;
	update_town_happiness(5 * count);
	show_debug_message("Population: " + string(global.town.population));
}

/// Get town status as string (for UI)
function get_town_status() {
	return "Day: " + string(get_current_day()) + " | Pop: " + string(global.town.population) + 
	       " | Gold: " + string(global.town.resources.gold) + " | Happiness: " + string(global.town.happiness) + "%";
}

/// Clean up town system
function cleanup_town_system() {
	ds_map_destroy(global.town.buildings);
	ds_list_destroy(global.town.npcs);
	ds_list_destroy(global.town.upgrades);
	show_debug_message("✓ Town system cleaned up");
}
