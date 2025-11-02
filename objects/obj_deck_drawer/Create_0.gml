depth = -25000;

scale = 0.5

can_remove = true; // whether can allow player to remove one card from deck
card_to_remove = noone;

drawer_width = 300;
drawer_height = room_height;
drawer_x = room_width;        // start hidden off-screen
drawer_target = room_width - drawer_width; // visible position when opened
is_open = false;

scroll_y = 0;
scroll_target = 0;
scroll_speed = 20;

card_width = sprite_get_width(spr_card_demo) * scale;
card_height = sprite_get_height(spr_card_demo) * scale;
card_spacing = 80;

make_drawer_and_cards();

make_drawer = function() {    
    // one instance per unique card
    var card_inst = instance_create_layer(card_x, card_y, "Instances", obj_deck_drawer_card);
    card_inst.card_data = card_data;
    card_inst.count = count;
    card_inst.idx = idx;
	card_inst.image_xscale = scale;
	card_inst.image_yscale = scale;
	card_inst.reveal = obj_player_state.data.max_vision;
    show_debug_message("Unique card is created");
}