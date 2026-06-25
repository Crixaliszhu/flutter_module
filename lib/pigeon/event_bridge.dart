import 'dart:async';

import 'generated/demo_bridge.g.dart';

class DemoEventBridge implements EventFlutterApi {
  DemoEventBridge();

  final StreamController<NativeEvent> _controller =
      StreamController<NativeEvent>.broadcast();

  Stream<NativeEvent> get events => _controller.stream;

  void setUp() {
    EventFlutterApi.setUp(this);
  }

  @override
  void onReceiveEvent(NativeEvent event) {
    _controller.add(event);
  }

  void dispose() {
    _controller.close();
  }
}
