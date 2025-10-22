

function initialize_encounter_button(data) {
    option_name = data.option_name;
	option_effect = data.option_effect;
	option_message = data.option_message;
    
    show_debug_message("Encounter button initialized: " + option_name);
}
hovered = false;

depth = -20000;