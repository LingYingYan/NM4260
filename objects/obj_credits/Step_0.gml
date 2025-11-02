if (alpha < 1) alpha = min(1, alpha + fade_in_speed);

// Check if clicked on close button
if (mouse_check_button_pressed(mb_left)) {
    if (point_in_rectangle(mouse_x, mouse_y, close_x1, close_y1, close_x2, close_y2)) {
        instance_destroy(); // close window
    }
}
