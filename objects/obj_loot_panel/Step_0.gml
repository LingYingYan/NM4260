if (array_length(self.items) == 0) {
    exit;
}

if (array_length(self.items) == 1) {
    self.items[0].is_disabled = false;
    exit;
}

array_last(self.items).is_disabled = true;

for (var i = 0; i < array_length(self.items) - 1; i += 1) {
    self.items[i].is_disabled = false;
}