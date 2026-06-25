import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_module/pigeon/event_bridge.dart';
import 'package:flutter_module/pigeon/generated/demo_bridge.g.dart';

void main() {
  test('event bridge emits native event pushed from flutter api', () async {
    final bridge = DemoEventBridge();
    final completer = Completer<NativeEvent>();
    final sub = bridge.events.listen(completer.complete);

    bridge.onReceiveEvent(NativeEvent(name: 'tick', arguments: <String?, Object?>{'ts': 1}));

    final event = await completer.future.timeout(const Duration(seconds: 1));
    expect(event.name, 'tick');
    expect(event.arguments?['ts'], 1);

    await sub.cancel();
    bridge.dispose();
  });
}
