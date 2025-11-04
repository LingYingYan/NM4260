var gui_width = display_get_gui_width();
var gui_height = display_get_gui_height();

self.gui_x = self.x >= 0 ? self.x : gui_width * self.left_offset / 100;
self.gui_y = self.y >= 0 ? self.y : gui_height * self.top_offset / 100;
