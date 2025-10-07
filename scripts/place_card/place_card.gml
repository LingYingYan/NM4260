/// @desc Place a card
/// @param {id.instance} card The card
/// @param {real} pos_x The x position
/// @param {real} pos_y The y position
function place_card(card, pos_x, pos_y) {
    card.goal_x = pos_x;
    card.goal_y = pos_y;
}