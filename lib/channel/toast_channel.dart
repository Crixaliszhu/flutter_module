import 'package:flutter/services.dart';

/// 调用原生 Toast。
///
/// 真实项目里这是 Pigeon 自动生成的 `ToastHostApi.show(...)`，
/// 这里改成直接用 `MethodChannel`，省掉 codegen，便于 demo 阅读。
///
/// channel 命名约定：`com.example.hybriddemo/<api_name>`，原生侧必须用同名 channel 注册。
class ToastChannel {
  static const _channel = MethodChannel('com.example.hybriddemo/toast');

  static Future<void> show(String message) async {
    await _channel.invokeMethod<void>('show', <String, Object?>{
      'message': message,
    });
  }
}
