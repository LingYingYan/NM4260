function initialize_encounter(data) {
    encounter_data = data;
    name = encounter_data.name;
    description = encounter_data.description;
    options = encounter_data.options;

    show_debug_message("Encounter initialized: " + name);
}


for (var i = 0; i < array_length(options); i++) {
    var pos_y = room_height * 2/3;
	//draw_rectangle(start_x + i * (btn_width + spacing), pos_y, 
	//				start_x + i * (btn_width + spacing) + btn_width, pos_y + 60 ,false);
	var button = instance_create_layer(start_x + i * (btn_width + spacing), pos_y, "Instances", obj_encounter_button)
	button.initialize_encounter_button(options[i]);
	show_debug_message("button is generated");
	//draw_text(start_x + i * (btn_width + spacing), pos_y, options[i].option_name);
}