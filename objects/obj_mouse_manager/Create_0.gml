looking_at = noone;
grabbed_card = noone;
global.pause = false;
global.mute = false;

update_looking_at = function() {
	var list = ds_list_create();
    var collisions = collision_point_list(mouse_x, mouse_y, obj_card, false, true, list, false);
    var topmost = noone;
    if (collisions > 0) { 
        for (var i = 0; i < collisions; i += 1;) {
            if (topmost == noone || list[| i].depth < topmost.depth) {
                topmost = list[| i];
            } 
        }
        
        self.looking_at = topmost; 
    } else { 
        self.looking_at = noone; 
    }

    ds_list_destroy(list);	
}