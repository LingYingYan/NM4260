if (point_distance(x, y, target_x, target_y) > move_speed) {
    var dir = point_direction(x, y, target_x, target_y);
    x += lengthdir_x(move_speed, dir);
    y += lengthdir_y(move_speed, dir);
} else {
    x = target_x;
    y = target_y;
}