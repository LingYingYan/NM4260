var tooltip_text = "";
if (self.card_data != undefined) {
    tooltip_text += self.card_data.mark.describe();   
}

var text_w = string_width_ext(tooltip_text, -1, 750);
var text_h = string_height_ext(tooltip_text, -1, 750);
var panel_w = text_w + 50;
var panel_h = text_h + 50;
if (self.hovered && tooltip_text != "" && self.reveal >= 1) {
    var mouse_x_gui = device_mouse_x_to_gui(0);
    var mouse_y_gui = device_mouse_y_to_gui(0);
    var x_gui = mouse_x_gui;
    var y_gui = mouse_y_gui;
    if (mouse_x_gui <= display_get_gui_width() / 2) {
        //x_gui += panel_w / 2;
    } else {
        x_gui -= panel_w;
    }
    
    if (mouse_y_gui <= display_get_gui_height() / 2) {
        //y_gui += panel_h / 2;
    } else {
        y_gui -= panel_h;
    }
    
    draw_sprite_stretched(spr_panel, self.image_index, x_gui, y_gui, panel_w, panel_h);
    
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_text_ext_color(
        x_gui + 25, y_gui + 25, tooltip_text, -1, text_w,
        c_black, c_black, c_black, c_black, 1
    );
}