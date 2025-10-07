__private = {
    path: working_directory + self.save_file_name,
    file: undefined,
    grid: undefined,
    url: $"https://docs.google.com/spreadsheets/d/{self.google_sheet_id}" +
         $"/export?format=csv&id={self.google_sheet_id}&gid=0",
};

is_loaded = false;


download = function() {
    self.__private.file = http_get_file(self.__private.url, self.__private.path);
}

load = function() {
    switch (self.load_from) {
        case "Google Sheet":
    	    self.download();
            break;
        case "Included Files":
            self.__private.grid = load_csv(self.local_file);
            event_user(0);
            break;
    }
}

read_cell = function(r, c) {
    return self.__private.grid[# c, r];
}

/// @desc Read a row in the csv
/// @param {real} r The row index
read_row = function(r) { }

/// @desc Read a column in the csv
/// @param {real} c The column index
read_col = function(c) { }
