function reset_all_global(){
	global.map_needs_reset = false;
	global.map_inited = false;

	global.in_tut = false; // if in tutorial, change the reveal_room etc.

	global.GRID_W = 6;
	global.GRID_H = 5;
	global.ROOM_SIZE = 128;
	global.ROOM_SPACING = 19; // very likely need to adjust later, this is based on the sprite i draw

	global.TOTAL_ROOM_NUM = 0;
	global.room_types = ds_map_create();

	global.room_grid = []; // will be filled by generate_map()
 
	global.bonfire_used = false; // deactivate bonfire after used once
	global.generate_new = true;
	global.player_current_room = noone;

	global.used_shops = [];

	global.checked_room = [];

	global.perm_revealed_rooms = ds_map_create();

	global.just_exited_bonfire = false;

	// shop-cards
	global.shop_card = ds_map_create();
	global.curr_shop_cards = [];
	global.curr_shop_relics = [];
	global.curr_shop_name = "";
}