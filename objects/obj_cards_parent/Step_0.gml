/// @description Check if the cursor is over us.
// If the cursor is over us
if (collision_point(mouse_x, mouse_y, self, false, false) != noone) {
	// Set moused to true
	moused = true;
}
else
{
	// Otherwise, to false.
	moused = false;
}

switch (self.state) {
	case CardState.Static:
        // If static, check if we are hovered
        if (collision_point(mouse_x, mouse_y, self, false, false) != noone) {
            self.state = CardState.Hovered;
        }
    
        break;
    case CardState.Hovered:
        if (mouse_check_button_pressed(mb_left)) {
            self.state = CardState.Dragging;
            self.drag_origin_x = self.x;
            self.drag_origin_y = self.y;
        }
    
        break;
    case CardState.Dragging:
        if (mouse_check_button_released(mb_left)) {
            self.state = CardState.Released;
        }
    
        break;
    case CardState.Released:
        self.x = self.drag_origin_x;
        self.y = self.drag_origin_y;
        self.state = CardState.Static;
        break;
}