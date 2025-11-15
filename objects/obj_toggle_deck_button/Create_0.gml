drawer_open = false;
buffer_size = 25;
drawer_width = 300;

x_target = room_width - buffer_size;   
x = x_target;
angle_target = 90;
image_angle = angle_target;

move_speed = 0.2; 
rot_speed = 0.2;

depth = -25000;

instance_create_layer(room_width - 20, room_height/2, "Instances", obj_deck_drawer);