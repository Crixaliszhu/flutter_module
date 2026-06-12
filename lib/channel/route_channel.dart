import 'package:flutter/services.dart';

/// 路由相关原生能力。
///
/// 对应 `RouterApiImpl`：
/// - [popRoute] 关闭当前 Flutter 容器并把结果带回原生。
/// - [pushNativeRoute] 让原生跳到一个原生页面。
/// - [pushFlutterRoute] 让原生再开一个 Flutter 容器，演示 native ↔ flutter 互跳。
class RouteChannel {
  static const _channel = MethodChannel('com.example.hybriddemo/route');

  static Future<void> popRoute([Map<String, Object?>? arguments]) async {
    await _channel.invokeMethod<void>('pop', arguments);
  }

  static Future<void> pushNativeRoute(
    String path, {
    Map<String, Object?>? arguments,
  }) async {
    await _channel.invokeMethod<void>('pushNative', <String, Object?>{
      'path': path,
      'arguments': arguments ?? <String, Object?>{},
    });
  }

  static Future<void> pushFlutterRoute(
    String path, {
    Map<String, Object?>? arguments,
  }) async {
    await _channel.invokeMethod<void>('pushFlutter', <String, Object?>{
      'path': path,
      'arguments': arguments ?? <String, Object?>{},
    });
  }
}
