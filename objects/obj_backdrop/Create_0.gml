open = function() {
    var d = self.depth;
    with (all) {
        d = min(d, depth);   
    }
    
    self.depth = d;
    self.visible = true;
}