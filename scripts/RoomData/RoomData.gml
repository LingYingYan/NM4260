function RoomData(discovered, visited, room_type, grid_x, grid_y) constructor{
	
	self.room_type = room_type;
	self.grid_x = grid_x;
    self.grid_y = grid_y;
    self.visited = visited;
    self.discovered = discovered;
    self.neighbors = [];
	self.degree_cap = 3;
	
	self.set_visited = function() {
        self.visited = true;
    };
	
	self.add_neighbors = function(neighbor) {
        if (!array_contains(self.neighbors, neighbor)) {
            array_push(self.neighbors, neighbor);
        }
    };

	self.debug_print = function() {
        show_debug_message(
            "Room (" + string(self.grid_x) + "," + string(self.grid_y) + 
            ") type=" + string(self.room_type) + 
            " discovered=" + string(self.discovered) + 
            " visited=" + string(self.visited)
        );
    };
}
