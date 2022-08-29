import 'dart:async';


class EventBus {

  EventBus({
    bool sync = false,
  }) : _streamController = StreamController.broadcast(sync: sync);

  EventBus.customController(
      StreamController controller,
      ) : _streamController = controller;

  factory EventBus._() {
    if (_instance == null) {
      _instance = EventBus();
    }
    return _instance!;
  }

  static EventBus? _instance;

  static EventBus get instance {
    return EventBus._();
  }

  StreamController _streamController;

  /// Controller for the event bus stream.
  StreamController get streamController => _streamController;


  Stream<T> on<T>() {
    if (T == dynamic) {
      return streamController.stream as Stream<T>;
    }
    return streamController.stream.where((dynamic e) => e is T).cast<T>();
  }

  /// Fires a new event on the event bus with the specified [event].
  void fire(dynamic event) {
    streamController.add(event);
  }

  /// Destroy this [EventBus]. This is generally only in a testing context.
  void destroy() {
    _streamController.close();
  }
}

EventBus eventBus = EventBus();