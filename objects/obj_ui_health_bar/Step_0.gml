if (self.source != undefined) {
    if (self.source.hp != self.current) {
        var change = self.source.hp - self.current;
        var text_displacement = !self.label_below_bar ? irandom_range(-80, -40) : irandom_range(40, 80);
        instance_create_depth(self.x, self.y, self.depth - 10000, obj_floating_text, {
            text: change > 0 ? $"[c_green]+{change}[/c]" : $"[c_red]{change}[/c]",
            move_dist: text_displacement
        });    
    }
    
    self.current = self.source.hp;    
    self.max_value = self.source.max_hp;
}

if (max_value > 0) {
    self.image_xscale = self.normal_scale * self.current / self.max_value;
} else {
    self.image_xscale = self.normal_scale;
}