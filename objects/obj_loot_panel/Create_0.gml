items = [];

/**
 * @desc 
 * @param {id.instance} item description
 */
add_item = function(item) {
    var gui_top = display_get_gui_height() / 2 - self.height / 2;
    item.x = display_get_gui_width() / 2;
    if (array_length(self.items) == 0) {
        item.y = gui_top + self.item_sep + item.height / 2;
    } else {
        item.y = array_last(self.items).y + item.height + self.item_sep;
    }
    
    item.depth = self.depth - 1;
    array_push(self.items, item);
}

/**
 * @desc 
 * @param {id.instance} item description
 */
remove_item = function(item) {
    var idx = array_get_index(self.items, item);
    if (idx < 0) {
        return;
    }
    
    array_delete(self.items, idx, 1);
    instance_destroy(item);
    var len = array_length(self.items);
    if (len > 0) {
        self.items[0].y = display_get_gui_height() / 2 - self.height / 2 + self.item_sep + self.items[0].height / 2;
        for (var i = 1; i < len; i += 1) {
            var sep = self.items[i - 1].sprite_height / 2 + self.items[i].sprite_height / 2 + self.item_sep;
            self.items[i].y = self.items[i - 1].y + sep;
        }
    }
}

hide = function() {
    self.visible = false;
    for (var i = 0; i < array_length(self.items); i += 1) {
        self.items[i].visible = false;
    }
}

show = function() {
    self.visible = true;
    for (var i = 0; i < array_length(self.items); i += 1) {
        self.items[i].visible = true;
    }
}