// Only runs once when the game launches
randomize();

global.map_needs_reset = false;
global.map_inited      = false;

global.GRID_W = 5;
global.GRID_H = 4;
global.ROOM_SIZE = 64;

// Global room grid holder
global.room_grid = []; // will be filled by generate_map()

global.bonfire_used = false;
