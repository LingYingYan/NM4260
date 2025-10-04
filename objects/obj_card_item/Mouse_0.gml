if (self.state == CardState.Hovered) {
    self.state = CardState.Dragging;
    self.drag_origin_x = self.x;
    self.drag_origin_y = self.y;
}