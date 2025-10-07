if (ds_map_find_value(async_load, "id") == self.__private.file && ds_map_find_value(async_load, "status") == 0) {
    self.__private.grid = load_csv(async_load[? "result"]);
    event_user(0);
}