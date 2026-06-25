import 'dart:convert';

import 'package:flutter/material.dart';

import 'app/entry_args.dart';
import 'channel/event_channel.dart';
import 'routing/route_stack_observer.dart';
import 'routing/router.dart';

/// Demo 全局配置，存一下原生传过来的 EntryArgs，便于业务页面读取。
class AppConfig {
  static EntryArgs entryArgs = const EntryArgs();
}

/// 全局路由栈观察器实例。
///
/// 每个 Flutter 引擎只有一个 Navigator，挂一个 observer 就够了。
final RouteStackObserver routeStackObserver = RouteStackObserver();

/// Flutter Module 的 Dart 入口。
///
/// 注意签名 `void main(List<String> args)`：
/// - 原生引擎启动时通过 `FlutterEngineGroup.Options.setDartEntrypointArgs(...)`
///   把一个 JSON 字符串塞到 args[0]。
/// - 与生产代码 `easy_job_module/lib/main.dart` 保持一致。
void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.entryArgs = EntryArgs.parse(args);

  // 注册原生→Flutter 的事件通道（FlutterApi 等价物）。
  // 必须在 runApp 之前完成注册，避免错过原生预热阶段推过来的事件。
  EventChannelBridge.instance.startListening();

  runApp(const DemoApp());
}

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterHybridDemo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),

      // 挂载路由栈观察器，监控 Navigator pop 事件。
      navigatorObservers: [routeStackObserver],

      // 路由生成器：解析 `nativeParams` 协议，并按 [routeMap] 派发到具体页面。
      onGenerateRoute: _onGenerateRoute,
    );
  }

  /// 解析路由。
  ///
  /// 路由协议（与生产代码 `FlutterPageProxy.getFlutterRoute` 对齐）：
  /// `flutter/<path>?nativeParams=<json>`
  ///
  /// `nativeParams` 是一个 JSON 字符串，里头的字段会被展开成
  /// `RouteSettings.arguments`（Map）。原生还会把 `instanceId` 注入进来。
  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    final rawName = settings.name ?? '';
    final uri = Uri.parse(rawName);
    final purePath = uri.path.isEmpty ? rawName : uri.path;
    final builder = routeMap[purePath];

    final arguments = <String, Object?>{};

    // 1. 路由 query 参数（除 nativeParams 外）。
    uri.queryParameters.forEach((k, v) {
      if (k != 'nativeParams') arguments[k] = v;
    });

    // 2. nativeParams JSON 展开。
    final native = uri.queryParameters['nativeParams'];
    if (native != null && native.isNotEmpty) {
      try {
        final map = jsonDecode(native) as Map<String, dynamic>;
        arguments.addAll(map);
      } catch (_) {
        // 解析失败时忽略。生产代码会上报。
      }
    }

    // 3. 调用方通过 RouteSettings.arguments 透传的额外参数。
    final extra = settings.arguments;
    if (extra is Map) {
      arguments.addAll(Map<String, Object?>.from(extra));
    }

    final newSettings = RouteSettings(name: purePath, arguments: arguments);

    // 把当前容器的 instanceId 告诉 observer，用于栈空时通知原生关容器。
    final instanceId = arguments['instanceId'] as String?;
    if (instanceId != null) {
      routeStackObserver.setInstanceId(instanceId);
    }

    if (builder != null) {
      return MaterialPageRoute(
        settings: newSettings,
        builder: (ctx) => builder(ctx, arguments),
      );
    }

    // 兜底：默认根路由 `flutter/root`，供原生预热时使用。
    return MaterialPageRoute(
      settings: newSettings,
      builder: (_) => const Scaffold(body: SizedBox.shrink()),
    );
  }
}
