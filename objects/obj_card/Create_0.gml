moused = false;
hovered = false;
grabbable = true;
selectable = false;
picked_up = false;
scale = self.image_xscale;

goal_x = self.x;
goal_y = self.y;
normal_depth = self.depth;
current_depth = self.depth;

card_data = undefined;
dropped_area = noone;

reveal = 0;
desc = "";

set_reveal = function(value) {
    self.reveal = value;
    if (self.card_data != undefined) {
        self.desc = self.card_data.describe(self.reveal);
    }
}

state_normal = function() {
	if (obj_mouse_manager.grabbed_card != self) {
		if (!self.picked_up) {
			self.x = lerp(self.x, self.goal_x, 0.5);
			self.y = lerp(self.y, self.goal_y, 0.5);
			if (x < goal_x + 1 && x > goal_x - 1 && y < goal_y + 1 && y > goal_y - 1) {
				self.current_depth = self.normal_depth;
			}
		}

		picked_up = false;
	} else {
		picked_up = true;
		self.current_depth = -10000;
    }
}

state_update = self.state_normal;
