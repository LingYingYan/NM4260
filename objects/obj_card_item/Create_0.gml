// --- Fields ---
state = CardState.Static;
drag_origin_x = undefined;
drag_origin_y = undefined;

// --- Methods ---

/// @desc Drops a card
/// @param {Id.Instance} to The drop location 
drop = function Drop(to) {
    if (to == noone) {
        self.x = drag_origin_x;
        self.y = drag_origin_y;
    } else {
        self.x = to.x;
        self.y = to.y;
    }
}

/// @desc Hovers over a card
function Hover() {
    self.state = CardState.Hovered;
    self.depth = 
}