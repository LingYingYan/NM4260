// create the global room_grid
//create_tutorial_map();
//show_debug_message("creating tutorial map")

//create_tutorial_player();
//show_debug_message("creating tutorial player");
encounter_used = false;

label_enc = instance_create_layer(room_width/3 * 2, room_height/2, "Instances", obj_tut_label);
label_enc.label_scenario = "encounter_map";
label_enc.visible = true;

label_ene = instance_create_layer(room_width/3, room_height/3 * 2, "Instances", obj_tut_label);
label_ene.label_scenario = "enemy_map";
label_ene.visible = true;

label_discover = instance_create_layer(room_width/3, room_height/3, "Instances", obj_tut_label);
label_discover.label_scenario = "discover";
//enemy_x = 3 * global.ROOM_SIZE + global.map_offset_x;
//enemy_y = 3 * global.ROOM_SIZE + global.map_offset_y;

//encounter_x = 3 * global.ROOM_SIZE + global.map_offset_x;
//encounter_y = 2 * global.ROOM_SIZE + global.map_offset_y;

//enemy_hidden_x = 4 * global.ROOM_SIZE + global.map_offset_x;
//enemy_hidden_y = 2 * global.ROOM_SIZE + global.map_offset_y;

//shop_x = 3 * global.ROOM_SIZE + global.map_offset_x;
//shop_y = 1 * global.ROOM_SIZE + global.map_offset_y;

