// Calculate button positions (must match your Draw GUI and Step)
//var btn1_x = screen_w / 2 - (btn_width / 2) - (btn_spacing / 2);
//var btn2_x = screen_w / 2 + (btn_width / 2) + (btn_spacing / 2);

// Button 1 clicked
if (point_in_rectangle(mouse_x, mouse_y,
    yes_btn_x1, yes_btn_y1,
	yes_btn_x2, yes_btn_y2))
{
	//if (global.bonfire_used) {
    //    show_message("The bonfire has gone cold. It cannot be used again.");
    //    exit; // do nothing further
    //}
	var msg = instance_create_layer(0, 0, "Instances", obj_popup_message);
	msg.message_text = scribble("You had a good rest")
					.align(fa_center, fa_middle);
	msg.function_to_run = function(){};

    global.bonfire_used = true;

    if (instance_exists(global.bonfire_room)) {
        global.bonfire_room.is_bonfire_used = true;
    }
	var full_hp = obj_player_state.data.max_hp;
	obj_player_state.data.hp = full_hp;
	
	empty_shop_card();
	
	global.map_needs_reset = true;  // flag that next room must regenerate
	alarm[0] = 120;
}

// Button 2 clicked
if (point_in_rectangle(mouse_x, mouse_y,
    no_btn_x1, no_btn_y1,
	no_btn_x2, no_btn_y2))
{
    //show_message("You chose not to rest");
	var msg = instance_create_layer(0, 0, "Instances", obj_popup_message);
	msg.message_text = scribble("You chose not to rest")
					.align(fa_center, fa_middle);
	msg.function_to_run = function(){};
	
	global.just_exited_bonfire = true;
	global.bonfire_used = false;
	alarm[0] = 120;
}
