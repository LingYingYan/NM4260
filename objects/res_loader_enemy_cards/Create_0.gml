loaded = ds_map_create();
var n = instance_number(res_card_group);
for (var i = 0; i < n; i += 1) {
    var data = instance_find(res_card_group, i);
    if (!ds_map_exists(self.loaded, data.owner)) {
        ds_map_add(self.loaded, data.owner, []);
    }
    
    var idx = array_length(self.loaded[? data.owner]);
    self.loaded[? data.ower][idx] = data;
}

/**
 * @param {Asset.GMObject} enemy_id The enemy's object ID
 **/
get = function(enemy_id) {
    return self.loaded[? object_id];
}