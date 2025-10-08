if (ds_exists(self.__private.grid, ds_type_grid)) {
    ds_grid_destroy(self.__private.grid);
}