depth = -25000;

scale = 0.5

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

player_deck = obj_player_deck_manager.denumerate();
show_debug_message($"Player deck is {player_deck}");

max_scroll = max(0, array_length(player_deck) * (card_height + card_spacing) - drawer_height);

player_deck_map = ds_map_create(); 
var scroll_index = 0; // index for scrolling

for (var i = 0; i < array_length(player_deck); i++) {
    var card_data = player_deck[i];

    if (ds_map_exists(player_deck_map, card_data)) {
        // already exists → increment count
        var info_array = player_deck_map[? card_data];
        info_array[1] += 1;
    } else {
        // new unique card → scroll index and count
        var new_info = [scroll_index, 1];
        ds_map_add(player_deck_map, card_data, new_info);

        scroll_index += 1; // move to next slot for next unique card
    }
}

var keys = ds_map_keys_to_array(player_deck_map);

for (var i = 0; i < array_length(keys); i++) {
    var card_data = keys[i];
    var info = player_deck_map[? card_data];
    
    var idx = info[0];
    var count = info[1];
    
    var card_y = 500 + idx * (card_height + card_spacing);
    var card_x = drawer_x + drawer_width / 2;
    
    // one instance per unique card
    var card_inst = instance_create_layer(card_x, card_y, "Instances", obj_deck_drawer_card);
    card_inst.card_data = card_data;
    card_inst.count = count;
    card_inst.idx = idx;
	card_inst.image_xscale = scale;
	card_inst.image_yscale = scale;
	card_inst.set_reveal(obj_player_state.data.max_vision);
    show_debug_message("Unique card is created");
}

// Clean up temporary array of keys
array_delete(keys, 0, array_length(keys));