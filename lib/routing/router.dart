import 'package:flutter/material.dart';

import '../pages/detail_page.dart';
import '../pages/home_page.dart';

/// 路由参数构造器：返回 Widget。
///
/// 第二个参数是从 `nativeParams` + URL query + RouteSettings.arguments
/// 合并出来的统一 Map。
typedef PageBuilder = Widget Function(
  BuildContext context,
  Map<String, Object?> arguments,
);

/// 路由表。
///
/// 生产代码 (`easy_job_module/lib/routing/`) 会用 `build_runner` 自动生成，
/// 这里手写以便 demo 直观。
final Map<String, PageBuilder> routeMap = <String, PageBuilder>{
  'flutter/home': (_, args) => HomePage(arguments: args),
  'flutter/detail': (_, args) => DetailPage(arguments: args),
};
