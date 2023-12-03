import 'package:event_bus/event_bus.dart';

class AppEventBus {
  EventBus _eventBus = EventBus();

  static AppEventBus? _instance;

  AppEventBus._();

  static AppEventBus get instance => _instance ??= AppEventBus._();

  Stream<T> on<T>() {
    return _eventBus.on<T>();
  }

  void fire(event) {
    _eventBus.fire(event);
  }
}
