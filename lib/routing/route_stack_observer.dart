import 'package:flutter/material.dart';

import '../channel/route_channel.dart';

/// Navigator 路由栈观察器。
///
/// 功能：在每次路由 pop 后，检测当前 Navigator 栈深度。
/// 如果只剩 1 个路由（即预热阶段的 `flutter/root` 根路由），
/// 说明用户已经退出了所有业务页面，此时主动通知原生关闭 Flutter 容器。
///
/// 对应生产代码的逻辑：
/// Flutter 端 Navigator.pop → 路由栈 ≤ 1 时 → 调 `RouteAPI.removeFlutterContainer(instanceId)`
/// → 原生 finish Activity。
///
/// 为什么不直接调 `SystemNavigator.pop()`？
/// 因为主引擎是常驻的（keepEmpty），调 SystemNavigator.pop 会把整个引擎杀掉，
/// 我们只需要关掉 Activity 容器，引擎要留着下次复用。
class RouteStackObserver extends NavigatorObserver {
  /// 当前容器的 instanceId，从 nativeParams 里获取，传给原生用于定位哪个容器要关。
  String? _instanceId;

  /// 当前栈深度。
  int _routeCount = 0;

  /// 设置当前容器的 instanceId。
  /// 在 [_onGenerateRoute] 解析到 instanceId 后调用一次即可。
  void setInstanceId(String? id) => _instanceId = id;

  @override
  void didPush(Route route, Route? previousRoute) {
    _routeCount++;
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _routeCount--;
    _checkAndRemoveContainer();
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    _routeCount--;
    _checkAndRemoveContainer();
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    // replace 不改变栈深度
  }

  void _checkAndRemoveContainer() {
    // 栈里只剩 1 个路由 = 预热时的根路由 `flutter/root`（空白 Scaffold）。
    // 说明业务页面都退完了，通知原生关 Activity。
    if (_routeCount <= 1 && _instanceId != null) {
      RouteChannel.removeFlutterContainer(_instanceId!);
    }
  }
}
