import 'dart:async';

import 'package:flutter/material.dart';

import '../channel/device_info_channel.dart';
import '../channel/event_channel.dart';
import '../channel/route_channel.dart';
import '../channel/toast_channel.dart';
import '../main.dart';

/// Flutter 首页。
///
/// 演示：
/// - HostApi 调用：Toast / DeviceInfo
/// - Native ↔ Flutter 互跳：通过 RouteChannel
/// - FlutterApi 监听：原生通过 `tick` 事件推过来的计数
class HomePage extends StatefulWidget {
  final Map<String, Object?> arguments;

  const HomePage({super.key, required this.arguments});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _deviceInfo;
  int _tickCount = 0;
  StreamSubscription<NativeEvent>? _sub;

  @override
  void initState() {
    super.initState();
    _sub = EventChannelBridge.instance.events.where((e) => e.name == 'tick').listen((_) {
      setState(() => _tickCount++);
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entry = _formatEntryArgs();
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter 首页')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _section('启动参数（来自原生 Dart entrypoint args）', entry),
            const SizedBox(height: 12),
            _section('路由参数（来自 nativeParams）',
                widget.arguments.entries.map((e) => '${e.key} = ${e.value}').join('\n')),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => ToastChannel.show('Hello from Flutter'),
              child: const Text('① Toast 测试（HostApi）'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () async {
                final info = await DeviceInfoChannel.getInfo();
                setState(() => _deviceInfo = info.toString());
              },
              child: const Text('② 拿设备信息（HostApi 异步返回）'),
            ),
            if (_deviceInfo != null) ...[
              const SizedBox(height: 8),
              Text('设备：$_deviceInfo'),
            ],
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => RouteChannel.pushNativeRoute('demo://detail',
                  arguments: <String, Object?>{'from': 'flutter_home'}),
              child: const Text('③ 让原生跳一个原生页（HostApi）'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => RouteChannel.pushFlutterRoute('flutter/detail',
                  arguments: <String, Object?>{
                    'id': 999,
                    'title': '由 Flutter 触发的二级页',
                  }),
              child: const Text('④ 再开一个 Flutter 容器（HostApi）'),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('⑤ FlutterApi 演示（原生 → Flutter 单向事件）',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('收到 tick 次数：$_tickCount'),
                    const Text('在原生 MainActivity 点「向 Flutter 推事件」按钮可以看到计数变化。'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, String content) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(content.isEmpty ? '<空>' : content),
          ],
        ),
      ),
    );
  }
}

/// 单纯把 EntryArgs 序列化成可读字符串。
String _formatEntryArgs() {
  final args = AppConfig.entryArgs;
  return [
    'env: ${args.env}',
    'appVersion: ${args.appVersion}',
    'buildVersion: ${args.buildVersion}',
    'packageName: ${args.packageName}',
  ].join('\n');
}
