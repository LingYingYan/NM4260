global.events = new EventBus();

global.events.on_event(nameof(DebugMessageEvent), HandleDebugEvent);

global.events.broadcast(new DebugMessageEvent("Hello World!"));

/// @desc Handle a debug event
/// @param {Struct.DebugMessageEvent} event The event
function HandleDebugEvent(event) {
    show_debug_message($"Event {event.type} with message {event.msg}!");
}