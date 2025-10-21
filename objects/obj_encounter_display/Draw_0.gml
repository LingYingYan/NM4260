var btn_width = 100;
var spacing = 100;

var start_x = (room_width - (btn_width * array_length(options) + spacing * (array_length(options) -1))) / 2;


draw_set_font(fnt_header);
draw_set_color(c_white);
draw_text(room_width/3, room_height/6, name);

draw_set_font(fnt_default);
draw_set_color(c_white);
draw_text(room_width/8, room_height/2, description);

//for (var i = 0; i < array_length(options); i++) {
//    var pos_y = room_height * 2/3;
//	//draw_rectangle(start_x + i * (btn_width + spacing), pos_y, 
//	//				start_x + i * (btn_width + spacing) + btn_width, pos_y + 60 ,false);
//	var button = instance_create_layer(start_x + i * (btn_width + spacing), pos_y, "Instances", obj_encounter_button)
//	button.initialize_encounter_button(options[i]);
//	show_debug_message("button is generated");
//	//draw_text(start_x + i * (btn_width + spacing), pos_y, options[i].option_name);
//}