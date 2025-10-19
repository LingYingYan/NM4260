function room_to_gui_x(x_room){
    // Choose which camera/view you're working with (e.g. view 0)
    //var cam = view_camera[0];
    //var cam_x = camera_get_view_x(cam);
    //var cam_w = camera_get_view_width(cam);
    
    // GUI size
    //var gui_w = display_get_gui_width();
    
    // Compute relative offset inside the view
    //var rel_x = x_room - cam_x;
    
    // Normalize (0..1) relative to view dimensions
    //var rel_x_norm = rel_x / cam_w;
    
    // Scale to GUI size
    //return rel_x_norm * gui_w;
    var _relative_x = x_room - camera_get_view_x(view_camera[0]);
    return (_relative_x / camera_get_view_width(view_camera[0])) //* display_get_gui_width();
}

function room_to_gui_y(y_room){
    // Choose which camera/view you're working with (e.g. view 0)
    var cam = view_camera[0];
    var cam_y = camera_get_view_y(cam);
    var cam_h = camera_get_view_height(cam);
    
    // GUI size
    var gui_h = display_get_gui_height();
    
    // Compute relative offset inside the view
    var rel_y = y_room - cam_y;
    
    // Normalize (0..1) relative to view dimensions
    var rel_y_norm = rel_y / cam_h;
    
    // Scale to GUI size
    return rel_y_norm * gui_h;
}