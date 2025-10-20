var rows = 2;
var cards_in_row = [4, 4];
var spacing_x = 40;
var spacing_y = 120;
var scale = 0.6;

var surf_w = room_width
var surf_h = room_height

var card_w = sprite_get_width(spr_card_demo)  * scale;
var card_h = sprite_get_height(spr_card_demo) * scale;

var total_height = (card_h * rows) + spacing_y;
var start_y = (surf_h - total_height) / 2 + card_h / 2; // ⬅ shift down by half card height

var selected_cards = [];

for (var row = 0; row < rows; row++) {
    var num_cards = cards_in_row[row];

    // total width of this row
    var total_w = num_cards * card_w + (num_cards - 1) * spacing_x;

    var start_x = (surf_w - total_w) / 2 + card_w / 2;

    // Y position of this row
    var pos_y = start_y + row * (card_h + spacing_y);

    for (var i = 0; i < num_cards; i++) {
        var pos_x = start_x + i * (card_w + spacing_x);

        // ensure uniqueness
        var unique_card = noone;
        var duplicate = true;
        while (duplicate) {
            duplicate = false;
            var card = res_loader_cards.get_random_card("Instances");

            for (var j = 0; j < array_length(selected_cards); j++) {
                if (card.card_data.type == selected_cards[j].card_data.type &&
                    card.card_data.name == selected_cards[j].card_data.name) {
                    duplicate = true;
                    break;
                }
            }

            if (!duplicate) {
                unique_card = card;
                array_push(selected_cards, card);
            }
        }

        var new_card = instance_create_layer(pos_x, pos_y, "Instances", obj_shop_card);
        new_card.card_data = unique_card.card_data;
        new_card.image_xscale = scale;
        new_card.image_yscale = scale;
        new_card.set_reveal(obj_player_state.data.max_vision);
    }
}


