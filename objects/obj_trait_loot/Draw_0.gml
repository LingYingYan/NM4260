var scribble_text = scribble($"[b]You gain a new trait![/b]\n{trait.name}\n{trait.desc}")
    .wrap(800)
    .align(fa_left, fa_middle)
    .scale(2);

var panel_w = scribble_text.get_width() * 1.15;
var panel_h = scribble_text.get_height() * 1.15;
var panel_x = (room_width - panel_w) / 2;
var panel_y = (room_height - panel_h) / 2;
draw_sprite_stretched(spr_panel, self.image_index, panel_x, panel_y, panel_w, panel_h);
scribble_text.draw((room_width - scribble_text.get_width()) / 2, room_height / 2);

