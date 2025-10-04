switch (self.state) {
    case CardState.Dragging:
        self.x = mouse_x;
        self.y = mouse_y;
        break;
    case CardState.Released:
        self.state = CardState.Static;
        break;
}
