hand = obj_hand;

//treasure_cards = [
//make_card_from(res_healing_card),
//make_card_from(res_fireball_card), 
//make_card_from(res_force_of_nature_card)];

//cards_pool = array_shuffle(treasure_cards);

// for now , 2 cards are shown to let player choose
var card1 = instance_create_layer(view_wport[0]/2 - 128, view_hport[0]/2-100, "Instances", obj_card);
var card2 = instance_create_layer(view_wport[0]/2 + 128, view_hport[0]/2-100, "Instances", obj_card);
show_debug_message("treasure card is created")


