if (!self.visible) {
    exit;
}

var d = self.depth;
with (all) {
    d = min(d, depth);   
}

self.depth = d;
draw_self();