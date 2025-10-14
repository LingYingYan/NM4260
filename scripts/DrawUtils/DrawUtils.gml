/// @desc Function Description
/// @param {string} text Description
/// @param {id.instance} container_obj Description
/// @param {Constant.HAlign} halign Description
/// @param {Constant.VAlign} valign Description
/// @param {real} pos_x Description
/// @param {real} pos_y Description
/// @param {real} margin_left 
/// @param {real} margin_right 
/// @param {real} margin_top
/// @param {real} margin_bottom 
/// @param {Constant.Color} colour Description
/// @param {real} alpha Description
/// @param {Asset.GMFont} font Description
/// @param {bool} follow_container_orientation Description
function put_text(
    text, container_obj, halign, valign, pos_x, pos_y,
    margin_left, margin_right, margin_top, margin_bottom, 
    colour, alpha = 1, font = fnt_default, follow_container_orientation = true
) {
    draw_set_font(font);
    draw_set_halign(halign);
    draw_set_valign(valign);
    
    var text_w = (container_obj.sprite_width - margin_left - margin_right) / container_obj.image_xscale;
    draw_text_ext_transformed_color(
        pos_x, pos_y, text, -1, text_w,
        container_obj.image_xscale, container_obj.image_yscale, container_obj.image_angle,
        colour, colour, colour, colour, alpha
    );
    
    draw_set_valign(fa_top);
    draw_set_halign(fa_left);
    draw_set_font(fnt_default);
}