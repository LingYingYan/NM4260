hover_index = -1;

for (var i = 0; i < array_length(buttons); i++) {
    var bx = panel_x + (panel_w - button_width) / 2;
    var by = panel_y + 300 + i * (button_height + button_spacing)

    if (point_in_rectangle(mouse_x, mouse_y, bx, by, bx + button_width, by + button_height)) {
        hover_index = i;
        if (mouse_check_button_pressed(mb_left)) {
            var action = buttons[i].action;
            switch (action) {
                case "new_game":
                    room_goto(rm_game_start);
                    break;
                case "credits":
                    // go to credits?
					instance_create_layer(room_width/2, room_height/2, "Instances", obj_credits);
                    break;
                case "quit_game":
					// quit & save game
                    break;
            }
        }
    }
}

// Help click
var help_x = display_get_width()/2 - 20;
var help_y = panel_y + panel_h - 50;
if (point_distance(mouse_x, mouse_y, help_x, help_y) < 50 && mouse_check_button_pressed(mb_left)) {
   //go to instructions page?
}
