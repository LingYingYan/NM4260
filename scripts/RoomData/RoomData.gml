function RoomData(room_type) constructor {
    type = root_type;
    neighbours = ds_map_create();
    
    add_neighbour = function(r, c) {
        if (!ds_map_exists(self.neighbours, r)) {
            ds_map_add(self.neighbours, r, c);
        }
    }
}