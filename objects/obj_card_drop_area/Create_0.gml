/// @desc Handle a debug event
/// @param {Struct.CardDroppedEvent} event The event
handle_card_dropped = function HandleCardDroppedEvent(event) {
    if (collision_point(event.card.x, event.card.y, self.id, false, false) == noone) {
        event.card.drop(noone);
    } else {
        event.card.drop(self.id);
    }
}

global.events.on_event(nameof(CardDroppedEvent), handle_card_dropped);
