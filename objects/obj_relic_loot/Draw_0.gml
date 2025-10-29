var scribble_text = scribble($"[b]You gain a new relic![/b]")
    .wrap(800)
    .align(fa_center, fa_middle)
    .scale(2);

var panel_w = scribble_text.get_width() * 1.25;
var panel_h = scribble_text.get_height() * 1.25;
var panel_x = room_width / 2 - panel_w / 2;
var panel_y = room_height / 2 - obj_relic_card.sprite_height / obj_relic_card.image_yscale / 1.5 - panel_h / 2;
draw_sprite_stretched(spr_panel, self.image_index, panel_x, panel_y, panel_w, panel_h);
scribble_text.draw(room_width / 2, room_height / 2 - obj_relic_card.sprite_height / obj_relic_card.image_yscale / 1.5);