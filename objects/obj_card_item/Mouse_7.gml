if (self.state == CardState.Dragging) {
    self.state = CardState.Released;
    var event = new CardDroppedEvent(self.id);
    global.events.broadcast(event);
}