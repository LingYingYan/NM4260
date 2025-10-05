// --- Fields ---
state = CardState.Static;
original_depth = undefined;
drag_origin_x = undefined;
drag_origin_y = undefined;

// --- Methods ---

/// @desc Drops a card
/// @param {Id.Instance} to The drop location 
drop = function(to) {
    if (to == noone) {
        self.restore();
    } else {
        self.x = to.x;
        self.y = to.y;
    }
}

/// @desc Hovers over a card
hover = function() {
    if (self.state == CardState.Hovered) {
        return;
    }
    
    self.original_depth = self.depth;
    self.state = CardState.Hovered;
}

restore = function() {
    if (self.state == CardState.Static) {
        return;
    }
    
    self.depth = self.original_depth
    self.state = CardState.Static;
    if (self.drag_origin_x != undefined && self.drag_origin_y != undefined) {
        self.x = self.drag_origin_x;
        self.y = self.drag_origin_y;
        self.drag_origin_x = undefined;
        self.drag_origin_y = undefined;
    }
}