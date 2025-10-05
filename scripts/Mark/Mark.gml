/// @desc Function Description
/// @param {string} mark_name Description
/// @param {real} mark_count Description
/// @param {Asset.GMSprite} mark_sprite description
function Mark(mark_name, mark_count, mark_sprite) constructor {
    type = mark_name;
    count = mark_count;
    sprite = mark_sprite;
    
    on_apply = function(target) { }
}

function FireMark(mark_count) : Mark("Fire", mark_count, spr_fire_mark) constructor {
    on_apply = function(target) {
        show_debug_message("Fire!");
    }
} 