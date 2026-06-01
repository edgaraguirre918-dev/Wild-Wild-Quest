/// @description obj_game_manager - Draw Event
/// Display game status on screen

var gui_width = display_get_gui_width();
var gui_height = display_get_gui_height();

// Set draw color and font
draw_set_color(c_white);
draw_set_alpha(1);

// Title
draw_set_font(-1); // Default font
draw_text_transformed(10, 10, "WILD WILD QUEST", 2, 2, 0);

// Game info
draw_set_font(-1);
draw_set_color(c_yellow);
draw_text(10, 50, "Day: " + string(get_current_day()));
draw_text(10, 70, "Status: " + (global.game_paused ? "PAUSED" : "RUNNING"));

// Town info
draw_set_color(c_lime);
draw_text(10, 110, "=== TOWN ===");
draw_text(10, 130, "Population: " + string(global.town.population));
draw_text(10, 150, "Happiness: " + string(global.town.happiness) + "%");
draw_text(10, 170, "Gold: " + string(global.town.resources.gold));

// Guild info
draw_set_color(c_aqua);
draw_text(10, 210, "=== GUILD ===");
draw_text(10, 230, "Adventurers: " + string(global.guild.adventurer_count) + "/" + string(global.guild.max_adventurers));
draw_text(10, 250, "Reputation: " + string(global.guild.reputation) + "%");
draw_text(10, 270, "Treasury: " + string(global.guild.treasury));
draw_text(10, 290, "Quests Completed: " + string(global.guild.quests_completed));

// Character info
draw_set_color(c_fuchsia);
draw_text(10, 330, "=== CHARACTERS ===");
draw_text(10, 350, "NPCs: " + string(global.characters.npc_count));
draw_text(10, 370, "Rescued: " + string(get_rescued_count()));

// Quest info
draw_set_color(c_orange);
draw_text(10, 410, "=== QUESTS ===");
draw_text(10, 430, "Available: " + string(get_available_quests_count()));
draw_text(10, 450, "In Progress: " + string(ds_list_size(global.quests.in_progress)));
draw_text(10, 470, "Completed: " + string(ds_list_size(global.quests.completed)));

// Debug controls
draw_set_color(c_ltgray);
draw_text(10, gui_height - 120, "=== DEBUG CONTROLS ===");
draw_text(10, gui_height - 100, "SPACE - Advance day");
draw_text(10, gui_height - 80, "P - Toggle pause");
draw_text(10, gui_height - 60, "L - Log state");
draw_text(10, gui_height - 40, "D - Detailed debug");
draw_text(10, gui_height - 20, "Esc - Close (if implemented)");

// Reset draw settings
draw_set_color(c_white);
draw_set_alpha(1);
