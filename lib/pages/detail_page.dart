import 'package:flutter/material.dart';

import '../pigeon/demo_bridge.dart';

/// 详情页。
///
/// 演示：
/// - 拿到 `nativeParams` 里 `id`、`title` 等字段。
/// - 通过 `RouteChannel.popRoute` 关闭页面并把结果带回原生（演示 setResult 模型）。
class DetailPage extends StatelessWidget {
  final Map<String, Object?> arguments;

  const DetailPage({super.key, required this.arguments});

  @override
  Widget build(BuildContext context) {
    final id = arguments['id'];
    final title = arguments['title'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter 详情页'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          // 直接走 Navigator.pop 也行；这里走 RouteChannel 演示「带数据返回原生」的能力。
          onPressed: () => DemoBridgeApis.route.popRoute(<String?, Object?>{
            'fromDetail': true,
            'echoId': id,
          }),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('id: $id', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('title: $title', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 24),
            const Text('全部参数：'),
            const SizedBox(height: 4),
            ...arguments.entries.map((e) => Text('• ${e.key} = ${e.value}')),
          ],
        ),
      ),
    );
  }
}
