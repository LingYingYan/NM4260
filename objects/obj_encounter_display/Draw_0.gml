var spr = noone;
switch (name) {
	case "The Vision Pool": spr = spr_enc_visionPool; break;
	case "The Whispering Wall": spr = spr_enc_whisperingWall; break;
}
draw_sprite(spr, 0, room_width/2, room_height/3)

draw_set_font(fnt_header);
draw_set_color(c_black);
var header_width = string_width(name);
draw_text(room_width/2 - header_width/2, room_height/8, name);

draw_set_font(fnt_default);
draw_set_color(c_black);
var desc_width = string_width(description);
draw_text_ext(room_width/2 - desc_width/2, room_height/2, description, 20, room_width*3/4);

//if (is_array(options) && array_length(options) > 0) {
//	for (var i = 0; i < array_length(options); i++) {
//	    var pos_y = room_height * 2/3;
//		//draw_rectangle(start_x + i * (btn_width + spacing), pos_y, 
//		//				start_x + i * (btn_width + spacing) + btn_width, pos_y + 60 ,false);
//		var button = instance_create_layer(start_x + i * (btn_width + spacing), pos_y, "Instances", obj_encounter_button)
//		button.initialize_encounter_button(options[i]);
//		show_debug_message("button is generated");
//		//draw_text(start_x + i * (btn_width + spacing), pos_y, options[i].option_name);
//	}
//}