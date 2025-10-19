hand = obj_hand;

//var card1 = instance_create_layer(view_wport[0]/2 - 128, view_hport[0]/2-100, "Instances", obj_card);
//var card2 = instance_create_layer(view_wport[0]/2 + 128, view_hport[0]/2-100, "Instances", obj_card);
//show_debug_message("treasure card is created")

var pos_x = room_width/3;
var pos_y = room_height/2
var card_1 = res_loader_cards.get_random_card("Instances", pos_x, pos_y);
var card_2 = res_loader_cards.get_random_card("Instances", pos_x * 2, pos_y);
var card_3 = res_loader_cards.get_random_card("Instances", pos_x * 3, pos_y);

