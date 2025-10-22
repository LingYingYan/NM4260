/// @desc  Function Description
/// @param {real} to_display  Description
/// @param {real} benchmark  Description
/// @param {bool} [better_if_more_than_benchmark]=true Description
function stylise_numeric_text(to_display, benchmark, better_if_more_than_benchmark = true){
    var text = string(to_display);
    if (to_display < benchmark) {
        text = better_if_more_than_benchmark ? $"[c_red]{text}[/c]" : $"[c_green]{text}[/c]";
    } else if (to_display > benchmark) {
        text = better_if_more_than_benchmark ? $"[c_green]{text}[/c]" : $"[c_red]{text}[/c]";
    }
    
    return text;
}