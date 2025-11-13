// create the global room_grid
//create_tutorial_map();
//show_debug_message("creating tutorial map")

//create_tutorial_player();
//show_debug_message("creating tutorial player");
encounter_used = false;

label_enc = instance_create_layer(room_width/5, room_height/4, "Instances", obj_tut_label);
label_enc.label_scenario = "encounter_map";
label_enc.visible = true;

label_ene = instance_create_layer(room_width/3, room_height/3 * 2, "Instances", obj_tut_label);
label_ene.label_scenario = "enemy_map";
label_ene.visible = true;

label_discover = instance_create_layer(room_width/3 * 2, room_height/ 2 - 70, "Instances", obj_tut_label);
label_discover.label_scenario = "discover";

layer_set_visible("Assets_2", false);

instance_create_layer(room_width - 40, 40, "Instances", obj_ele_reaction_toggle);


