randomize();
show_debug_message("GameInit SCript is running")
global.map_needs_reset = false;
global.map_inited = false;

global.in_tut = false; // if in tutorial, change the reveal_room etc
global.ele_react_tut_shown = false;
global.dist_start_end = -1; //default is -1
global.num_enemy_rooms = -1;

global.GRID_W = 6;
global.GRID_H = 5;
global.ROOM_SIZE = 114; //#128
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

// encounters
global.encounter_cases = [
	make_encounter(
		"The Whispering Wall",
		"A section of the labyrinth wall pulsates faintly, whispering voices of lost Masters pleading to be freed. Their words are fragmented but strangely familiar.",
		[
			make_option(
				"Listen Closely", 
				scribble("The voices reveal a hidden rune sequence. [b](-1 Vision, +1 Card)[/b]")
					.align(fa_center, fa_middle),
				
				function() {
					var new_card = res_loader_cards.get_random_card("Instances");
					show_debug_message($"card data of the acquired card: {new_card.card_data}")
					var card_inst = instance_create_layer(room_width/2, room_height/2, "Instances", obj_deck_viewonly_card);
					card_inst.card_data = new_card.card_data;
					card_inst.count = 1;
					card_inst.image_xscale = 1;
					card_inst.image_yscale = 1;
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
				scribble("You avoid distraction, but feel uneasy. [b](-2 HP)[/b]")
					.align(fa_center, fa_middle),
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
				scribble("You glimpse a safe path ahead. [b](-1 Vision)[/b]")
					.align(fa_center, fa_middle),
				function() {
					var count = 3
					var room_list = [];
					for (var row = 0; row < array_length(global.room_grid); row++) {
					    for (var col = 0; col < array_length(global.room_grid[row]); col++) {
					        var rm = global.room_grid[row][col];
							if (rm != noone && rm.discovered == false) {
								//reveal 3 un discovered room
								array_push(room_list, rm);
								//rm.discovered = true
								//count -=1;
								//if (count <= 0) break;
							}
						}
						//if (count <= 0) break;
					}
					
					room_list = array_shuffle(room_list);
					
					if (!global.is_tut && array_length(room_list) >= 3) {
						// not in the tut and the undiscovered room is >=3
						for (i = 0; i < count; i++) {
							var lst_rm = room_list[i];
							lst_rm.discovered = true;
							lst_rm.revealed = true;
						}
					} else if (array_length(room_list) > 0) {
						for (i = 0; i < array_length(room_list); i++) {
							var lst_rm = room_list[i];
							lst_rm.discovered = true;
							lst_rm.revealed = true;
						}
					} 
					
					if (obj_player_state.data.vision >= 1) obj_player_state.data.vision -= 1;
					else obj_player_state.data.vision = 0;
					show_debug_message("revealed 3 rooms on the map")
				}	
			),
			make_option(
				"Touch the water.",
				scribble("You absorb fragments of power, but they sting. [b](+1 Vision, -10 HP)[/b]")
						.align(fa_center, fa_middle),
				function() {
					if (obj_player_state.data.hp >= 10) obj_player_state.data.hp -= 10;
					else obj_player_state.data.hp = 0;
					obj_player_state.data.vision += 1;
				}
			)
		]
	),
	
	make_encounter(
		"The Alchemist’s Corpse",
		"A long-dead alchemist slumps over his cauldron. The liquid inside still bubbles faintly.",
		[
			make_option(
				"Drink the potion.",
				scribble("You feel something is happening in your body")
					.align(fa_center, fa_middle),
				function() {
					var prob = random(1);
					if (prob < 0.5) {
						// increase hp by 20
						if (obj_player_state.data.hp >= 80) {
							obj_player_state.data.hp = obj_player_state.data.max_hp;
						} else {
							obj_player_state.data.hp += 20;
						}
						
					} else if (prob > 0.7) {
						if (obj_player_state.data.vision >= 4) {
							obj_player_state.data.vision = obj_player_state.data.max_vision;
						} else {
							obj_player_state.data.vision += 1;
						}
					} else {
						if (obj_player_state.data.hp <= 10) {
							obj_player_state.data.hp = 0;
						} else {
							obj_player_state.data.hp -= 10;
						}
					}
				}
				
			),
			
			make_option(
				"Leave",
				scribble("Nothing happens")
					.align(fa_center, fa_middle),
				function() {
				}
			)
		]
	),
	
	make_encounter(
		"The Master's Diary Fragment",
		"A torn diary page lies under a pile of bones, inscribed with an incantation your Master once taught you—but something feels corrupted.",
		[
			make_option(
				"Study it carefully.",
				scribble("You decipher the safe version of the spell.[b](-1 Vision)[/b]")
					.align(fa_center, fa_middle),
				function() {
					var new_card = res_loader_cards.get_random_card("Instances");
					show_debug_message($"card data of the acquired card: {new_card.card_data}")
					var card_inst = instance_create_layer(room_width/2, room_height/2, "Instances", obj_deck_viewonly_card);
					card_inst.card_data = new_card.card_data;
					card_inst.count = 1;
					card_inst.image_xscale = 1;
					card_inst.image_yscale = 1;
					card_inst.depth = -30000;
					card_inst.reveal = obj_player_state.data.max_vision;
					
					obj_player_deck_manager.add(new_card);
					if (obj_player_state.data.vision >= 1) obj_player_state.data.vision -= 1;
					else obj_player_state.data.vision = 0;
				}
			),
			
			make_option(
				"Burn it.",
				scribble("The dark energy dissipates harmlessly.[b](-1 Fire Card, +15 HP)[/b]")
					.align(fa_center, fa_middle),
				function() {
					var cd_lst = [];
					var cards = obj_player_deck_manager.denumerate();
					for (i = 0; i < array_length(cards); i++) {
						var cd_id = cards[i].uid;
						if (cd_id == "card_fireball") {
							obj_player_deck_manager.remove_first(cards[i]);
							break;			
						}
					}
					
					if (obj_player_state.data.hp <= 15) obj_player_state.data.hp = 0;
					else obj_player_state.data.hp -= 15;
				}
			)
		]
	)
];


