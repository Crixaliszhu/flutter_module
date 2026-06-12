import 'dart:async';

import 'package:flutter/services.dart';

/// 原生 → Flutter 单向事件通道。
///
/// 真实项目用 Pigeon 的 `@FlutterApi` 生成 `EventFlutterAPI.onReceiveEvent(...)`，
/// 这里改成 MethodChannel 反向注册：原生 `BasicMessageChannel.send` / `MethodChannel.invokeMethod`
/// 调进来时统一进 [_handler]，再以 [Stream] 形式分发给 UI。
///
/// 用法：
/// ```dart
/// EventChannelBridge.instance.events.where((e) => e.name == 'tick').listen((_) {
///   setState(() => _count++);
/// });
/// ```
class EventChannelBridge {
  EventChannelBridge._();

  static final EventChannelBridge instance = EventChannelBridge._();

  static const _channel = MethodChannel('com.example.hybriddemo/event');

  final StreamController<NativeEvent> _controller =
      StreamController<NativeEvent>.broadcast();

  Stream<NativeEvent> get events => _controller.stream;

  void startListening() {
    _channel.setMethodCallHandler((call) async {
      // 约定：原生通过 `invokeMethod("onReceiveEvent", { name, arguments })` 推事件。
      if (call.method != 'onReceiveEvent') return null;
      final args = (call.arguments as Map?) ?? const {};
      final name = (args['name'] as String?) ?? '';
      final payload = (args['arguments'] as Map?) ?? const {};
      _controller.add(NativeEvent(
        name: name,
        arguments: Map<String, Object?>.from(payload),
      ));
      return null;
    });
  }
}

class NativeEvent {
  final String name;
  final Map<String, Object?> arguments;

  const NativeEvent({required this.name, this.arguments = const {}});
}
