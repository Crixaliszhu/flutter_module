import 'package:flutter/services.dart';

/// 拿设备信息。
///
/// 演示「带返回值 + 异步」的 HostApi。生产代码对应 Pigeon 的 `@async` 方法。
class DeviceInfoChannel {
  static const _channel = MethodChannel('com.example.hybriddemo/device_info');

  static Future<DeviceInfo> getInfo() async {
    final raw = await _channel.invokeMapMethod<String, Object?>('getInfo');
    return DeviceInfo.fromMap(raw ?? const <String, Object?>{});
  }
}

class DeviceInfo {
  final String brand;
  final String model;
  final int sdkInt;

  const DeviceInfo({this.brand = '', this.model = '', this.sdkInt = 0});

  factory DeviceInfo.fromMap(Map<String, Object?> map) => DeviceInfo(
        brand: (map['brand'] as String?) ?? '',
        model: (map['model'] as String?) ?? '',
        sdkInt: (map['sdkInt'] as int?) ?? 0,
      );

  @override
  String toString() => 'brand=$brand, model=$model, sdkInt=$sdkInt';
}
