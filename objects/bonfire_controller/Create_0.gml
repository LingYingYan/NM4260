sprite_center = spr_bonfire; // your sprite
btn1_text = "Yes";
btn2_text = "No";
desc_text = "Do you want to rest beside the bonfire?";

btn_width = 150;
btn_height = 40;
btn_spacing = 20;

screen_w = display_get_gui_width();
screen_h = display_get_gui_height();

sprite_y = screen_h * 0.35; // center sprite vertically near top
buttons_y = screen_h * 0.55; // button row
desc_y = screen_h * 0.7; // description text

hovered_button = -1

go_next_frame = false;