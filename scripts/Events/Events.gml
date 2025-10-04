/// @desc Creates an event.
/// @param {String} _type The event type.
function Event(_type) constructor {
    type = _type;
}

/// @desc Creates a debug message event.
/// @param {String} _msg The message.
function DebugMessageEvent(_msg) : Event(nameof(DebugMessageEvent)) constructor {
    msg = _msg;
}

/// @desc Creates a card drop event.
/// @param {Id.Instance} _card The card instance.
function CardDroppedEvent(_card) : Event(nameof(CardDroppedEvent)) constructor {
    card = _card;
}