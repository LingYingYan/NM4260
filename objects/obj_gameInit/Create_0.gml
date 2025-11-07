randomize();
show_debug_message("GameInit SCript is running")
global.map_needs_reset = false;
global.map_inited = false;

global.in_tut = false; // if in tutorial, change the reveal_room etc
global.dist_start_end = -1; //default is -1
global.num_enemy_rooms = -1;

global.GRID_W = 6;
global.GRID_H = 5;
global.ROOM_SIZE = 128;
global.ROOM_SPACING = 42; // very likely need to adjust later, this is based on the sprite i draw

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

// encounters
global.encounter_cases = [
	make_encounter(
		"The Whispering Wall",
		"A section of the labyrinth wall pulsates faintly, whispering voices of lost Masters pleading to be freed. Their words are fragmented but strangely familiar.",
		[
			make_option(
				"Listen Closely", 
				"The voices reveal a hidden rune sequence. (-1 Vision, +1 Card)",
				
				function() {
					var new_card = res_loader_cards.get_random_card("Instances");
					show_debug_message($"card data of the acquired card: {new_card.card_data}")
					var card_inst = instance_create_layer(room_width/2, room_height/2, "Instances", obj_deck_drawer_card);
					card_inst.card_data = new_card.card_data;
					card_inst.image_xscale = 0.7;
					card_inst.image_yscale = 0.7;
					card_inst.depth = -30000;
					card_inst.reveal = obj_player_state.data.max_vision;
					
					obj_player_deck_manager.add(new_card);
					if (obj_player_state.data.vision >= 1) obj_player_state.data.vision -= 1;
					else obj_player_state.data.vision = 0;
					
					show_debug_message($"now the player deck length is {array_length(obj_player_deck_manager.denumerate())}")
				}
				
			),
			make_option(
				"Ignore the whispers.",
				"You avoid distraction, but feel uneasy. (-2 HP)",
				function() {
					obj_player_state.data.hp -= 2;
				}
			)
		]),
		
	make_encounter(
		"The Vision Pool",
		"A shallow pool reflects countless futures of yourself, flickering with visions of alternate timelines.",
		[
			make_option(
				"Gaze deeply.",
				"You glimpse a safe path ahead. (-1 Vision)",
				function() {
					var count = 3
					for (var row = 0; row < array_length(global.room_grid); row++) {
					    for (var col = 0; col < array_length(global.room_grid[row]); col++) {
					        var rm = global.room_grid[row][col];
							if (rm != noone && rm.discovered == false) {
								//reveal 3 un discovered room
								rm.discovered = true
								count -=1;
								if (count <= 0) break;
							}
						}
						if (count <= 0) break;
					}
					if (obj_player_state.data.vision >= 1) obj_player_state.data.vision -= 1;
					else obj_player_state.data.vision = 0;
					show_debug_message("revealed 3 rooms on the map")
				}	
			),
			make_option(
				"Touch the water.",
				"You absorb fragments of power, but they sting. (+1 Vision, -10 HP)",
				function() {
					if (obj_player_state.data.hp >= 10) obj_player_state.data.hp -= 10;
					else obj_player_state.data.hp = 0;
					obj_player_state.data.vision += 1;
				}
			)
		]
	)
];


