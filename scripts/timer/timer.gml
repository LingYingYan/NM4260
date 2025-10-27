
/**
 * Function Description
 * @param {real} duration description
 * @param {Function} on_time_out Description
 * @param {array} args Description
 */
function timer(duration, on_time_out, args, reps = 1) {
    var time_source = time_source_create(time_source_game, duration, time_source_units_seconds, on_time_out, args, reps);
    return time_source;
}