randomize();
show_debug_message("GameInit SCript is running")
global.map_needs_reset = false;
global.map_inited      = false;

global.GRID_W = 5;
global.GRID_H = 4;
global.ROOM_SIZE = 64;

global.room_grid = []; // will be filled by generate_map()

global.bonfire_used = false; // deactivate bonfire after used once
global.generate_new = true;