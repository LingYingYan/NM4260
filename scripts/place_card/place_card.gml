/// @desc Place a card
/// @param {id.instance} card The card
/// @param {real} pos_x The x position
/// @param {real} pos_y The y position
function place_card(card, pos_x, pos_y) {
    card.goal_x = pos_x;
    card.goal_y = pos_y;
}

function put_card_to_slot(card, slot) {
    if (!instance_exists(card)) {
        return;
    }
    card.image_xscale = slot.image_xscale;
    card.image_yscale = slot.image_yscale;
    card.scale = slot.image_xscale;
    place_card(card, slot.x, slot.y);
    slot.card = card;
    card.dropped_area = slot;
    set_card_depth(card, slot.depth + 1);
}