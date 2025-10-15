// Make sure global flags exist (safety)
if (!variable_global_exists("map_needs_reset")) {global.map_needs_reset = false; show_debug_message("setting maps_needs_reset to false"); }
if (!variable_global_exists("map_inited"))     { global.map_inited = false; show_debug_message("setting map_inited to false");}

//if (!global.map_inited || global.map_needs_reset) {
//    if (global.map_needs_reset){
//		show_debug_message("calling reset_map inside mapController");
//        reset_map(15); // spawn at bonfire
//	}
//    else {
//		show_debug_message("calling init_map inside mapController");
//        initialize_map(15, false); // normal first generation
//	}
//    global.map_needs_reset = false;
//} else {
//    show_debug_message("Map already inited: reusing existing layout");
//}
