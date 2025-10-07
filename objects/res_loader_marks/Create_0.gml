loaded = ds_map_create();
var n = instance_number(res_mark);
for (var i = 0; i < n; i += 1) {
    var data = instance_find(res_mark, i);
    ds_map_add(self.loaded, data.object_index, data);
}

get = function(object_id) {
    return self.loaded[? object_id];
}