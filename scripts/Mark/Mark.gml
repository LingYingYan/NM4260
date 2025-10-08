/// @desc Function Description
/// @param {string} mark_id description
/// @param {string} mark_name Description
/// @param {Asset.GMSprite} mark_sprite description
/// @param {string} dominated_mark description
function Mark(mark_id, mark_name, mark_sprite, dominated_mark) constructor {
    uid = mark_id;
    type = mark_name;
    sprite = mark_sprite;
    dominated_mark_id = dominated_mark;
    
    on_apply = function(target, multiplicity = 1) { }
}

/// @desc Function Description
/// @param {string} mark_id description
/// @param {string} display_name Description
/// @param {Asset.GMSprite} mark_sprite description
/// @param {string} dominated_mark description
function make_mark(mark_id, display_name, mark_sprite, dominated_mark) {
    switch (mark_id) {
    	case "mark_fire":
            return new FireMark(mark_id, display_name, mark_sprite, dominated_mark);
        case "mark_water":
            return new WaterMark(mark_id, display_name, mark_sprite, dominated_mark);
        case "mark_grass":
            return new GrassMark(mark_id, display_name, mark_sprite, dominated_mark);
    }
}

function FireMark(mark_id, mark_name, mark_sprite, dominated_mark) : Mark(mark_id, mark_name, mark_sprite, dominated_mark) constructor {
    on_apply = function(target, multiplicity = 1) {
        var dominated_count = target.count_mark(self.dominated_mark_id);
        var n_eliminated = min(dominated_count, multiplicity);
        var remaining = multiplicity - n_eliminated;
        if (n_eliminated > 0) {
            target.add_marks(self.dominated_mark_id, -n_eliminated);
            target.add_status(new Burn(n_eliminated * 2));
            show_debug_message("Burn +" + string(n_eliminated));
        }
        
        if (remaining > 0) {
            show_debug_message("Fire +" + string(remaining));
            target.add_marks(self.uid, multiplicity)
        }
    }
} 

function WaterMark(mark_id, mark_name, mark_sprite, dominated_mark) : Mark(mark_id, mark_name, mark_sprite, dominated_mark) constructor {
    on_apply = function(target, multiplicity = 1) {
        show_debug_message("Water!");
        var dominated_count = target.count_mark(self.dominated_mark_id);
        var n_eliminated = min(dominated_count, multiplicity);
        var remaining = multiplicity - n_eliminated;
        if (n_eliminated > 0) {
            target.hp -= n_eliminated
            show_debug_message("Water damage +" + string(n_eliminated));
        }
        
        if (remaining > 0) {
            show_debug_message("Water +" + string(remaining));
            target.add_marks(self.uid, multiplicity)
        }
    }
} 

function GrassMark(mark_id, mark_name, mark_sprite, dominated_mark) : Mark(mark_id, mark_name, mark_sprite, dominated_mark) constructor {
    on_apply = function(target, multiplicity = 1) {
        var dominated_count = target.count_mark(self.dominated_mark_id);
        var n_eliminated = min(dominated_count, multiplicity);
        var remaining = multiplicity - n_eliminated;
        if (n_eliminated > 0) {
            target.add_marks(self.dominated_mark_id, -n_eliminated);
            target.add_status(new Poison(n_eliminated * 2));
            show_debug_message("Poison +" + string(n_eliminated));
        }
        
        if (remaining > 0) {
            show_debug_message("Grass +" + string(remaining));
            target.add_marks(self.uid, multiplicity)
        }
    }
} 