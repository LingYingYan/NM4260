var btn_width = 100;
var spacing = 100;

var start_x = (room_width - (btn_width * array_length(options) + spacing * (array_length(options) -1))) / 2;

if (is_array(options) && array_length(options) > 0 && button_generated == false) {
	for (var i = 0; i < array_length(options); i++) {
	    var pos_y = room_height * 2/3;
		//draw_rectangle(start_x + i * (btn_width + spacing), pos_y, 
		//				start_x + i * (btn_width + spacing) + btn_width, pos_y + 60 ,false);
		var button = instance_create_layer(start_x + i * (btn_width + spacing), pos_y, "Instances", obj_encounter_button)
		button.initialize_encounter_button(options[i]);
		show_debug_message("button is generated");
		button_generated = true;
		//draw_text(start_x + i * (btn_width + spacing), pos_y, options[i].option_name);
	}
}