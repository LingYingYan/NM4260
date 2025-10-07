loaded = [];
total_weight = 0;

var n = instance_number(res_card);
for (var i = 0; i < n; i += 1) {
    var data = instance_find(res_card, i);
    self.loaded[array_length(self.loaded)] = data;
    self.total_weight += data.get_weight();
}