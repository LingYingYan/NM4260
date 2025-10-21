if (!global.map_inited || global.map_needs_reset) {

    if (global.map_needs_reset) {
        show_debug_message("Resetting map...");
        reset_map(18); // bonfire reset 
    } else {
        show_debug_message("Initializing new map...");
        initialize_map(18, false); // first time generation
    }

    global.map_inited = true;
    global.map_needs_reset = false;

} else {
    show_debug_message("Rebuilding map visuals from stored room_grid...");
    generate_from_grid(); // reuse existing data and recreate visuals
}

