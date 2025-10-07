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
        show_debug_message("Fire!");
    }
} 

function WaterMark(mark_id, mark_name, mark_sprite, dominated_mark) : Mark(mark_id, mark_name, mark_sprite, dominated_mark) constructor {
    on_apply = function(target, multiplicity = 1) {
        show_debug_message("Water!");
    }
} 

function GrassMark(mark_id, mark_name, mark_sprite, dominated_mark) : Mark(mark_id, mark_name, mark_sprite, dominated_mark) constructor {
    on_apply = function(target, multiplicity = 1) {
        show_debug_message("Grass!");
    }
} 