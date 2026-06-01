/// @description Quest System - Quest generation and tracking
/// @function init_quest_system()

function init_quest_system() {
	// Quest system state
	global.quests = {
		// Available quests
		available: ds_list_create(),
		
		// In-progress quests
		in_progress: ds_list_create(),
		
		// Completed quests
		completed: ds_list_create(),
		
		// Quest difficulty progression
		base_difficulty: 1,
		difficulty_scale: 1.1 // Scales with progression
	};
	
	// Generate initial quests
	generate_random_quest();
	generate_random_quest();
	
	show_debug_message("✓ Quest system ready");
}

/// Generate a random quest
/// @returns {struct} quest struct
function generate_random_quest() {
	var difficulty = global.quests.base_difficulty;
	var quest_types = ["rescue", "hunt", "explore", "investigate"];
	var quest_type = quest_types[irandom(array_length(quest_types) - 1)];
	
	var quest = {
		id: ds_list_size(global.quests.available),
		type: quest_type,
		title: generate_quest_title(quest_type),
		description: generate_quest_description(quest_type),
		difficulty: difficulty,
		reward_gold: irandom_range(50, 200) * difficulty,
		reward_exp: irandom_range(100, 300) * difficulty,
		
		// Quest specifics
		required_adventurers: irandom_range(1, 3),
		estimated_duration: irandom_range(1, 3), // In-game days
		
		// Loot
		possible_loot: generate_quest_loot(difficulty),
		
		// Rescued character chance
		rescue_chance: 0.3 + (0.1 * difficulty),
		possible_rescued: array_create(0), // Filled when quest complete
		
		// Status
		status: "available",
		assigned_to: undefined,
		turns_remaining: 0
	};
	
	ds_list_add(global.quests.available, quest);
	show_debug_message("✓ Quest generated: " + quest.title + " (Difficulty: " + string(difficulty) + ")");
	
	return quest;
}

/// Get quest title based on type
/// @param {string} quest_type
/// @returns {string} title
function generate_quest_title(quest_type) {
	var titles = {
		"rescue": ["Rescue the Villager", "Save the Merchant", "Free the Captive", "Retrieve the Lost One"],
		"hunt": ["Slay the Beast", "Hunt the Bandit", "Destroy the Nest", "Defeat the Warlord"],
		"explore": ["Scout the Ruins", "Map the Caverns", "Explore the Forest", "Survey the Wasteland"],
		"investigate": ["Solve the Mystery", "Find the Artifact", "Investigate the Disappearance", "Uncover the Truth"]
	};
	
	var type_titles = titles[? quest_type];
	if (type_titles != undefined) {
		return type_titles[irandom(array_length(type_titles) - 1)];
	}
	return "Unknown Quest";
}

/// Generate quest description
/// @param {string} quest_type
/// @returns {string} description
function generate_quest_description(quest_type) {
	switch(quest_type) {
		case "rescue":
			return "A villager has gone missing. Search the nearby dungeon and bring them back safely.";
		case "hunt":
			return "A dangerous creature has been terrorizing the region. Eliminate the threat.";
		case "explore":
			return "Venture into uncharted territory to gather information and resources.";
		case "investigate":
			return "Strange occurrences have been reported. Investigate and report back.";
		default:
			return "Complete this quest to earn rewards.";
	}
}

/// Generate possible loot for quest
/// @param {real} difficulty
/// @returns {array} array of possible items
function generate_quest_loot(difficulty) {
	var loot = array_create(0);
	
	// Chance increases with difficulty
	if (random(1) < 0.3 + (0.1 * difficulty)) {
		array_push(loot, "iron_sword");
	}
	if (random(1) < 0.2 + (0.05 * difficulty)) {
		array_push(loot, "leather_armor");
	}
	if (random(1) < 0.15) {
		array_push(loot, "health_potion");
	}
	if (random(1) < 0.1 * difficulty) {
		array_push(loot, "rare_gem");
	}
	
	return loot;
}

/// Assign a quest to a party
/// @param {int} quest_index
/// @param {struct} party
/// @returns {bool} success
function assign_quest(quest_index, party) {
	var quest = global.quests.available[| quest_index];
	if (quest == undefined) return false;
	
	quest.status = "in_progress";
	quest.assigned_to = party;
	quest.turns_remaining = quest.estimated_duration;
	
	// Move quest to in-progress
	ds_list_delete(global.quests.available, quest_index);
	ds_list_add(global.quests.in_progress, quest);
	
	show_debug_message("✓ Quest assigned: " + quest.title);
	return true;
}

/// Update quests (called once per day)
function update_quests() {
	var i = 0;
	repeat(ds_list_size(global.quests.in_progress)) {
		var quest = global.quests.in_progress[| i];
		quest.turns_remaining--;
		
		if (quest.turns_remaining <= 0) {
			complete_quest(quest);
			ds_list_delete(global.quests.in_progress, i);
			// Don't increment i since list shifted
		} else {
			i++;
		}
	}
	
	// Generate new quest if running low
	if (ds_list_size(global.quests.available) < 2) {
		generate_random_quest();
	}
}

/// Complete a quest
/// @param {struct} quest
function complete_quest(quest) {
	// Award rewards to guild
	global.guild.treasury += quest.reward_gold;
	
	// Check for rescued characters
	var rescued_count = 0;
	if (random(1) < quest.rescue_chance) {
		rescued_count = irandom_range(1, 2);
		repeat(rescued_count) {
			create_rescued_character(
				"Unknown " + string(irandom(1000)),
				["knight", "merchant", "scholar", "peasant"][irandom(3)]
			);
		}
	}
	
	// Move to completed
	ds_list_add(global.quests.completed, quest);
	global.guild.quests_completed++;
	
	show_debug_message("✓ Quest completed: " + quest.title + " | Rescued: " + string(rescued_count));
}

/// Get available quests
/// @returns {int} count
function get_available_quests_count() {
	return ds_list_size(global.quests.available);
}

/// Clean up quest system
function cleanup_quest_system() {
	ds_list_destroy(global.quests.available);
	ds_list_destroy(global.quests.in_progress);
	ds_list_destroy(global.quests.completed);
	show_debug_message("✓ Quest system cleaned up");
}
