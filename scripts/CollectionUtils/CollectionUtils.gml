/// @desc  Perform an action for each key-value pairs in the map
/// @param {Id.DsMap} map  The map
/// @param {Function} action  A function that takes in a key as the argument
function for_each_key_in_map(map, action) {
    for (var k = ds_map_find_first(map); !is_undefined(k); k = ds_map_find_next(map, k)) { 
        action(k);
    }
}

/// @desc  Perform an action for each key-value pairs in the map
/// @param {Id.DsMap} map  The map
/// @param {Function} action  A function that takes in a value as the argument
function for_each_value_in_map(map, action) {
    for (var k = ds_map_find_first(map); !is_undefined(k); k = ds_map_find_next(map, k)) { 
        action(ds_map_find_value(map, k));
    }
}

/// @desc  Perform an action for each key-value pairs in the map
/// @param {Id.DsMap} map  The map
/// @param {Function} action  A function that takes in a key and a value as arguments
function for_each_entry_in_map(map, action) {
    for (var k = ds_map_find_first(map); !is_undefined(k); k = ds_map_find_next(map, k)) { 
        action(k, ds_map_find_value(map, k));
    }
}