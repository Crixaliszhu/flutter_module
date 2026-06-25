import 'package:flutter/services.dart';

/// 路由相关原生能力。
///
/// 对应 `RouterApiImpl`：
/// - [popRoute] 关闭当前 Flutter 容器并把结果带回原生。
/// - [removeFlutterContainer] 通知原生关闭当前 Flutter 容器（无返回数据）。
///   用于 Flutter Navigator pop 到最后一层时，主动告诉原生关掉 Activity。
/// - [pushNativeRoute] 让原生跳到一个原生页面。
/// - [pushFlutterRoute] 让原生再开一个 Flutter 容器，演示 native ↔ flutter 互跳。
class RouteChannel {
  static const _channel = MethodChannel('com.example.hybriddemo/route');

  /// 关闭当前 Flutter 容器并携带返回数据给原生侧（对应 setResult 模型）。
  static Future<void> popRoute([Map<String, Object?>? arguments]) async {
    await _channel.invokeMethod<void>('pop', arguments);
  }

  /// 通知原生关闭当前 Flutter 容器（无返回数据）。
  ///
  /// 与 [popRoute] 的区别：
  /// - [popRoute] 用于 Flutter 业务页面主动"带数据返回"。
  /// - [removeFlutterContainer] 用于 Flutter 端检测到路由栈只剩根路由时，
  ///   自动告诉原生关掉 Activity，避免白屏。
  ///
  /// 对应生产代码 `RouteAPI.removeFlutterContainer(instanceId: ...)`。
  static Future<void> removeFlutterContainer(String instanceId) async {
    await _channel.invokeMethod<void>('removeFlutterContainer', <String, Object?>{
      'instanceId': instanceId,
    });
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
