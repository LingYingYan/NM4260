/// @desc Function Description
/// @param {string} mark_name Description
/// @param {Asset.GMSprite} mark_sprite description
function Mark(mark_name, mark_sprite) constructor {
    type = mark_name;
    sprite = mark_sprite;
    
    on_apply = function(target, multiplicity = 1) { }
}

/**
 * Factory function to create a mark struct from a resource object
 * @param {id.instance} resource The mark resource object instance
 * @return {Struct.Mark} A mark struct
 */
function make_mark_from(resource) {
    if (resource == undefined || resource == noone) {
        return { };
    }
    
    switch (resource.type) {
    	case "Fire":
            return new FireMark(resource.sprite);
        case "Water":
            return new WaterMark(resource.sprite);
        case "Grass":
            return new GrassMark(resource.sprite);
    }
}

function FireMark(mark_sprite) : Mark("Fire", mark_sprite) constructor {
    on_apply = function(target, multiplicity = 1) {
        show_debug_message("Fire!");
    }
} 

function WaterMark(mark_sprite) : Mark("Water", mark_sprite) constructor {
    on_apply = function(target, multiplicity = 1) {
        show_debug_message("Water!");
    }
} 

function GrassMark(mark_sprite) : Mark("Grass", mark_sprite) constructor {
    on_apply = function(target, multiplicity = 1) {
        show_debug_message("Grass!");
    }
} 