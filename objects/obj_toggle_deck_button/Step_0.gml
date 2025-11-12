//if (drawer_open) {
//	// drawer is open, move to the left
//	x = room_width - 300 - buffer_size; //drawer width
//	image_angle = 90;
//} else {
//	//drawer closed, move to the right
//	x = room_width - buffer_size;
//	image_angle = -90;
//}

// Step Event

// update target positions based on drawer state
if (drawer_open) {
    x_target = room_width - drawer_width - buffer_size;
    angle_target = -90; // facing left
} else {
    x_target = room_width - buffer_size;
    angle_target = 90; // facing right
}

// smooth movement and rotation
x = lerp(x, x_target, move_speed);
image_angle = lerp(image_angle, angle_target, rot_speed);

// when close enough, snap to final position to avoid jitter
if (abs(x - x_target) < 0.5) x = x_target;
if (abs(image_angle - angle_target) < 0.5) image_angle = angle_target;
