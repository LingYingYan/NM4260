self.image_xscale = 5;
self.image_yscale = 5;
self.image_speed = 0;

y_goal = self.y + move_dist;

step = function() {
    self.image_xscale = lerp(self.image_xscale, 2, self.lerp_speed);
    self.image_yscale = lerp(self.image_yscale, 2, self.lerp_speed);
    self.image_alpha -= 0.01;
    if (self.image_alpha <= 0) {
        instance_destroy(self.id);
    }
    
    self.y = lerp(self.y, self.y_goal, self.lerp_speed);
}