/// @description Combat System - Turn-based tactical combat
/// @function init_combat_system()

function init_combat_system() {
	// Combat state
	global.combat = {
		active: false,
		turn_count: 0,
		current_turn_index: 0,
		
		// Participants
		player_party: array_create(0),
		enemy_party: array_create(0),
		turn_order: array_create(0),
		
		// Combat log
		log: array_create(0)
	};
	
	show_debug_message("✓ Combat system ready");
}

/// Start a combat encounter
/// @param {array} player_characters - Array of adventurer structs
/// @param {array} enemies - Array of enemy structs
/// @returns {bool} success
function start_combat(player_characters, enemies) {
	if (array_length(player_characters) == 0 || array_length(enemies) == 0) {
		return false;
	}
	
	global.combat.active = true;
	global.combat.turn_count = 0;
	global.combat.current_turn_index = 0;
	global.combat.player_party = player_characters;
	global.combat.enemy_party = enemies;
	global.combat.log = array_create(0);
	
	// Build turn order based on speed
	build_turn_order();
	
	add_combat_log("Combat started!");
	show_debug_message("✓ Combat started - Players: " + string(array_length(player_characters)) + " vs Enemies: " + string(array_length(enemies)));
	
	return true;
}

/// Build turn order based on speed stats
function build_turn_order() {
	global.combat.turn_order = array_create(0);
	
	// Add all combatants
	var i = 0;
	repeat(array_length(global.combat.player_party)) {
		var character = global.combat.player_party[i];
		array_push(global.combat.turn_order, {
			type: "player",
			character: character,
			speed: character.speed
		});
		i++;
	}
	
	i = 0;
	repeat(array_length(global.combat.enemy_party)) {
		var enemy = global.combat.enemy_party[i];
		array_push(global.combat.turn_order, {
			type: "enemy",
			character: enemy,
			speed: enemy.speed
		});
		i++;
	}
	
	// Sort by speed (descending)
	array_sort(global.combat.turn_order, function(a, b) {
		return b.speed - a.speed; // Higher speed goes first
	});
}

/// Get current active combatant
/// @returns {struct} combatant
function get_current_combatant() {
	if (global.combat.current_turn_index < array_length(global.combat.turn_order)) {
		return global.combat.turn_order[global.combat.current_turn_index];
	}
	return undefined;
}

/// Execute player action
/// @param {string} action_type - "attack", "skill", "defend", "escape"
/// @param {struct} target - Target character/enemy
/// @returns {struct} result
function execute_action(action_type, target) {
	var attacker = get_current_combatant().character;
	var damage = 0;
	var result = {
		success: false,
		message: "",
		damage: 0,
		target_hp: target.current_hp
	};
	
	switch(action_type) {
		case "attack":
			damage = calculate_damage(attacker, target);
			target.current_hp -= damage;
			if (target.current_hp < 0) target.current_hp = 0;
			
			result.success = true;
			result.message = attacker.name + " attacks " + target.name + " for " + string(damage) + " damage!";
			result.damage = damage;
			result.target_hp = target.current_hp;
			break;
			
		case "defend":
			attacker.defense += 3; // Temporary defense boost
			result.success = true;
			result.message = attacker.name + " takes a defensive stance!";
			break;
			
		case "escape":
			result.success = irandom(100) < 30; // 30% chance to escape
			result.message = result.success ? "Escaped from combat!" : "Failed to escape!";
			break;
	}
	
	add_combat_log(result.message);
	return result;
}

/// Calculate damage between attacker and target
/// @param {struct} attacker
/// @param {struct} target
/// @returns {int} damage
function calculate_damage(attacker, target) {
	var base_damage = attacker.attack;
	var defense_reduction = target.defense;
	var variance = irandom_range(-2, 2);
	
	var damage = base_damage - (defense_reduction * 0.5) + variance;
	return max(1, damage); // Minimum 1 damage
}

/// End current turn and advance to next
function end_turn() {
	global.combat.current_turn_index++;
	
	// Check if round is complete
	if (global.combat.current_turn_index >= array_length(global.combat.turn_order)) {
		global.combat.current_turn_index = 0;
		global.combat.turn_count++;
		add_combat_log("--- Round " + string(global.combat.turn_count) + " ---");
	}
	
	// Check win/loss conditions
	check_combat_end();
}

/// Check if combat is over (victory or defeat)
function check_combat_end() {
	var player_alive = false;
	var enemies_alive = false;
	
	// Check players
	var i = 0;
	repeat(array_length(global.combat.player_party)) {
		if (global.combat.player_party[i].current_hp > 0) {
			player_alive = true;
			break;
		}
		i++;
	}
	
	// Check enemies
	i = 0;
	repeat(array_length(global.combat.enemy_party)) {
		if (global.combat.enemy_party[i].current_hp > 0) {
			enemies_alive = true;
			break;
		}
		i++;
	}
	
	if (!player_alive) {
		end_combat(false); // Player defeat
	} else if (!enemies_alive) {
		end_combat(true); // Player victory
	}
}

/// End combat encounter
/// @param {bool} player_victory
function end_combat(player_victory) {
	global.combat.active = false;
	
	if (player_victory) {
		add_combat_log("Victory! Combat won!");
		show_debug_message("✓ Combat won!");
	} else {
		add_combat_log("Defeat! Party was defeated!");
		show_debug_message("✗ Combat lost!");
	}
}

/// Add message to combat log
/// @param {string} message
function add_combat_log(message) {
	array_push(global.combat.log, message);
}

/// Get combat log as array
/// @returns {array} combat log
function get_combat_log() {
	return global.combat.log;
}

/// Clean up combat system
function cleanup_combat_system() {
	// Clear all combat arrays
	global.combat.player_party = array_create(0);
	global.combat.enemy_party = array_create(0);
	global.combat.turn_order = array_create(0);
	global.combat.log = array_create(0);
	global.combat.active = false;
	
	show_debug_message("✓ Combat system cleaned up");
}
