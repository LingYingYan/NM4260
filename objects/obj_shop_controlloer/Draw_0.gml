var text = "Shop";
var txt_w = string_width(text);
draw_set_font(fnt_header);
draw_set_color(c_black);
draw_text(room_width/2 - txt_w , room_height/8, text);

// price text
draw_set_font(fnt_default);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
with (obj_shop_card) {
    var text_y = y + (sprite_get_height(spr_card_demo) * image_yscale / 2) + 20; // 20px below bottom
    var cost_str = "- " + string(cost) + " Vision"; // adjust field name to your data
    draw_text(x, text_y, cost_str);
}
with (obj_relic_card) {
    var text_y = y + (sprite_get_height(spr_card_demo) * image_yscale / 2) + 20; // 20px below bottom
    var cost_str = "- " + string(cost) + " Vision"; // adjust field name to your data
    draw_text(x, text_y, cost_str);
}

if (global.is_tut) {
	// Inside tut, show labels and arrows
	label_drawer.visible = true;
	label_purchase.visible = true;
	layer_set_visible("Assets_1", true);
}
