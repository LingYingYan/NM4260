/// @desc Process the grid loaded from the csv.

switch (self.data_group) {
	case "By Row":
        for (var r = 1; r < ds_grid_height(self.__private.grid); r += 1) {
            self.read_row(r);        
        }
    
        break;
    case "By Column":
        for (var c = 1; c < ds_grid_width(self.__private.grid); c += 1) {
            self.read_col(c);
        }
    
        break;
}

self.is_loaded = true;