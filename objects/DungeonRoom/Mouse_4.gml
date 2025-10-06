/// obj_room: Left Pressed
// Only respond if there's an avatar in play
show_debug_message("the left press event is triggered")

if (!instance_exists(Player)) exit;
var player = instance_find(Player, 0);
show_debug_message($"current room {player.current_room}")

// Only allow move if this room is adjacent (connected)
if (player.current_room != noone) {
    var canMove = false;
    var curr = player.current_room;

    // check if this room is a neighbor
    for (var i = 0; i < array_length(curr.neighbors); i++) {
        if (curr.neighbors[i].id == id) {
            canMove = true;
            break;
        }
    }

    if (canMove) {
        player.target_x = x;
        player.target_y = y;
        player.current_room = id;
    } else {
        show_debug_message("Cannot move — not connected!");
    }
}
