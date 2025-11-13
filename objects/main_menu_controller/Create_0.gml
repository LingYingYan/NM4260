title = "Prophet";


fnt_title = fnt_main_header;
fnt_button = fnt_main_menu_btn;
fnt_help = fnt_main_menu_btn;

col_panel = make_color_rgb(200, 180, 150)
col_button_normal = make_color_rgb(130, 80, 40);
col_button_hover = make_color_rgb(180, 130, 90);
col_button_disabled = make_color_rgb(200, 180, 150);
col_text = c_white;

panel_w = room_width/3;
panel_h = room_height/3 * 2;
panel_x = (room_width - panel_w) / 2;
panel_y = (room_height - panel_h) / 2;

// Button settings
buttons = [
    { label: "New Game", action: "new_game" },
    { label: "Credits", action: "credits" },
    { label: "Quit Game", action: "quit_game" }
];
button_width = panel_w/3 * 2;
button_height = 60;
button_spacing = 40;
help_txt = "Help";

hover_index = -1;
hover_help_index = -1;
popup_shown = false;