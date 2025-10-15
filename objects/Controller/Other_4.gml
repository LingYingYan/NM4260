if (!global.map_inited || global.map_needs_reset) {

    if (global.map_needs_reset) {
        show_debug_message("Resetting map...");
        reset_map(15); // bonfire reset 
    } else {
        show_debug_message("Initializing new map...");
        initialize_map(15, false); // first time generation
    }

    global.map_inited = true;
    global.map_needs_reset = false;

} else {
    show_debug_message("Rebuilding map visuals from stored room_grid...");
    generate_from_grid(); // reuse existing data and recreate visuals
}

var cam_w = camera_get_view_width(view_camera[0]);
var cam_h = camera_get_view_height(view_camera[0]);
var cam = camera_create_view(0, 0, cam_w, cam_h);
view_enabled = true;
view_visible[0] = true;
view_set_camera(0, cam);

// 2️⃣ Compute map size
var map_w = global.GRID_W * global.ROOM_SIZE;
var map_h = global.GRID_H * global.ROOM_SIZE;

// 3️⃣ Center camera on map
var cam_x = (map_w - cam_w) / 2;
var cam_y = (map_h - cam_h) / 2;
camera_set_view_pos(cam, cam_x, cam_y);
