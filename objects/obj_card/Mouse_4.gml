/// @description Check if player mouses over and do stuff.
// If the player has pressed left mouse button, and they're moused over us
if (self.grabbable) {
	obj_mouse_manager.update_looking_at();
	if (obj_mouse_manager.looking_at == id) {
		obj_mouse_manager.grabbed_card = self;
	}
}

